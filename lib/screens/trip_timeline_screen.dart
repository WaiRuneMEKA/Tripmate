import 'package:flutter/material.dart';
import '../data/mock.dart';
import '../theme/tokens.dart';
import '../widgets/primitives.dart';
import '../widgets/timeline_slot.dart';

class TripTimelineScreen extends StatefulWidget {
  final VoidCallback? onBack;
  final VoidCallback? onSwitchMap;
  final VoidCallback? onSwitchCalendar;
  const TripTimelineScreen({
    super.key,
    this.onBack,
    this.onSwitchMap,
    this.onSwitchCalendar,
  });

  @override
  State<TripTimelineScreen> createState() => _TripTimelineScreenState();
}

class _TripTimelineScreenState extends State<TripTimelineScreen> {
  int activeDay = 4;
  static const week = ['Sat', 'Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];

  @override
  Widget build(BuildContext context) {
    final p = TmPalette.of(context);
    return Column(
      children: [
        TmTopBar(
          title: 'Lisbon → Porto',
          leading: IconButtonBare(icon: Icons.chevron_left, onPressed: widget.onBack),
          trailing: const IconButtonBare(icon: Icons.more_horiz, size: 20),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          color: p.accentSoft,
          child: Row(
            children: [
              Avatar(
                initials: 'M',
                color: TmColors.amber500,
                size: 22,
                ring: p.accentSoft,
              ),
              const SizedBox(width: 10),
              Text(
                'Maya is editing now · Day $activeDay',
                style: TmType.small(color: p.accentSoftFg, weight: FontWeight.w500),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: p.borderSoft)),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('SPENT · DAY $activeDay', style: TmType.overline(color: p.subtle)),
                    const SizedBox(height: 4),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text('€84.50', style: TmType.mono(color: p.fg, size: 22, weight: FontWeight.w600)),
                        const SizedBox(width: 6),
                        Text(' / €110', style: TmType.small(color: p.muted, weight: FontWeight.w500)),
                      ],
                    ),
                  ],
                ),
              ),
              const TmChip(tone: TmChipTone.success, child: Text('on track')),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          child: SizedBox(
            height: 56,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: 8,
              separatorBuilder: (context, idx) => const SizedBox(width: 6),
              itemBuilder: (context, i) {
                final day = i + 1;
                final isActive = day == activeDay;
                return InkWell(
                  onTap: () => setState(() => activeDay = day),
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    width: 48,
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: isActive ? p.fg : p.surf,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: isActive ? Colors.transparent : p.border),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          week[day - 1],
                          style: TmType.caption(
                            color: isActive ? p.bg : p.fg,
                          ).copyWith(fontSize: 11, height: 1),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${13 + day}',
                          style: TmType.mono(
                            color: isActive ? p.bg : p.fg,
                            size: 16,
                            weight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
          child: Row(
            children: [
              const TmChip(active: true, child: Text('Timeline')),
              const SizedBox(width: 8),
              TmChip(
                onPressed: widget.onSwitchMap,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.map_outlined, size: 14, color: p.fg),
                    const SizedBox(width: 4),
                    const Text('Map'),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              TmChip(
                onPressed: widget.onSwitchCalendar,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.calendar_today_outlined, size: 14, color: p.fg),
                    const SizedBox(width: 4),
                    const Text('Calendar'),
                  ],
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 90),
            children: [
              for (var i = 0; i < daySlots.length; i++)
                TimelineSlot(
                  time: daySlots[i].time,
                  cat: daySlots[i].cat,
                  name: daySlots[i].name,
                  detail: daySlots[i].detail,
                  isLast: i == daySlots.length - 1,
                ),
              const SizedBox(height: 8),
              InkWell(
                onTap: () {},
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  height: 44,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: p.borderStrong, width: 1.5),
                  ),
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add, size: 14, color: p.muted),
                      const SizedBox(width: 6),
                      Text(
                        'Add to Day $activeDay',
                        style: TmType.body(color: p.muted, weight: FontWeight.w500).copyWith(fontSize: 14),
                      ),
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
