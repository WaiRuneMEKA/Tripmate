import 'package:flutter/material.dart';
import '../theme/tokens.dart';
import 'primitives.dart';

class SplitRowData {
  final List<({String initials, Color color})> people;
  final String title;
  final String sub;
  final String amount;
  final String who;
  final int balance;
  const SplitRowData({
    required this.people,
    required this.title,
    required this.sub,
    required this.amount,
    required this.who,
    required this.balance,
  });
}

class SplitRow extends StatelessWidget {
  final SplitRowData row;
  const SplitRow({super.key, required this.row});

  @override
  Widget build(BuildContext context) {
    final p = TmPalette.of(context);
    final owe = row.balance < 0;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: p.borderSoft)),
      ),
      child: Row(
        children: [
          AvatarStack(people: row.people, size: 32, ring: p.bg),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  row.title,
                  style: TmType.body(color: p.fg, weight: FontWeight.w500),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(row.sub, style: TmType.small(color: p.muted)),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${owe ? '−' : '+'}${row.amount}',
                style: TmType.mono(
                  color: owe ? p.rose : p.success,
                  size: 16,
                  weight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                owe ? 'you owe ${row.who}' : '${row.who} owes you',
                style: TmType.caption(color: p.muted),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
