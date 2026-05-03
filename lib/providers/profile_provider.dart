import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserProfile {
  final String name;
  final String username;
  final String location;
  final String email;
  final int countriesVisited;
  final int tripsCount;
  final int daysCount;
  const UserProfile({
    required this.name,
    required this.username,
    required this.location,
    required this.email,
    required this.countriesVisited,
    required this.tripsCount,
    required this.daysCount,
  });
  UserProfile copyWith({
    String? name,
    String? username,
    String? location,
    String? email,
    int? countriesVisited,
    int? tripsCount,
    int? daysCount,
  }) =>
      UserProfile(
        name: name ?? this.name,
        username: username ?? this.username,
        location: location ?? this.location,
        email: email ?? this.email,
        countriesVisited: countriesVisited ?? this.countriesVisited,
        tripsCount: tripsCount ?? this.tripsCount,
        daysCount: daysCount ?? this.daysCount,
      );
}

class ProfileNotifier extends Notifier<UserProfile> {
  @override
  UserProfile build() => const UserProfile(
        name: 'Yotam Ovadia',
        username: '@yotam',
        location: 'Tel Aviv',
        email: 'yotam@example.com',
        countriesVisited: 23,
        tripsCount: 14,
        daysCount: 187,
      );
  void update(UserProfile profile) => state = profile;
}

final profileProvider =
    NotifierProvider<ProfileNotifier, UserProfile>(ProfileNotifier.new);

// ---- Notifications ----

class NotifSettings {
  final bool itinerary;
  final bool balances;
  final bool newMember;
  final bool reminders;
  const NotifSettings({
    this.itinerary = true,
    this.balances = true,
    this.newMember = false,
    this.reminders = true,
  });
  NotifSettings copyWith({
    bool? itinerary,
    bool? balances,
    bool? newMember,
    bool? reminders,
  }) =>
      NotifSettings(
        itinerary: itinerary ?? this.itinerary,
        balances: balances ?? this.balances,
        newMember: newMember ?? this.newMember,
        reminders: reminders ?? this.reminders,
      );
}

class NotifNotifier extends Notifier<NotifSettings> {
  @override
  NotifSettings build() => const NotifSettings();
  void toggle(String field) {
    state = switch (field) {
      'itinerary' => state.copyWith(itinerary: !state.itinerary),
      'balances' => state.copyWith(balances: !state.balances),
      'newMember' => state.copyWith(newMember: !state.newMember),
      'reminders' => state.copyWith(reminders: !state.reminders),
      _ => state,
    };
  }
}

final notifSettingsProvider =
    NotifierProvider<NotifNotifier, NotifSettings>(NotifNotifier.new);

// ---- Privacy ----

enum TripVisibility { everyone, friends, onlyMe }

class PrivacySettings {
  final TripVisibility tripVisibility;
  final bool showLocation;
  const PrivacySettings({
    this.tripVisibility = TripVisibility.friends,
    this.showLocation = true,
  });
  PrivacySettings copyWith({
    TripVisibility? tripVisibility,
    bool? showLocation,
  }) =>
      PrivacySettings(
        tripVisibility: tripVisibility ?? this.tripVisibility,
        showLocation: showLocation ?? this.showLocation,
      );
}

class PrivacyNotifier extends Notifier<PrivacySettings> {
  @override
  PrivacySettings build() => const PrivacySettings();
  void setVisibility(TripVisibility v) =>
      state = state.copyWith(tripVisibility: v);
  void toggleLocation() =>
      state = state.copyWith(showLocation: !state.showLocation);
}

final privacyProvider =
    NotifierProvider<PrivacyNotifier, PrivacySettings>(PrivacyNotifier.new);
