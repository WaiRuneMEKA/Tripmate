import 'package:flutter/material.dart';
import '../data/mock.dart';
import '../theme/tokens.dart';
import '../widgets/primitives.dart';

class TripCalendarScreen extends StatefulWidget {
  final VoidCallback? onBack;
  final VoidCallback? onSwitchTimeline;
  final VoidCallback? onSwitchMap;
  const TripCalendarScreen({
    super.key,
    this.onBack,
    this.onSwitchTimeline,
    this.onSwitchMap,
  });

  @override
  State<TripCalendarScreen> createState() => _TripCalendarScreenState();
}

class _TripCalendarScreenState extends State<TripCalendarScreen> {
  static const tripStart = 14;
  static const tripEnd = 22;
  static const weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  int selected = 17;

  static const _selectedSlots = [
    (time: '08:30', cat: TmCategory.stay, title: 'Selina Secret Garden', detail: 'Check-out · Bairro Alto'),
    (time: '09:15', cat: TmCategory.go, title: 'Bus to Coimbra', detail: '2h 27m · €13.50'),
    (time: '12:30', cat: TmCategory.eat, title: 'Café Santa Cruz', detail: '€12 avg · 0.2 km'),
    (time: '14:00', cat: TmCategory.see, title: 'Universidade de Coimbra', detail: 'Joanina Library · €13.50'),
  ];

  List<({int day, int month, bool dim})> _buildCells() {
    final cells = <({int day, int month, bool dim})>[];
    for (var d = 23; d <= 28; d++) {
      cells.add((day: d, month: 1, dim: true));
    }
    cells.add((day: 1, month: 2, dim: false));
    for (var d = 2; d <= 31; d++) {
      cells.add((day: d, month: 2, dim: false));
    }
    var next = 1;
    while (cells.length < 42) {
      cells.add((day: next++, month: 3, dim: true));
    }
    return cells;
  }

  String _rangePos(({int day, int month, bool dim}) cell) {
    if (cell.month != 2) return '';
    if (cell.day < tripStart || cell.day > tripEnd) return '';
    if (cell.day == tripStart && cell.day == tripEnd) return 'single';
    if (cell.day == tripStart) return 'start';
    if (cell.day == tripEnd) return 'end';
    return 'middle';
  }

