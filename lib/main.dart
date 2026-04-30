import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

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
  runApp(const TripmateApp());
}

class TripmateApp extends StatefulWidget {
  const TripmateApp({super.key});

  @override
  State<TripmateApp> createState() => _TripmateAppState();
}

class _TripmateAppState extends State<TripmateApp> {
  ThemeMode mode = ThemeMode.light;

  void toggleTheme() => setState(() {
        mode = mode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
      });

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
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tripmate',
      debugShowCheckedModeBanner: false,
      theme: _theme(Brightness.light),
      darkTheme: _theme(Brightness.dark),
      themeMode: mode,
      home: AppShell(onToggleTheme: toggleTheme),
    );
  }
}

enum _Route {
  onboarding,
  trips,
  tripOverview,
  tripTimeline,
  tripMap,
  tripCalendar,
  cityMap,
  expenses,
  addExpense,
  settle,
  discover,
  profile,
}

class AppShell extends StatefulWidget {
  final VoidCallback onToggleTheme;
  const AppShell({super.key, required this.onToggleTheme});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  _Route route = _Route.onboarding;

  TmTab _tabFor(_Route r) {
    switch (r) {
      case _Route.trips:
      case _Route.tripOverview:
      case _Route.tripTimeline:
      case _Route.tripMap:
      case _Route.tripCalendar:
        return TmTab.trips;
      case _Route.cityMap:
        return TmTab.map;
      case _Route.expenses:
      case _Route.addExpense:
      case _Route.settle:
        return TmTab.expenses;
      case _Route.discover:
        return TmTab.discover;
      case _Route.profile:
        return TmTab.profile;
      case _Route.onboarding:
        return TmTab.trips;
    }
  }

  void _onTab(TmTab tab) {
    setState(() {
      switch (tab) {
        case TmTab.trips:
          route = _Route.trips;
          break;
        case TmTab.map:
          route = _Route.cityMap;
          break;
        case TmTab.expenses:
          route = _Route.expenses;
          break;
        case TmTab.discover:
          route = _Route.discover;
          break;
        case TmTab.profile:
          route = _Route.profile;
          break;
      }
    });
  }

  bool get _showTabBar =>
      route != _Route.onboarding &&
      route != _Route.addExpense &&
      route != _Route.settle &&
      route != _Route.tripMap &&
      route != _Route.cityMap;

  @override
  Widget build(BuildContext context) {
    final p = TmPalette.of(context);
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: p.dark ? Brightness.light : Brightness.dark,
        systemNavigationBarColor: p.bg,
        systemNavigationBarIconBrightness: p.dark ? Brightness.light : Brightness.dark,
      ),
    );
    return Scaffold(
      body: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, _) {
          if (didPop) return;
          if (_canGoBack()) _goBack();
        },
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 220),
          switchInCurve: Curves.easeOutCubic,
          child: KeyedSubtree(
            key: ValueKey(route),
            child: _renderRoute(),
          ),
        ),
      ),
      bottomNavigationBar:
          _showTabBar ? TmTabBar(active: _tabFor(route), onChanged: _onTab) : null,
    );
  }

  bool _canGoBack() {
    return route == _Route.tripOverview ||
        route == _Route.tripTimeline ||
        route == _Route.tripMap ||
        route == _Route.tripCalendar ||
        route == _Route.addExpense ||
        route == _Route.settle ||
        route == _Route.cityMap;
  }

  void _goBack() {
    setState(() {
      switch (route) {
        case _Route.tripOverview:
          route = _Route.trips;
          break;
        case _Route.tripTimeline:
        case _Route.tripMap:
        case _Route.tripCalendar:
          route = _Route.tripOverview;
          break;
        case _Route.addExpense:
        case _Route.settle:
          route = _Route.expenses;
          break;
        case _Route.cityMap:
          route = _Route.trips;
          break;
        default:
          break;
      }
    });
  }

  Widget _renderRoute() {
    switch (route) {
      case _Route.onboarding:
        return OnboardingScreen(
          onStart: () => setState(() => route = _Route.trips),
          onLogin: () => setState(() => route = _Route.trips),
        );
      case _Route.trips:
        return TripsScreen(
          onOpen: (_) => setState(() => route = _Route.tripOverview),
        );
      case _Route.tripOverview:
        return TripOverviewScreen(
          onBack: () => setState(() => route = _Route.trips),
          onOpenTimeline: () => setState(() => route = _Route.tripTimeline),
          onOpenMap: () => setState(() => route = _Route.tripMap),
          onOpenCalendar: () => setState(() => route = _Route.tripCalendar),
          onOpenExpenses: () => setState(() => route = _Route.expenses),
        );
      case _Route.tripTimeline:
        return TripTimelineScreen(
          onBack: () => setState(() => route = _Route.tripOverview),
          onSwitchMap: () => setState(() => route = _Route.tripMap),
          onSwitchCalendar: () => setState(() => route = _Route.tripCalendar),
        );
      case _Route.tripMap:
        return TripMapScreen(
          onBack: () => setState(() => route = _Route.tripOverview),
          onSwitchTimeline: () => setState(() => route = _Route.tripTimeline),
        );
      case _Route.tripCalendar:
        return TripCalendarScreen(
          onBack: () => setState(() => route = _Route.tripOverview),
          onSwitchTimeline: () => setState(() => route = _Route.tripTimeline),
          onSwitchMap: () => setState(() => route = _Route.tripMap),
        );
      case _Route.cityMap:
        return CityMapScreen(
          onBack: () => setState(() => route = _Route.trips),
        );
      case _Route.expenses:
        return ExpenseListScreen(
          onAdd: () => setState(() => route = _Route.addExpense),
          onSettle: () => setState(() => route = _Route.settle),
        );
      case _Route.addExpense:
        return AddExpenseScreen(
          onClose: () => setState(() => route = _Route.expenses),
        );
      case _Route.settle:
        return SettleUpScreen(
          onClose: () => setState(() => route = _Route.expenses),
        );
      case _Route.discover:
        return const DiscoverScreen();
      case _Route.profile:
        return ProfileScreen(onToggleTheme: widget.onToggleTheme);
    }
  }
}
