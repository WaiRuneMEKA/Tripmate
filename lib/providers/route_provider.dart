import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/tab_bar.dart';

enum AppRoute {
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
  createTrip,
  editProfile,
  notifications,
  privacy,
  helpCenter,
}

final routeProvider = NotifierProvider<RouteController, AppRoute>(
  RouteController.new,
);

class RouteController extends Notifier<AppRoute> {
  @override
  AppRoute build() => AppRoute.onboarding;

  void goTo(AppRoute r) => state = r;

  void selectTab(TmTab tab) {
    state = switch (tab) {
      TmTab.trips => AppRoute.trips,
      TmTab.map => AppRoute.cityMap,
      TmTab.expenses => AppRoute.expenses,
      TmTab.discover => AppRoute.discover,
      TmTab.profile => AppRoute.profile,
    };
  }

  TmTab tabFor(AppRoute r) => switch (r) {
    AppRoute.trips ||
    AppRoute.tripOverview ||
    AppRoute.tripTimeline ||
    AppRoute.tripMap ||
    AppRoute.tripCalendar =>
      TmTab.trips,
    AppRoute.cityMap => TmTab.map,
    AppRoute.expenses ||
    AppRoute.addExpense ||
    AppRoute.settle =>
      TmTab.expenses,
    AppRoute.discover => TmTab.discover,
    AppRoute.profile => TmTab.profile,
    AppRoute.createTrip => TmTab.trips,
    AppRoute.onboarding => TmTab.trips,
    AppRoute.editProfile ||
    AppRoute.notifications ||
    AppRoute.privacy ||
    AppRoute.helpCenter =>
      TmTab.profile,
  };

  bool get canGoBack => switch (state) {
    AppRoute.tripOverview ||
    AppRoute.tripTimeline ||
    AppRoute.tripMap ||
    AppRoute.tripCalendar ||
    AppRoute.addExpense ||
    AppRoute.settle ||
    AppRoute.cityMap ||
    AppRoute.createTrip ||
    AppRoute.editProfile ||
    AppRoute.notifications ||
    AppRoute.privacy ||
    AppRoute.helpCenter =>
      true,
    _ => false,
  };

  void goBack() {
    state = switch (state) {
      AppRoute.tripOverview => AppRoute.trips,
      AppRoute.tripTimeline ||
      AppRoute.tripMap ||
      AppRoute.tripCalendar =>
        AppRoute.tripOverview,
      AppRoute.addExpense || AppRoute.settle => AppRoute.expenses,
      AppRoute.cityMap => AppRoute.trips,
      AppRoute.createTrip => AppRoute.trips,
      AppRoute.editProfile ||
      AppRoute.notifications ||
      AppRoute.privacy ||
      AppRoute.helpCenter =>
        AppRoute.profile,
      _ => state,
    };
  }

  bool get showTabBar => switch (state) {
    AppRoute.onboarding ||
    AppRoute.addExpense ||
    AppRoute.settle ||
    AppRoute.tripMap ||
    AppRoute.cityMap ||
    AppRoute.createTrip ||
    AppRoute.editProfile ||
    AppRoute.notifications ||
    AppRoute.privacy ||
    AppRoute.helpCenter =>
      false,
    _ => true,
  };
}
