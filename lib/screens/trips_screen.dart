import 'package:flutter/material.dart';
import '../data/mock.dart';
import '../l10n/app_localizations.dart';
import '../theme/tokens.dart';
import '../widgets/primitives.dart';

enum _TripFilter { all, live, drafts, past }

class TripsScreen extends StatefulWidget {
  final void Function(String tripId)? onOpen;
  const TripsScreen({super.key, this.onOpen});

  @override
  State<TripsScreen> createState() => _TripsScreenState();
}

class _TripsScreenState extends State<TripsScreen> {
  _TripFilter _filter = _TripFilter.all;

  @override
  Widget build(BuildContext context) {
    final p = TmPalette.of(context);
    final l = AppLocalizations.of(context)!;
    final visible = trips.where((t) => switch (_filter) {
          _TripFilter.all => true,
          _TripFilter.live => t.live,
          _TripFilter.drafts => t.draft,
          _TripFilter.past => !t.live && !t.draft,
        }).toList();
    return SafeArea(
      bottom: false,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(
              l.tripsTitle,
              style: TmType.display(color: p.fg).copyWith(
                fontSize: 28,
                height: 34 / 28,
                letterSpacing: -0.56,
              ),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 36,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                TmChip(
                  active: _filter == _TripFilter.all,
                  onPressed: () => setState(() => _filter = _TripFilter.all),
                  child: Text(l.filterAll),
                ),
                const SizedBox(width: 8),
                TmChip(
                  active: _filter == _TripFilter.live,
                  onPressed: () => setState(() => _filter = _TripFilter.live),
                  child: Text(l.filterLive),
                ),
                const SizedBox(width: 8),
                TmChip(
                  active: _filter == _TripFilter.drafts,
                  onPressed: () => setState(() => _filter = _TripFilter.drafts),
                  child: Text(l.filterDrafts),
                ),
                const SizedBox(width: 8),
                TmChip(
                  active: _filter == _TripFilter.past,
                  onPressed: () => setState(() => _filter = _TripFilter.past),
                  child: Text(l.filterPast),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          if (visible.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 32),
              child: Center(
                child: Text(
                  l.tripsEmpty,
                  style: TmType.body(color: p.muted),
                ),
              ),
            )
          else
            for (final t in visible) ...[
              _TripCard(trip: t, onTap: () => widget.onOpen?.call(t.id)),
              const SizedBox(height: 14),
            ],
          _NewTripButton(),
        ],
      ),
    );
  }
}

class _TripCard extends StatelessWidget {
  final TripData trip;
  final VoidCallback? onTap;
  const _TripCard({required this.trip, this.onTap});

  @override
  Widget build(BuildContext context) {
    final p = TmPalette.of(context);
    return Material(
      color: p.surf,
      borderRadius: const BorderRadius.all(TmRadius.lg),
      child: InkWell(
        onTap: onTap,
        borderRadius: const BorderRadius.all(TmRadius.lg),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(TmRadius.lg),
            border: Border.all(color: p.border),
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Container(
                    height: 96,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: trip.coverColors,
                      ),
                    ),
                  ),
                  if (trip.live)
                    Positioned(
                      top: 12,
                      left: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(6),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.06),
                              offset: const Offset(0, 1),
                              blurRadius: 2,
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 6,
                              height: 6,
                              decoration: const BoxDecoration(
                                color: TmColors.violet500,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Live now',
                              style: TmType.overline(color: TmColors.violet700)
                                  .copyWith(letterSpacing: 0, fontSize: 11, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                    ),
                  if (trip.draft)
                    Positioned(
                      top: 12,
                      left: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.55),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          'Draft',
                          style: TmType.overline(color: Colors.white)
                              .copyWith(letterSpacing: 0, fontSize: 11, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  Positioned(
                    top: 12,
                    right: 12,
                    child: AvatarStack(people: trip.members, size: 26, ring: Colors.white),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            trip.title,
                            style: TmType.h2(color: p.fg).copyWith(letterSpacing: -0.17),
                          ),
                        ),
                        Text(
                          '${trip.days}d',
                          style: TmType.mono(color: p.muted, size: 13),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(trip.dates, style: TmType.mono(color: p.muted, size: 13)),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        _Stat(label: 'Spent', value: trip.spent, color: p.fg),
                        Container(width: 1, height: 28, color: p.borderSoft, margin: const EdgeInsets.symmetric(horizontal: 14)),
                        _Stat(label: 'Budget', value: trip.budget, color: p.muted),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  const _Stat({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    final p = TmPalette.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label.toUpperCase(), style: TmType.overline(color: p.subtle)),
        const SizedBox(height: 2),
        Text(value, style: TmType.mono(color: color, size: 15)),
      ],
    );
  }
}

class _NewTripButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final p = TmPalette.of(context);
    final l = AppLocalizations.of(context)!;
    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(12),
      child: Container(
        height: 52,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: p.borderStrong, width: 1.5, style: BorderStyle.solid),
        ),
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add, size: 16, color: p.muted),
            const SizedBox(width: 8),
            Text(
              l.startNewTrip,
              style: TmType.body(color: p.muted, weight: FontWeight.w500).copyWith(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
