import 'package:flutter/material.dart';
import '../theme/tokens.dart';

class TimelineSlot extends StatelessWidget {
  final String time;
  final TmCategory cat;
  final String name;
  final String? detail;
  final bool isLast;
  final VoidCallback? onTap;

  const TimelineSlot({
    super.key,
    required this.time,
    required this.cat,
    required this.name,
    this.detail,
    this.isLast = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final p = TmPalette.of(context);
    final def = tmCategories[cat]!;
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: IntrinsicHeight(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 14, right: 14),
                child: SizedBox(
                  width: 44,
                  child: Text(
                    time,
                    textAlign: TextAlign.right,
                    style: TmType.mono(color: p.muted, size: 12),
                  ),
                ),
              ),
              SizedBox(
                width: 24,
                child: Stack(
                  children: [
                    Positioned(
                      top: 0,
                      bottom: isLast ? null : -6,
                      left: 11,
                      height: isLast ? 22 : null,
                      child: Container(
                        width: 1,
                        color: p.border,
                      ),
                    ),
                    Positioned(
                      top: 14,
                      left: 5,
                      child: Container(
                        width: 14,
                        height: 14,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: p.bg,
                          border: Border.all(
                            color: def.color(p.dark),
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 8, 0, 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(name, style: TmType.h3(color: p.fg)),
                      const SizedBox(height: 2),
                      Text(
                        '${def.label}${detail != null ? ' · $detail' : ''}',
                        style: TmType.mono(color: p.muted, size: 12),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
