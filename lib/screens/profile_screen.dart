import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../l10n/app_localizations.dart';
import '../providers/locale_provider.dart';
import '../providers/theme_provider.dart';
import '../theme/tokens.dart';
import '../widgets/primitives.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final p = TmPalette.of(context);
    final l = AppLocalizations.of(context)!;
    final locale = ref.watch(localeProvider);
    final toggleTheme = ref.read(themeModeProvider.notifier).toggle;
    final isThai = locale.languageCode == 'th';
    final sections = <({String title, List<_RowSpec> rows})>[
      (
        title: 'ACCOUNT',
        rows: [
          _RowSpec(icon: Icons.person_outline, label: 'Personal info', sub: 'Name, email, phone'),
          _RowSpec(icon: Icons.notifications_outlined, label: 'Notifications', sub: 'Itinerary changes, balances'),
          _RowSpec(icon: Icons.lock_outline, label: 'Privacy', sub: 'Who can see your trips'),
        ],
      ),
      (
        title: 'PREFERENCES',
        rows: [
          _RowSpec(
            icon: Icons.dark_mode_outlined,
            label: 'Appearance',
            sub: p.dark ? 'Dark' : 'Light',
            onTap: toggleTheme,
          ),
          _RowSpec(
            icon: Icons.language_outlined,
            label: l.settingLanguage,
            sub: isThai ? l.languageThai : l.languageEnglish,
            onTap: () => _showLanguagePicker(context, ref),
          ),
          _RowSpec(icon: Icons.account_balance_wallet_outlined, label: 'Default currency', sub: 'EUR · €'),
          _RowSpec(icon: Icons.map_outlined, label: 'Map style', sub: 'Muted (default)'),
        ],
      ),
      (
        title: 'ABOUT',
        rows: [
          _RowSpec(icon: Icons.help_outline, label: 'Help center'),
          _RowSpec(icon: Icons.star_border, label: 'Rate Tripmate'),
          _RowSpec(icon: Icons.logout, label: 'Log out', danger: true),
        ],
      ),
    ];

    return SafeArea(
      bottom: false,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 90),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Profile',
                    style: TmType.display(color: p.fg).copyWith(
                      fontSize: 28,
                      height: 34 / 28,
                      letterSpacing: -0.56,
                    ),
                  ),
                ),
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: p.border),
                  ),
                  child: Icon(Icons.more_horiz, size: 18, color: p.fg),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: p.surf,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: p.border),
            ),
            child: Row(
              children: [
                Avatar(initials: 'YO', color: TmColors.violet500, size: 64, ring: p.surf),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Yotam Ovadia',
                        style: TmType.h2(color: p.fg).copyWith(fontSize: 18, letterSpacing: -0.18),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '@yotam · Tel Aviv',
                        style: TmType.mono(color: p.muted, size: 13),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          for (final stat in const [
                            (value: '14', label: 'trips'),
                            (value: '187', label: 'days'),
                            (value: '23', label: 'countries'),
                          ]) ...[
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: stat.value,
                                    style: TmType.mono(color: p.fg, size: 14, weight: FontWeight.w600),
                                  ),
                                  TextSpan(
                                    text: ' ${stat.label}',
                                    style: TmType.caption(color: p.muted).copyWith(fontWeight: FontWeight.w400),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          // Pro upsell — gradient
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              gradient: TmColors.gradient,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'TRIPMATE PRO',
                  style: TmType.overline(color: Colors.white).copyWith(
                    letterSpacing: 0.96,
                    color: Colors.white.withValues(alpha: 0.85),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  l.proCardTagline,
                  style: TmType.h2(color: Colors.white).copyWith(fontSize: 20, letterSpacing: -0.20),
                ),
                const SizedBox(height: 4),
                Text(
                  l.proPricing,
                  style: TmType.small(color: Colors.white.withValues(alpha: 0.85)),
                ),
                const SizedBox(height: 14),
                SizedBox(
                  height: 38,
                  child: ElevatedButton(
                    onPressed: () => _showProBottomSheet(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: TmColors.violet700,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                    ),
                    child: Text(
                      l.proCardCta,
                      style: TmType.body(color: TmColors.violet700, weight: FontWeight.w500).copyWith(fontSize: 14),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          for (final sec in sections) ...[
            Text(
              sec.title,
              style: TmType.overline(color: p.muted).copyWith(fontSize: 13, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                color: p.surf,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: p.border),
              ),
              clipBehavior: Clip.antiAlias,
              child: Column(
                children: [
                  for (var i = 0; i < sec.rows.length; i++)
                    _SettingsRow(
                      spec: sec.rows[i],
                      last: i == sec.rows.length - 1,
                    ),
                ],
              ),
            ),
            const SizedBox(height: 18),
          ],
          Center(
            child: Text(
              'v 1.4.2 · build 8124',
              style: TmType.mono(color: p.subtle, size: 11),
            ),
          ),
        ],
      ),
    );
  }
}

