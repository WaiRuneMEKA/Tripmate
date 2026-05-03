You are Pane D. Create 2 new screen files for the Tripmate Flutter project.

=== TASK D: edit_notifications_screen.dart + edit_privacy_screen.dart ===

--- FILE 1: lib/screens/edit_notifications_screen.dart (CREATE NEW) ---

Full-screen notifications settings. Uses ConsumerWidget + notifSettingsProvider.

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../l10n/app_localizations.dart';
import '../providers/profile_provider.dart';
import '../theme/tokens.dart';

class NotificationsScreen extends ConsumerWidget {
  final VoidCallback onBack;
  const NotificationsScreen({super.key, required this.onBack});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final p = TmPalette.of(context);
    final l = AppLocalizations.of(context)!;
    final notif = ref.watch(notifSettingsProvider);
    final n = ref.read(notifSettingsProvider.notifier);

    final rows = [
      (label: l.notifItinerary, field: 'itinerary', value: notif.itinerary),
      (label: l.notifBalances, field: 'balances', value: notif.balances),
      (label: l.notifNewMember, field: 'newMember', value: notif.newMember),
      (label: l.notifReminders, field: 'reminders', value: notif.reminders),
    ];

    return SafeArea(
      bottom: false,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(4, 8, 16, 0),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.chevron_left, color: p.fg, size: 28),
                  onPressed: onBack,
                ),
                Expanded(
                  child: Text(
                    l.notifTitle,
                    style: TmType.h2(color: p.fg).copyWith(fontSize: 20, letterSpacing: -0.4),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 40),
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: p.surf,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: p.border),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    children: [
                      for (var i = 0; i < rows.length; i++)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: i == rows.length - 1
                                  ? BorderSide.none
                                  : BorderSide(color: p.borderSoft),
                            ),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(rows[i].label, style: TmType.body(color: p.fg)),
                              ),
                              Switch(
                                value: rows[i].value,
                                onChanged: (_) => n.toggle(rows[i].field),
                                activeThumbColor: p.accent,
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
```

--- FILE 2: lib/screens/edit_privacy_screen.dart (CREATE NEW) ---

Full-screen privacy settings. Uses ConsumerWidget + privacyProvider.

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../l10n/app_localizations.dart';
import '../providers/profile_provider.dart';
import '../theme/tokens.dart';

class PrivacyScreen extends ConsumerWidget {
  final VoidCallback onBack;
  const PrivacyScreen({super.key, required this.onBack});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final p = TmPalette.of(context);
    final l = AppLocalizations.of(context)!;
    final priv = ref.watch(privacyProvider);
    final pn = ref.read(privacyProvider.notifier);

    final visibilityOptions = [
      (value: TripVisibility.everyone, label: l.privacyEveryone),
      (value: TripVisibility.friends, label: l.privacyFriends),
      (value: TripVisibility.onlyMe, label: l.privacyOnlyMe),
    ];

    return SafeArea(
      bottom: false,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(4, 8, 16, 0),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.chevron_left, color: p.fg, size: 28),
                  onPressed: onBack,
                ),
                Expanded(
                  child: Text(
                    l.privacyTitle,
                    style: TmType.h2(color: p.fg).copyWith(fontSize: 20, letterSpacing: -0.4),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 40),
              children: [
                Text(l.privacyTripVisibility, style: TmType.small(color: p.muted)),
                const SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    color: p.surf,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: p.border),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    children: [
                      for (var i = 0; i < visibilityOptions.length; i++)
                        InkWell(
                          onTap: () => pn.setVisibility(visibilityOptions[i].value),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: i == visibilityOptions.length - 1
                                    ? BorderSide.none
                                    : BorderSide(color: p.borderSoft),
                              ),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    visibilityOptions[i].label,
                                    style: TmType.body(color: p.fg),
                                  ),
                                ),
                                if (priv.tripVisibility == visibilityOptions[i].value)
                                  Icon(Icons.check, size: 20, color: p.accent),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                    color: p.surf,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: p.border),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(l.privacyShowLocation, style: TmType.body(color: p.fg)),
                        ),
                        Switch(
                          value: priv.showLocation,
                          onChanged: (_) => pn.toggleLocation(),
                          activeThumbColor: p.accent,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
```

When done, write to .claude/inbox/A.md (append):
D done: edit_notifications_screen.dart + edit_privacy_screen.dart