  @override
  Widget build(BuildContext context) {
    final p = TmPalette.of(context);
    final cells = _buildCells();
    return Column(
      children: [
        TmTopBar(
          title: 'Lisbon → Porto',
          leading: IconButtonBare(icon: Icons.chevron_left, onPressed: widget.onBack),
          trailing: const IconButtonBare(icon: Icons.more_horiz, size: 20),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.only(bottom: 90),
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 6),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('TRIP DATES', style: TmType.overline(color: p.subtle)),
                    const SizedBox(height: 4),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text('Mar 14 – Mar 22', style: TmType.title(color: p.fg)),
                        const SizedBox(width: 10),
                        Text('9 days', style: TmType.mono(color: p.muted, size: 13)),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                child: Row(
                  children: [
                    TmChip(
                      onPressed: widget.onSwitchTimeline,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.menu_outlined, size: 14, color: p.fg),
                          const SizedBox(width: 4),
                          const Text('Timeline'),
                        ],
                      ),
                    ),
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
                      active: true,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(Icons.calendar_today_outlined, size: 14, color: Colors.white),
                          SizedBox(width: 4),
                          Text('Calendar'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('March 2026', style: TmType.h2(color: p.fg)),
                    Row(
                      children: const [
                        IconButtonBare(icon: Icons.chevron_left, size: 18),
                        IconButtonBare(icon: Icons.chevron_right, size: 18),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: GridView.count(
                  crossAxisCount: 7,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  childAspectRatio: 1.5,
                  children: [
                    for (final d in weekdays)
                      Center(
                        child: Text(
                          d.toUpperCase(),
                          style: TmType.overline(color: p.subtle).copyWith(letterSpacing: 0.4),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 4),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 7,
                    childAspectRatio: 1.0,
                    mainAxisExtent: 52,
                  ),
                  itemCount: cells.length,
                  itemBuilder: (_, i) => _CalCell(
                    cell: cells[i],
                    pos: _rangePos(cells[i]),
                    selected: selected,
                    onTap: () {
                      if (cells[i].month == 2 && !cells[i].dim) {
                        setState(() => selected = cells[i].day);
                      }
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'TUE · MAR $selected · DAY ${selected - tripStart + 1}',
                      style: TmType.overline(color: p.subtle),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      decoration: BoxDecoration(
                        color: p.surf,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: p.borderSoft),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: Column(
                        children: [
                          for (var i = 0; i < _selectedSlots.length; i++)
                            _DayPlanRow(
                              row: _selectedSlots[i],
                              last: i == _selectedSlots.length - 1,
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Wrap(
                  spacing: 14,
                  runSpacing: 6,
                  children: [
                    for (final entry in tmCategories.entries)
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: entry.value.color(p.dark),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            entry.value.label,
                            style: TmType.caption(color: p.muted).copyWith(fontSize: 11),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _CalCell extends StatelessWidget {
  final ({int day, int month, bool dim}) cell;
  final String pos;
  final int selected;
  final VoidCallback onTap;
  const _CalCell({
    required this.cell,
    required this.pos,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final p = TmPalette.of(context);
    final isSelected = !cell.dim && cell.month == 2 && cell.day == selected;
    final isToday = !cell.dim && cell.month == 2 && cell.day == 14;
    final plan = cell.month == 2 && dayPlan.containsKey(cell.day) ? dayPlan[cell.day] : null;
    final tripDayNumber = pos.isNotEmpty ? cell.day - _TripCalendarScreenState.tripStart + 1 : null;

    BorderRadius pillRadius = BorderRadius.zero;
    if (pos == 'start') pillRadius = const BorderRadius.horizontal(left: Radius.circular(999));
    if (pos == 'end') pillRadius = const BorderRadius.horizontal(right: Radius.circular(999));
    if (pos == 'single') pillRadius = BorderRadius.circular(999);

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (pos.isNotEmpty)
            Positioned(
              left: pos == 'start' || pos == 'single' ? 4 : 0,
              right: pos == 'end' || pos == 'single' ? 4 : 0,
              top: 6,
              bottom: 6,
              child: Container(
                decoration: BoxDecoration(
                  color: p.accentSoft,
                  borderRadius: pillRadius,
                ),
              ),
            ),
          if (isSelected)
            Positioned(
              left: 4,
              right: 4,
              top: 6,
              bottom: 6,
              child: Container(
                decoration: BoxDecoration(
                  color: p.dark
                      ? const Color(0x47A685FC)
                      : const Color(0xFFE5DCFF),
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(color: p.accent, width: 1.5),
                ),
              ),
            ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${cell.day}',
                style: TmType.mono(
                  color: cell.dim
                      ? (p.dark ? p.borderStrong : const Color(0xFFC7C2B3))
                      : p.fg,
                  size: 14,
                ),
              ),
              const SizedBox(height: 1),
              if (plan != null)
                Container(
                  width: 4,
                  height: 4,
                  decoration: BoxDecoration(
                    color: tmCategories[plan.cat]!.color(p.dark),
                    borderRadius: BorderRadius.circular(2),
                  ),
                )
              else if (pos.isNotEmpty)
                Text(
                  'D$tripDayNumber',
                  style: TmType.caption(color: p.muted).copyWith(fontSize: 8, letterSpacing: 0.4),
                ),
            ],
          ),
          if (isToday)
            Positioned(
              bottom: 4,
              child: Container(
                width: 4,
                height: 4,
                decoration: BoxDecoration(
                  color: p.accent,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _DayPlanRow extends StatelessWidget {
  final ({String time, TmCategory cat, String title, String detail}) row;
  final bool last;
  const _DayPlanRow({required this.row, required this.last});

  @override
  Widget build(BuildContext context) {
    final p = TmPalette.of(context);
    final def = tmCategories[row.cat]!;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        border: Border(bottom: last ? BorderSide.none : BorderSide(color: p.borderSoft)),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 36,
            child: Text(row.time, style: TmType.mono(color: p.muted, size: 11)),
          ),
          const SizedBox(width: 12),
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: def.color(p.dark),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(def.icon, size: 14, color: Colors.white),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  row.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TmType.body(color: p.fg, weight: FontWeight.w500).copyWith(fontSize: 14),
                ),
                const SizedBox(height: 1),
                Text(
                  row.detail,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TmType.caption(color: p.muted).copyWith(fontWeight: FontWeight.w400),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