class _RowSpec {
  final IconData icon;
  final String label;
  final String? sub;
  final bool danger;
  final VoidCallback? onTap;
  const _RowSpec({
    required this.icon,
    required this.label,
    this.sub,
    this.danger = false,
    this.onTap,
  });
}

class _SettingsRow extends StatelessWidget {
  final _RowSpec spec;
  final bool last;
  const _SettingsRow({required this.spec, required this.last});

  @override
  Widget build(BuildContext context) {
    final p = TmPalette.of(context);
    final iconBg = spec.danger
        ? (p.dark ? const Color(0xFF3A1F1B) : const Color(0xFFF4DDD9))
        : (p.dark ? TmColors.darkBorder : p.surfSunken);
    final iconFg = spec.danger ? p.rose : p.muted;
    return InkWell(
      onTap: spec.onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          border: Border(
            bottom: last ? BorderSide.none : BorderSide(color: p.borderSoft),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(spec.icon, size: 16, color: iconFg),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    spec.label,
                    style: TmType.body(
                      color: spec.danger ? p.rose : p.fg,
                      weight: FontWeight.w500,
                    ),
                  ),
                  if (spec.sub != null) ...[
                    const SizedBox(height: 1),
                    Text(spec.sub!, style: TmType.small(color: p.muted)),
                  ],
                ],
              ),
            ),
            if (!spec.danger)
              Icon(Icons.chevron_right, size: 18, color: p.subtle),
          ],
        ),
      ),
    );
  }
}

void _showProBottomSheet(BuildContext context) {
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: TmPalette.of(context).bg,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (ctx) {
      final p = TmPalette.of(ctx);
      final l = AppLocalizations.of(ctx)!;
      final features = <({IconData icon, String label})>[
        (icon: Icons.map_outlined, label: l.proFeatureMaps),
        (icon: Icons.all_inclusive, label: l.proFeatureUnlimited),
        (icon: Icons.block, label: l.proFeatureNoAds),
        (icon: Icons.support_agent, label: l.proFeatureSupport),
      ];
      return SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: p.borderStrong,
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Tripmate Pro',
                style: TmType.display(color: p.fg).copyWith(
                  fontSize: 24,
                  height: 30 / 24,
                  letterSpacing: -0.48,
                ),
              ),
              const SizedBox(height: 4),
              Text(l.proHeadline, style: TmType.body(color: p.muted)),
              const SizedBox(height: 20),
              for (final f in features) ...[
                Row(
                  children: [
                    Icon(f.icon, size: 20, color: p.accent),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(f.label, style: TmType.body(color: p.fg)),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
              ],
              const SizedBox(height: 4),
              Text(l.proPricing, style: TmType.small(color: p.muted)),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(ctx),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: TmColors.violet500,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    l.proCtaPrimary,
                    style: TmType.body(
                      color: Colors.white,
                      weight: FontWeight.w500,
                    ).copyWith(fontSize: 15),
                  ),
                ),
              ),
              const SizedBox(height: 4),
              SizedBox(
                width: double.infinity,
                height: 44,
                child: TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: Text(
                    l.proCtaSecondary,
                    style: TmType.body(
                      color: p.muted,
                      weight: FontWeight.w500,
                    ).copyWith(fontSize: 14),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

void _showLanguagePicker(BuildContext context, WidgetRef ref) {
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: TmPalette.of(context).bg,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (ctx) {
      final p = TmPalette.of(ctx);
      final l = AppLocalizations.of(ctx)!;
      final current = ref.read(localeProvider).languageCode;
      final options = <({String code, String label})>[
        (code: 'en', label: l.languageEnglish),
        (code: 'th', label: l.languageThai),
      ];
      return SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: p.borderStrong,
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                l.languagePickerTitle,
                style: TmType.h2(color: p.fg).copyWith(fontSize: 18, letterSpacing: -0.18),
              ),
              const SizedBox(height: 12),
              for (final o in options)
                InkWell(
                  onTap: () {
                    ref.read(localeProvider.notifier).setLocale(Locale(o.code));
                    Navigator.pop(ctx);
                  },
                  borderRadius: BorderRadius.circular(10),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 4),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(o.label, style: TmType.body(color: p.fg)),
                        ),
                        if (o.code == current)
                          Icon(Icons.check, size: 20, color: p.accent),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      );
    },
  );
}
