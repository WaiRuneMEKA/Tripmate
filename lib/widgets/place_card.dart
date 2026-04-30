import 'package:flutter/material.dart';
import '../theme/tokens.dart';
import 'primitives.dart';

class TmPlace {
  final String name;
  final TmCategory cat;
  final String cost;
  final String dist;
  const TmPlace({
    required this.name,
    required this.cat,
    required this.cost,
    required this.dist,
  });
}

class PlaceCard extends StatelessWidget {
  final TmPlace place;
  final bool added;
  final VoidCallback? onAdd;
  const PlaceCard({
    super.key,
    required this.place,
    this.added = false,
    this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    final p = TmPalette.of(context);
    final def = tmCategories[place.cat]!;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: p.surf,
        borderRadius: const BorderRadius.all(TmRadius.lg),
        border: Border.all(color: p.border),
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  def.color(p.dark).withValues(alpha: 0.2),
                  def.color(p.dark).withValues(alpha: 0.07),
                ],
              ),
            ),
            child: Stack(
              children: [
                Positioned(
                  left: 4,
                  bottom: 4,
                  child: CategoryDot(cat: place.cat, size: 20),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  place.name,
                  style: TmType.h3(color: p.fg),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 3),
                Text(
                  '${def.label} · ${place.cost} · ${place.dist}',
                  style: TmType.mono(color: p.muted, size: 12),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Material(
            color: added ? p.accentSoft : p.surf,
            borderRadius: BorderRadius.circular(8),
            child: InkWell(
              onTap: onAdd,
              borderRadius: BorderRadius.circular(8),
              child: Container(
                height: 36,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: added ? Colors.transparent : p.border,
                  ),
                ),
                alignment: Alignment.center,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (added) ...[
                      Icon(
                        Icons.check,
                        size: 14,
                        color: p.accentSoftFg,
                      ),
                      const SizedBox(width: 4),
                    ],
                    Text(
                      added ? 'Added' : '+ Add',
                      style: TmType.small(
                        color: added ? p.accentSoftFg : p.fg,
                        weight: FontWeight.w500,
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
