import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../theme/tokens.dart';

enum TmTab { trips, map, expenses, discover, profile }

class TmTabBar extends StatelessWidget {
  final TmTab active;
  final ValueChanged<TmTab>? onChanged;
  const TmTabBar({super.key, required this.active, this.onChanged});

  @override
  Widget build(BuildContext context) {
    final p = TmPalette.of(context);
    final l = AppLocalizations.of(context)!;
    final tabs = [
      (TmTab.trips, l.tabTrips, Icons.menu_outlined),
      (TmTab.map, l.tabMap, Icons.map_outlined),
      (TmTab.expenses, l.tabExpenses, Icons.account_balance_wallet_outlined),
      (TmTab.discover, l.tabDiscover, Icons.search_outlined),
      (TmTab.profile, l.tabProfile, Icons.person_outline),
    ];
    return Container(
      decoration: BoxDecoration(
        color: p.dark
            ? TmColors.darkBg.withValues(alpha: 0.85)
            : Colors.white.withValues(alpha: 0.85),
        border: Border(top: BorderSide(color: p.border)),
      ),
      padding: EdgeInsets.only(
        top: 6,
        bottom: 14 + MediaQuery.of(context).padding.bottom,
      ),
      child: Row(
        children: [
          for (final (id, label, icon) in tabs)
            Expanded(
              child: InkWell(
                onTap: () => onChanged?.call(id),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        icon,
                        size: 22,
                        color: id == active ? p.fg : p.subtle,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        label,
                        style: TmType.caption(
                          color: id == active ? p.fg : p.subtle,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
