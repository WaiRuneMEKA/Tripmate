You are Pane C. Make these 2 changes to the Tripmate Flutter project.

=== TASK C: profile_screen.dart + help_center_screen.dart ===

--- FILE 1: lib/screens/profile_screen.dart ---
The profile screen already exists. Make these targeted changes:

1. Add import at top: `import '../providers/route_provider.dart';`

2. REMOVE the entire _showPersonalInfoSheet function, _PersonalInfoSheet class, _PersonalInfoSheetState class, _Field class.
   REMOVE the entire _showNotifSheet function.
   REMOVE the entire _showPrivacySheet function.
   REMOVE the entire _showHelpSheet function.
   REMOVE the entire _showAppearancePicker function.
   REMOVE the _ToggleRow class.

3. In the sections list inside build():
   - Personal info row: change onTap to:
     onTap: () => ref.read(routeProvider.notifier).goTo(AppRoute.editProfile),
   - Notifications row: change onTap to:
     onTap: () => ref.read(routeProvider.notifier).goTo(AppRoute.notifications),
   - Privacy row: change onTap to:
     onTap: () => ref.read(routeProvider.notifier).goTo(AppRoute.privacy),
   - Help center row: change onTap to:
     onTap: () => ref.read(routeProvider.notifier).goTo(AppRoute.helpCenter),

4. REPLACE the Appearance _RowSpec with an inline custom widget.
   In the PREFERENCES section list, replace the Appearance _RowSpec(...) entry with a special marker,
   then in the section's column builder, detect it and render _AppearanceRow instead of _SettingsRow.

   The cleanest approach: add a bool `isAppearance` field to _RowSpec defaulting to false.
   Set it true for the appearance row. In the section Column builder:
     for (var i = 0; i < sec.rows.length; i++)
       sec.rows[i].isAppearance
         ? _AppearanceRow(last: i == sec.rows.length - 1)
         : _SettingsRow(spec: sec.rows[i], last: i == sec.rows.length - 1),

   Add `final bool isAppearance;` and `this.isAppearance = false` to _RowSpec.

   For the appearance _RowSpec, set isAppearance: true, onTap: null, and remove sub.

5. Add this new widget class _AppearanceRow:

```dart
class _AppearanceRow extends ConsumerWidget {
  final bool last;
  const _AppearanceRow({required this.last});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final p = TmPalette.of(context);
    final l = AppLocalizations.of(context)!;
    final mode = ref.watch(themeModeProvider);
    final options = [
      (mode: ThemeMode.system, label: 'Auto'),
      (mode: ThemeMode.light, label: l.appearanceLight),
      (mode: ThemeMode.dark, label: l.appearanceDark),
    ];
    final iconBg = p.dark ? TmColors.darkBorder : p.surfSunken;
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
      decoration: BoxDecoration(
        border: Border(
          bottom: last ? BorderSide.none : BorderSide(color: p.borderSoft),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 32, height: 32,
            decoration: BoxDecoration(color: iconBg, borderRadius: BorderRadius.circular(8)),
            child: Icon(Icons.dark_mode_outlined, size: 16, color: p.muted),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(l.profileAppearance, style: TmType.body(color: p.fg, weight: FontWeight.w500)),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: options.map((o) {
              final selected = mode == o.mode;
              return GestureDetector(
                onTap: () => ref.read(themeModeProvider.notifier).set(o.mode),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
                  margin: const EdgeInsets.only(left: 4),
                  decoration: BoxDecoration(
                    color: selected ? p.accent : Colors.transparent,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: selected ? p.accent : p.border),
                  ),
                  child: Text(
                    o.label,
                    style: TmType.small(color: selected ? Colors.white : p.muted),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
```

Also remove the `final themeMode = ref.watch(themeModeProvider);` line from ProfileScreen.build() since _AppearanceRow watches it directly.
Remove `appearanceSub()` local function from build().
Remove the Appearance sub from the _RowSpec (it's now handled inline).

--- FILE 2: lib/screens/help_center_screen.dart (CREATE NEW) ---

```dart
import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../theme/tokens.dart';

class HelpCenterScreen extends StatelessWidget {
  final VoidCallback onBack;
  const HelpCenterScreen({super.key, required this.onBack});

  @override
  Widget build(BuildContext context) {
    final p = TmPalette.of(context);
    final l = AppLocalizations.of(context)!;
    final faqs = [
      (q: l.helpFaq1Q, a: l.helpFaq1A),
      (q: l.helpFaq2Q, a: l.helpFaq2A),
      (q: l.helpFaq3Q, a: l.helpFaq3A),
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
                    l.helpTitle,
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
                for (final faq in faqs) ...[
                  Container(
                    padding: const EdgeInsets.all(16),
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: p.surf,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: p.border),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(faq.q, style: TmType.body(color: p.fg, weight: FontWeight.w600)),
                        const SizedBox(height: 6),
                        Text(faq.a, style: TmType.small(color: p.muted)),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
```

When done, write to .claude/inbox/A.md (append, do not overwrite):
C done: profile_screen.dart updated + help_center_screen.dart created