import 'package:flutter/material.dart';
import '../theme/tokens.dart';
import '../widgets/primitives.dart';

class AddExpenseScreen extends StatefulWidget {
  final VoidCallback? onClose;
  const AddExpenseScreen({super.key, this.onClose});

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final amtCtrl = TextEditingController(text: '42.00');
  final whatCtrl = TextEditingController(text: 'Hostel · 2 nights');
  String paidBy = 'YOU';
  Set<String> splitWith = {'YOU', 'M', 'J'};
  TmCategory category = TmCategory.stay;

  static const _people = [
    (id: 'YOU', initials: 'YO', color: TmColors.violet500, name: 'You'),
    (id: 'M', initials: 'M', color: TmColors.amber500, name: 'Maya'),
    (id: 'J', initials: 'J', color: TmColors.sky500, name: 'Jules'),
    (id: 'S', initials: 'S', color: TmColors.violet700, name: 'Sam'),
  ];

  @override
  void dispose() {
    amtCtrl.dispose();
    whatCtrl.dispose();
    super.dispose();
  }

  String get share {
    final amt = double.tryParse(amtCtrl.text) ?? 0;
    return (amt / splitWith.length.clamp(1, 99)).toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    final p = TmPalette.of(context);
    return Column(
      children: [
        TmTopBar(
          title: 'Add expense',
          leading: IconButtonBare(icon: Icons.close, onPressed: widget.onClose),
          trailing: Text('Save', style: TmType.body(color: p.accent, weight: FontWeight.w500)),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            children: [
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 64,
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      decoration: BoxDecoration(
                        color: p.surf,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: p.border),
                      ),
                      child: Row(
                        children: [
                          Text('€', style: TmType.mono(color: p.muted, size: 22)),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextField(
                              controller: amtCtrl,
                              keyboardType: TextInputType.number,
                              style: TmType.mono(color: p.fg, size: 26, weight: FontWeight.w500),
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding: EdgeInsets.zero,
                              ),
                              onChanged: (_) => setState(() {}),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    width: 96,
                    height: 64,
                    decoration: BoxDecoration(
                      color: p.surf,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: p.border),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('EUR', style: TmType.body(color: p.fg, weight: FontWeight.w500).copyWith(fontSize: 16)),
                        const SizedBox(width: 4),
                        Icon(Icons.expand_more, size: 14, color: p.muted),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Center(
                child: Text(
                  '≈ ฿1,624 · USD 45.20',
                  style: TmType.mono(color: p.muted, size: 12),
                ),
              ),
              const SizedBox(height: 18),
              _SectionLabel(label: 'WHAT FOR'),
              const SizedBox(height: 8),
              TextField(
                controller: whatCtrl,
                style: TmType.body(color: p.fg),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: p.surf,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: p.border),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: p.border),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: p.accent),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                ),
              ),
              const SizedBox(height: 16),
              _SectionLabel(label: 'CATEGORY'),
              const SizedBox(height: 8),
              SizedBox(
                height: 36,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    for (final entry in tmCategories.entries) ...[
                      _CategoryChip(
                        cat: entry.key,
                        active: category == entry.key,
                        onTap: () => setState(() => category = entry.key),
                      ),
                      const SizedBox(width: 8),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 16),
              _SectionLabel(label: 'PAID BY'),
              const SizedBox(height: 8),
              SizedBox(
                height: 36,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    for (final pp in _people) ...[
                      _PaidByChip(
                        initials: pp.initials,
                        color: pp.color,
                        name: pp.name,
                        active: paidBy == pp.id,
                        onTap: () => setState(() => paidBy = pp.id),
                      ),
                      const SizedBox(width: 8),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _SectionLabel(label: 'SPLIT WITH'),
                  Text('€$share each', style: TmType.mono(color: p.muted, size: 12)),
                ],
              ),
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
                    for (var i = 0; i < _people.length; i++)
                      _SplitWithRow(
                        person: _people[i],
                        on: splitWith.contains(_people[i].id),
                        share: share,
                        last: i == _people.length - 1,
                        onTap: () => setState(() {
                          if (splitWith.contains(_people[i].id)) {
                            splitWith.remove(_people[i].id);
                          } else {
                            splitWith.add(_people[i].id);
                          }
                        }),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ],
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel({required this.label});
  @override
  Widget build(BuildContext context) {
    final p = TmPalette.of(context);
    return Text(label, style: TmType.overline(color: p.subtle));
  }
}

class _CategoryChip extends StatelessWidget {
  final TmCategory cat;
  final bool active;
  final VoidCallback onTap;
  const _CategoryChip({required this.cat, required this.active, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final p = TmPalette.of(context);
    final def = tmCategories[cat]!;
    return Material(
      color: active ? p.fg : p.surf,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          height: 36,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: active ? Colors.transparent : p.border),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(def.icon, size: 14, color: active ? p.bg : p.fg),
              const SizedBox(width: 6),
              Text(
                def.label,
                style: TmType.small(
                  color: active ? p.bg : p.fg,
                  weight: FontWeight.w500,
                ).copyWith(fontSize: 13),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PaidByChip extends StatelessWidget {
  final String initials;
  final Color color;
  final String name;
  final bool active;
  final VoidCallback onTap;
  const _PaidByChip({
    required this.initials,
    required this.color,
    required this.name,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final p = TmPalette.of(context);
    return Material(
      color: active ? p.accentSoft : p.surf,
      borderRadius: BorderRadius.circular(999),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: Container(
          height: 36,
          padding: const EdgeInsets.fromLTRB(6, 6, 10, 6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(999),
            border: Border.all(
              color: active ? (p.dark ? TmColors.violet600 : const Color(0xFFDFD3FF)) : p.border,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Avatar(initials: initials, color: color, size: 22, ring: active ? p.accentSoft : p.surf),
              const SizedBox(width: 6),
              Text(
                name,
                style: TmType.small(
                  color: active ? p.accentSoftFg : p.fg,
                  weight: FontWeight.w500,
                ).copyWith(fontSize: 13),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SplitWithRow extends StatelessWidget {
  final ({String id, String initials, Color color, String name}) person;
  final bool on;
  final String share;
  final bool last;
  final VoidCallback onTap;
  const _SplitWithRow({
    required this.person,
    required this.on,
    required this.share,
    required this.last,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final p = TmPalette.of(context);
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          border: Border(
            bottom: last ? BorderSide.none : BorderSide(color: p.borderSoft),
          ),
        ),
        child: Row(
          children: [
            Avatar(initials: person.initials, color: person.color, size: 28, ring: p.surf),
            const SizedBox(width: 12),
            Expanded(
              child: Text(person.name, style: TmType.body(color: p.fg, weight: FontWeight.w500)),
            ),
            SizedBox(
              width: 56,
              child: Text(
                on ? '€$share' : '—',
                textAlign: TextAlign.right,
                style: TmType.mono(
                  color: on ? p.fg : p.muted,
                  size: 14,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                color: on ? p.accent : Colors.transparent,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: on ? Colors.transparent : p.border,
                  width: 1.5,
                ),
              ),
              alignment: Alignment.center,
              child: on
                  ? const Icon(Icons.check, size: 14, color: Colors.white)
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
