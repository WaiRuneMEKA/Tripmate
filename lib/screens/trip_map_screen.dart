import 'package:flutter/material.dart';
import '../data/mock.dart';
import '../theme/tokens.dart';
import '../widgets/muted_map.dart';
import '../widgets/primitives.dart';

class TripMapScreen extends StatefulWidget {
  final VoidCallback? onBack;
  final VoidCallback? onSwitchTimeline;
  const TripMapScreen({super.key, this.onBack, this.onSwitchTimeline});

  @override
  State<TripMapScreen> createState() => _TripMapScreenState();
}

class _TripMapScreenState extends State<TripMapScreen> {
  int active = 3;

  @override
  Widget build(BuildContext context) {
    final p = TmPalette.of(context);
    final pin = tripPins[active];
    final def = tmCategories[pin.cat]!;
    return Column(
      children: [
        TmTopBar(
          title: 'Day 4 · Tuesday',
          leading: IconButtonBare(icon: Icons.chevron_left, onPressed: widget.onBack),
          trailing: IconButtonBare(
            icon: Icons.menu_outlined,
            size: 20,
            onPressed: widget.onSwitchTimeline,
          ),
        ),
        Expanded(
          child: LayoutBuilder(
            builder: (context, c) {
              return Stack(
                children: [
                  MutedMap(
                    width: c.maxWidth,
                    height: c.maxHeight,
                    overlays: [
                      // route polyline (dashed)
                      Positioned.fill(
                        child: IgnorePointer(
                          child: CustomPaint(
                            painter: _RoutePainter(color: p.accent, scaleW: c.maxWidth, scaleH: c.maxHeight),
                          ),
                        ),
                      ),
                      for (var i = 0; i < tripPins.length; i++)
                        MapPin(
                          cat: tripPins[i].cat,
                          position: Offset(tripPins[i].xFrac * c.maxWidth, tripPins[i].yFrac * c.maxHeight),
                          label: i == active ? tripPins[i].name : null,
                          active: i == active,
                          onTap: () => setState(() => active = i),
                        ),
                    ],
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: _BottomSheet(
                      cat: pin.cat,
                      name: pin.name,
                      meta: '${def.label} · 14:00 · €13.50 · 0.4 km',
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}

class _RoutePainter extends CustomPainter {
  final Color color;
  final double scaleW;
  final double scaleH;
  _RoutePainter({required this.color, required this.scaleW, required this.scaleH});

  @override
  void paint(Canvas canvas, Size size) {
    // Approx scale from 390×552 reference
    final w = size.width / 390;
    final h = size.height / 552;
    final path = Path()
      ..moveTo(86 * w, 177 * h)
      ..quadraticBezierTo(130 * w, 240 * h, 148 * w, 276 * h)
      ..quadraticBezierTo(200 * w, 320 * h, 226 * w, 265 * h)
      ..quadraticBezierTo(250 * w, 230 * h, 250 * w, 199 * h)
      ..quadraticBezierTo(230 * w, 320 * h, 203 * w, 375 * h)
      ..quadraticBezierTo(240 * w, 400 * h, 273 * w, 408 * h);
    final dashPaint = Paint()
      ..color = color
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    // Draw dashed
    final metrics = path.computeMetrics();
    for (final m in metrics) {
      double dist = 0;
      while (dist < m.length) {
        final next = (dist + 5).clamp(0, m.length).toDouble();
        canvas.drawPath(m.extractPath(dist, next), dashPaint);
        dist = next + 4;
      }
    }
  }

  @override
  bool shouldRepaint(_RoutePainter old) =>
      old.color != color || old.scaleW != scaleW || old.scaleH != scaleH;
}

class _BottomSheet extends StatelessWidget {
  final TmCategory cat;
  final String name;
  final String meta;
  const _BottomSheet({required this.cat, required this.name, required this.meta});

  @override
  Widget build(BuildContext context) {
    final p = TmPalette.of(context);
    return Container(
      decoration: BoxDecoration(
        color: p.dark
            ? const Color(0xFF0E0E0D).withValues(alpha: 0.92)
            : Colors.white.withValues(alpha: 0.92),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        border: Border(top: BorderSide(color: p.border)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            offset: const Offset(0, -8),
            blurRadius: 24,
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 36,
              height: 4,
              margin: const EdgeInsets.only(bottom: 12, top: 4),
              decoration: BoxDecoration(
                color: p.borderStrong,
                borderRadius: BorderRadius.circular(999),
              ),
            ),
            Row(
              children: [
                CategoryDot(cat: cat, size: 36),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(name, style: TmType.h2(color: p.fg)),
                      const SizedBox(height: 2),
                      Text(meta, style: TmType.mono(color: p.muted, size: 13)),
                    ],
                  ),
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
                    child: const Text('Open'),
                  ),
                ),
                const SizedBox(width: 8),
                TmButton(
                  variant: TmButtonVariant.secondary,
                  small: true,
                  child: const Text('Directions'),
                ),
                const SizedBox(width: 8),
                TmButton(
                  variant: TmButtonVariant.secondary,
                  small: true,
                  child: const Text('Edit'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
