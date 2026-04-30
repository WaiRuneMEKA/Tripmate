import 'package:flutter/material.dart';
import '../theme/tokens.dart';
import '../widgets/primitives.dart';

class SettleUpScreen extends StatelessWidget {
  final VoidCallback? onClose;
  const SettleUpScreen({super.key, this.onClose});

  static const _owe = [
    (
      to: (initials: 'S', color: TmColors.violet700, name: 'Sam'),
      amount: 38.0,
      detail: '1 expense · Hostel split',
    ),
  ];

  static const _owed = [
    (
      from: (initials: 'M', color: TmColors.amber500, name: 'Maya'),
      amount: 6.0,
      detail: 'Tuk-tuk to Belém',
    ),
    (
      from: (initials: 'J', color: TmColors.sky500, name: 'Jules'),
      amount: 2.25,
      detail: 'Train to Sintra',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final p = TmPalette.of(context);
    return Column(
      children: [
        TmTopBar(
          title: 'Settle up',
          leading: IconButtonBare(icon: Icons.close, onPressed: onClose),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 90),
            children: [
              Center(
                child: Column(
                  children: [
                    Text('YOUR NET BALANCE', style: TmType.overline(color: p.subtle)),
                    const SizedBox(height: 6),
                    Text(
                      '−€29.75',
                      style: TmType.mono(color: p.rose, size: 44, weight: FontWeight.w600)
                          .copyWith(letterSpacing: -0.88, height: 52 / 44),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Across 3 people in Lisbon → Porto',
                      style: TmType.body(color: p.muted).copyWith(fontSize: 14),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              _SectionHeader(label: 'YOU OWE', amount: '€38.00', color: p.rose),
              const SizedBox(height: 10),
              for (final row in _owe) _OweCard(row: row),
              const SizedBox(height: 18),
              _SectionHeader(label: 'OWED TO YOU', amount: '+€8.25', color: p.success),
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
                    for (var i = 0; i < _owed.length; i++)
                      _OwedRow(
                        row: _owed[i],
                        last: i == _owed.length - 1,
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

class _SectionHeader extends StatelessWidget {
  final String label;
  final String amount;
  final Color color;
  const _SectionHeader({
    required this.label,
    required this.amount,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final p = TmPalette.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Expanded(
          child: Text(
            label,
            style: TmType.overline(color: p.muted).copyWith(fontSize: 13, fontWeight: FontWeight.w600),
          ),
        ),
        Text(amount, style: TmType.mono(color: color, size: 13)),
      ],
    );
  }
}

class _OweCard extends StatelessWidget {
  final ({
    ({String initials, Color color, String name}) to,
    double amount,
    String detail,
  }) row;
  const _OweCard({required this.row});

  @override
  Widget build(BuildContext context) {
    final p = TmPalette.of(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: p.surf,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: p.border),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Avatar(initials: row.to.initials, color: row.to.color, size: 40, ring: p.surf),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Pay ${row.to.name}',
                      style: TmType.body(color: p.fg, weight: FontWeight.w500),
                    ),
                    const SizedBox(height: 1),
                    Text(row.detail, style: TmType.small(color: p.muted)),
                  ],
                ),
              ),
              Text(
                '€${row.amount.toStringAsFixed(2)}',
                style: TmType.mono(color: p.rose, size: 18, weight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TmButton(
                  small: true,
                  fullWidth: true,
                  child: Text('Pay €${row.amount.toStringAsFixed(2)}'),
                ),
              ),
              const SizedBox(width: 8),
              TmButton(
                variant: TmButtonVariant.secondary,
                small: true,
                child: const Text('Mark paid'),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (final m in const ['Wise', 'Revolut', 'Cash', 'Bank']) ...[
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: p.surfSunken,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    m,
                    style: TmType.caption(color: p.muted).copyWith(fontSize: 11),
                  ),
                ),
                const SizedBox(width: 6),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _OwedRow extends StatelessWidget {
  final ({
    ({String initials, Color color, String name}) from,
    double amount,
    String detail,
  }) row;
  final bool last;
  const _OwedRow({required this.row, required this.last});

  @override
  Widget build(BuildContext context) {
    final p = TmPalette.of(context);
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        border: Border(
          bottom: last ? BorderSide.none : BorderSide(color: p.borderSoft),
        ),
      ),
      child: Row(
        children: [
          Avatar(initials: row.from.initials, color: row.from.color, size: 36, ring: p.surf),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${row.from.name} owes you',
                  style: TmType.body(color: p.fg, weight: FontWeight.w500),
                ),
                const SizedBox(height: 1),
                Text(row.detail, style: TmType.small(color: p.muted)),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '+€${row.amount.toStringAsFixed(2)}',
            style: TmType.mono(color: p.success, size: 16, weight: FontWeight.w600),
          ),
          const SizedBox(width: 8),
          TmButton(
            variant: TmButtonVariant.secondary,
            small: true,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text('Remind', style: TmType.caption(color: p.fg).copyWith(fontSize: 12)),
          ),
        ],
      ),
    );
  }
}
