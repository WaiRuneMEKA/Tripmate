import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import 'l10n/app_localizations.dart';
import 'providers/locale_provider.dart';
import 'providers/route_provider.dart';
import 'providers/theme_provider.dart';
import 'theme/tokens.dart';
import 'widgets/tab_bar.dart';
import 'screens/onboarding_screen.dart';
import 'screens/trips_screen.dart';
import 'screens/trip_overview_screen.dart';
import 'screens/trip_timeline_screen.dart';
import 'screens/trip_map_screen.dart';
import 'screens/trip_calendar_screen.dart';
import 'screens/city_map_screen.dart';
import 'screens/expense_list_screen.dart';
import 'screens/add_expense_screen.dart';
import 'screens/settle_up_screen.dart';
import 'screens/discover_screen.dart';
import 'screens/profile_screen.dart';

void main() {
  runApp(const ProviderScope(child: TripmateApp()));
}

class TripmateApp extends ConsumerWidget {
  const TripmateApp({super.key});

  ThemeData _theme(Brightness b) {
    final dark = b == Brightness.dark;
    return ThemeData(
      brightness: b,
      useMaterial3: true,
      scaffoldBackgroundColor: dark ? TmColors.darkBg : TmColors.offWhite,
      colorScheme: ColorScheme.fromSeed(
        seedColor: TmColors.violet500,
        brightness: b,
        surface: dark ? TmColors.darkBg : TmColors.offWhite,
      ),
      textTheme: GoogleFonts.interTextTheme(
        dark ? ThemeData.dark().textTheme : ThemeData.light().textTheme,
      ),
      splashFactory: InkSparkle.splashFactory,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode = ref.watch(themeModeProvider);
    final locale = ref.watch(localeProvider);
    return MaterialApp(
      title: 'Tripmate',
      debugShowCheckedModeBanner: false,
      theme: _theme(Brightness.light),
      darkTheme: _theme(Brightness.dark),
      themeMode: mode,
      locale: locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const AppShell(),
    );
  }
}

class AppShell extends ConsumerWidget {
  const AppShell({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final route = ref.watch(routeProvider);
    final controller = ref.read(routeProvider.notifier);
    final p = TmPalette.of(context);
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: p.dark ? Brightness.light : Brightness.dark,
        systemNavigationBarColor: p.bg,
        systemNavigationBarIconBrightness:
            p.dark ? Brightness.light : Brightness.dark,
      ),
    );
    return Scaffold(
      body: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, _) {
          if (didPop) return;
          if (controller.canGoBack) controller.goBack();
        },
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 220),
          switchInCurve: Curves.easeOutCubic,
          child: KeyedSubtree(
            key: ValueKey(route),
            child: _renderRoute(route, controller),
          ),
        ),
      ),
      bottomNavigationBar: controller.showTabBar
          ? TmTabBar(active: controller.tabFor(route), onChanged: controller.selectTab)
          : null,
    );
  }

  Widget _renderRoute(AppRoute route, RouteController controller) {
    switch (route) {
      case AppRoute.onboarding:
        return OnboardingScreen(
          onStart: () => controller.goTo(AppRoute.trips),
          onLogin: () => controller.goTo(AppRoute.trips),
        );
      case AppRoute.trips:
        return TripsScreen(
          onOpen: (_) => controller.goTo(AppRoute.tripOverview),
        );
      case AppRoute.tripOverview:
        return TripOverviewScreen(
          onBack: () => controller.goTo(AppRoute.trips),
          onOpenTimeline: () => controller.goTo(AppRoute.tripTimeline),
          onOpenMap: () => controller.goTo(AppRoute.tripMap),
          onOpenCalendar: () => controller.goTo(AppRoute.tripCalendar),
          onOpenExpenses: () => controller.goTo(AppRoute.expenses),
        );
      case AppRoute.tripTimeline:
        return TripTimelineScreen(
          onBack: () => controller.goTo(AppRoute.tripOverview),
          onSwitchMap: () => controller.goTo(AppRoute.tripMap),
          onSwitchCalendar: () => controller.goTo(AppRoute.tripCalendar),
        );
      case AppRoute.tripMap:
        return TripMapScreen(
          onBack: () => controller.goTo(AppRoute.tripOverview),
          onSwitchTimeline: () => controller.goTo(AppRoute.tripTimeline),
        );
      case AppRoute.tripCalendar:
        return TripCalendarScreen(
          onBack: () => controller.goTo(AppRoute.tripOverview),
          onSwitchTimeline: () => controller.goTo(AppRoute.tripTimeline),
          onSwitchMap: () => controller.goTo(AppRoute.tripMap),
        );
      case AppRoute.cityMap:
        return CityMapScreen(
          onBack: () => controller.goTo(AppRoute.trips),
        );
      case AppRoute.expenses:
        return ExpenseListScreen(
          onAdd: () => controller.goTo(AppRoute.addExpense),
          onSettle: () => controller.goTo(AppRoute.settle),
        );
      case AppRoute.addExpense:
        return AddExpenseScreen(
          onClose: () => controller.goTo(AppRoute.expenses),
        );
      case AppRoute.settle:
        return SettleUpScreen(
          onClose: () => controller.goTo(AppRoute.expenses),
        );
      case AppRoute.discover:
        return const DiscoverScreen();
      case AppRoute.profile:
        return const ProfileScreen();
    }
  }
}
