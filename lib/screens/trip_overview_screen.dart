import 'package:flutter/material.dart';
import '../theme/tokens.dart';
import '../widgets/primitives.dart';

class TripOverviewScreen extends StatelessWidget {
  final VoidCallback? onBack;
  final VoidCallback? onOpenTimeline;
  final VoidCallback? onOpenMap;
  final VoidCallback? onOpenCalendar;
  final VoidCallback? onOpenExpenses;

  const TripOverviewScreen({
    super.key,
    this.onBack,
    this.onOpenTimeline,
    this.onOpenMap,
    this.onOpenCalendar,
    this.onOpenExpenses,
  });

  @override
  Widget build(BuildContext context) {
    final p = TmPalette.of(context);
    return Column(
      children: [
        TmTopBar(
          title: 'Lisbon → Porto',
          leading: IconButtonBare(icon: Icons.chevron_left, onPressed: onBack),
          trailing: const IconButtonBare(icon: Icons.more_horiz, size: 20),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(0, 12, 0, 90),
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  height: 140,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFFF1ECFF),
                        Color(0xFFDFD3FF),
                        Color(0xFFC2ADFE),
                      ],
                      stops: [0, 0.6, 1],
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'DAY 4 OF 8',
                        style: TmType.overline(color: TmColors.violet700)
                            .copyWith(letterSpacing: 0.96),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Tuesday · Coimbra',
                        style: TmType.title(color: const Color(0xFF1F1F1D))
                            .copyWith(fontSize: 26, height: 30 / 26),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Mar 14 → Mar 22 · 3 travellers',
                        style: TmType.mono(color: TmColors.violet700, size: 13),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 1.6,
                  children: [
                    _StatCard(label: 'SPENT', value: '€612', sub: 'of €900 · 68%', progress: 0.68),
                    _StatCard(label: 'DAYS LEFT', value: '4', sub: 'check-out Mar 22'),
                    _StatCard(label: 'STOPS', value: '32', sub: '12 saved · 6 visited'),
                    _StatCard(label: 'DISTANCE', value: '284 km', sub: 'Lisbon → Coimbra'),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'TRAVELLERS',
                      style: TmType.overline(color: p.muted).copyWith(fontSize: 13, fontWeight: FontWeight.w600),
                    ),
                    Text('Invite', style: TmType.small(color: p.accent, weight: FontWeight.w500)),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  decoration: BoxDecoration(
                    color: p.surf,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: p.border),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    children: const [
                      _MemberRow(initials: 'YO', color: TmColors.violet500, name: 'You', role: 'owner', status: 'on track', live: false, last: false),
                      _MemberRow(initials: 'M', color: TmColors.amber500, name: 'Maya', role: 'editor', status: 'editing now', live: true, last: false),
                      _MemberRow(initials: 'J', color: TmColors.sky500, name: 'Jules', role: 'viewer', status: 'last seen 2h ago', live: false, last: true),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'PLAN',
                  style: TmType.overline(color: p.muted).copyWith(fontSize: 13, fontWeight: FontWeight.w600),
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  decoration: BoxDecoration(
                    color: p.surf,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: p.border),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    children: [
                      _PlanRow(icon: Icons.menu_outlined, label: 'Itinerary', sub: '8 days · 32 stops', onTap: onOpenTimeline),
                      _PlanRow(icon: Icons.account_balance_wallet_outlined, label: 'Expenses', sub: '€612 spent · −€38 your balance', onTap: onOpenExpenses),
                      _PlanRow(icon: Icons.map_outlined, label: 'Map', sub: '12 saved places', onTap: onOpenMap),
                      _PlanRow(icon: Icons.calendar_today_outlined, label: 'Bookings', sub: '3 confirmed · 1 pending', onTap: onOpenCalendar),
                      _PlanRow(icon: Icons.bookmark_outline, label: 'Saved notes', sub: '5 notes · 2 photos', last: true),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final String sub;
  final double? progress;
  const _StatCard({
    required this.label,
    required this.value,
    required this.sub,
    this.progress,
  });

  @override
  Widget build(BuildContext context) {
    final p = TmPalette.of(context);
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: p.surf,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: p.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TmType.overline(color: p.subtle)),
          const SizedBox(height: 4),
          Text(value, style: TmType.mono(color: p.fg, size: 22, weight: FontWeight.w600)),
          const SizedBox(height: 2),
          Text(sub, style: TmType.caption(color: p.muted).copyWith(fontWeight: FontWeight.w400)),
          if (progress != null) ...[
            const SizedBox(height: 8),
            Container(
              height: 4,
              decoration: BoxDecoration(
                color: p.borderSoft,
                borderRadius: BorderRadius.circular(2),
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: progress,
                child: Container(
                  decoration: BoxDecoration(
                    color: p.accent,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _MemberRow extends StatelessWidget {
  final String initials;
  final Color color;
  final String name;
  final String role;
  final String status;
  final bool live;
  final bool last;
  const _MemberRow({
    required this.initials,
    required this.color,
    required this.name,
    required this.role,
    required this.status,
    required this.live,
    required this.last,
  });

  @override
  Widget build(BuildContext context) {
    final p = TmPalette.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        border: Border(bottom: last ? BorderSide.none : BorderSide(color: p.borderSoft)),
      ),
      child: Row(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Avatar(initials: initials, color: color, size: 36, ring: p.surf),
              if (live)
                Positioned(
                  right: -2,
                  bottom: -2,
                  child: Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: TmColors.violet500,
                      shape: BoxShape.circle,
                      border: Border.all(color: p.surf, width: 2),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                RichText(
                  text: TextSpan(
                    style: TmType.body(color: p.fg, weight: FontWeight.w500),
                    children: [
                      TextSpan(text: name),
                      TextSpan(
                        text: '  · $role',
                        style: TmType.mono(color: p.subtle, size: 12),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 1),
                Text(
                  status,
                  style: TmType.small(color: live ? p.accent : p.muted),
                ),
              ],
            ),
          ),
          IconButtonBare(icon: Icons.more_horiz, size: 18, color: p.muted),
        ],
      ),
    );
  }
}

class _PlanRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String sub;
  final bool last;
  final VoidCallback? onTap;
  const _PlanRow({
    required this.icon,
    required this.label,
    required this.sub,
    this.last = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final p = TmPalette.of(context);
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          border: Border(bottom: last ? BorderSide.none : BorderSide(color: p.borderSoft)),
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: p.accentSoft,
                borderRadius: BorderRadius.circular(9),
              ),
              child: Icon(icon, size: 18, color: p.accentSoftFg),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(label, style: TmType.body(color: p.fg, weight: FontWeight.w500)),
                  const SizedBox(height: 1),
                  Text(sub, style: TmType.small(color: p.muted)),
                ],
              ),
            ),
            Icon(Icons.chevron_right, size: 18, color: p.subtle),
          ],
        ),
      ),
    );
  }
}
