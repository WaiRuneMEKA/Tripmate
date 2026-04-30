import 'package:flutter/material.dart';
import '../data/mock.dart';
import '../theme/tokens.dart';
import '../widgets/primitives.dart';
import '../widgets/split_row.dart';

class ExpenseListScreen extends StatelessWidget {
  final VoidCallback? onAdd;
  final VoidCallback? onSettle;
  const ExpenseListScreen({super.key, this.onAdd, this.onSettle});

  @override
  Widget build(BuildContext context) {
    final p = TmPalette.of(context);
    return Stack(
      children: [
        SafeArea(
          bottom: false,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 90),
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  'Expenses',
                  style: TmType.display(color: p.fg).copyWith(
                    fontSize: 28,
                    height: 34 / 28,
                    letterSpacing: -0.56,
                  ),
                ),
              ),
              Text(
                'Lisbon → Porto · €612 of €900',
                style: TmType.mono(color: p.muted, size: 13),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: p.surf,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: p.border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('YOUR BALANCE', style: TmType.overline(color: p.subtle)),
                    const SizedBox(height: 4),
                    Text(
                      '−€38.00',
                      style: TmType.mono(color: p.rose, size: 28, weight: FontWeight.w600),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'You owe Sam €38, Maya owes you €6.',
                      style: TmType.small(color: p.muted),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TmButton(
                            small: true,
                            fullWidth: true,
                            onPressed: onSettle,
                            child: const Text('Settle up'),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TmButton(
                            variant: TmButtonVariant.secondary,
                            small: true,
                            fullWidth: true,
                            child: const Text('View all'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              for (final r in expenseRows)
                SplitRow(
                  row: SplitRowData(
                    people: r.people,
                    title: r.title,
                    sub: r.sub,
                    amount: r.amount,
                    who: r.who,
                    balance: r.balance,
                  ),
                ),
            ],
          ),
        ),
        Positioned(
          right: 16,
          bottom: 16,
          child: SizedBox(
            width: 56,
            height: 56,
            child: Material(
              elevation: 6,
              borderRadius: BorderRadius.circular(28),
              shadowColor: Colors.black.withValues(alpha: 0.20),
              child: InkWell(
                onTap: onAdd,
                borderRadius: BorderRadius.circular(28),
                child: Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: TmColors.gradient,
                  ),
                  child: const Icon(Icons.add, color: Colors.white, size: 26),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
