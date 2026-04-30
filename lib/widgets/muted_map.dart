import 'package:flutter/material.dart';
import '../theme/tokens.dart';

/// Desaturated abstract map "tiles" — placeholder for real Mapbox/MapLibre tiles.
class MutedMap extends StatelessWidget {
  final double width;
  final double height;
  final List<Widget> overlays;
  const MutedMap({
    super.key,
    required this.width,
    required this.height,
    this.overlays = const [],
  });

  @override
  Widget build(BuildContext context) {
    final p = TmPalette.of(context);
    final land = p.dark ? TmColors.darkSurf : TmColors.stone50;
    return ClipRect(
      child: SizedBox(
        width: width,
        height: height,
        child: Stack(
          children: [
            Container(color: land),
            CustomPaint(
              size: Size(width, height),
              painter: _MutedMapPainter(dark: p.dark),
            ),
            ...overlays,
          ],
        ),
      ),
    );
  }
}

class _MutedMapPainter extends CustomPainter {
  final bool dark;
  _MutedMapPainter({required this.dark});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final water = dark ? const Color(0xFF1A1530) : const Color(0xFFDDE9E6);
    final park = dark ? const Color(0xFF15201A) : const Color(0xFFDEE5D8);
    final road = dark ? const Color(0xFF34332F) : const Color(0xFFD3CFC1);
    final roadMinor = dark ? const Color(0xFF1F1E1B) : const Color(0xFFE4E1D7);
    final block = dark ? const Color(0xFF23221E) : const Color(0xFFE8E4D9);

    // Water body (curved bottom)
    final waterPath = Path()
      ..moveTo(0, h * 0.55)
      ..quadraticBezierTo(w * 0.3, h * 0.45, w * 0.55, h * 0.55)
      ..quadraticBezierTo(w * 0.78, h * 0.62, w, h * 0.6)
      ..lineTo(w, h)
      ..lineTo(0, h)
      ..close();
    canvas.drawPath(waterPath, Paint()..color = water);
    canvas.drawCircle(
      Offset(w * 0.78, h * 0.22),
      48,
      Paint()..color = water,
    );

    // Parks
    canvas.drawOval(
      Rect.fromCenter(center: Offset(w * 0.22, h * 0.30), width: 92, height: 68),
      Paint()..color = park,
    );
    canvas.drawOval(
      Rect.fromCenter(center: Offset(w * 0.66, h * 0.78), width: 116, height: 64),
      Paint()..color = park,
    );

    // Major roads
    final majorPaint = Paint()
      ..color = road
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.5
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(-10, h * 0.40), Offset(w + 10, h * 0.36), majorPaint);
    canvas.drawLine(Offset(w * 0.18, -10), Offset(w * 0.40, h + 10), majorPaint);
    canvas.drawLine(
      Offset(w * 0.85, -10),
      Offset(w * 0.55, h + 10),
      majorPaint..strokeWidth = 3,
    );
    final curvePath = Path()
      ..moveTo(-10, h * 0.72)
      ..quadraticBezierTo(w * 0.4, h * 0.65, w + 10, h * 0.74);
    canvas.drawPath(
      curvePath,
      Paint()
        ..color = road
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5,
    );

    // Minor roads
    final minorPaint = Paint()
      ..color = roadMinor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;
    for (final y in const [0.12, 0.22, 0.50, 0.62, 0.88]) {
      canvas.drawLine(Offset(-10, h * y), Offset(w + 10, h * (y + 0.02)), minorPaint);
    }
    for (final x in const [0.08, 0.30, 0.48, 0.72, 0.96]) {
      canvas.drawLine(Offset(w * x, -10), Offset(w * (x + 0.02), h + 10), minorPaint);
    }

    // Building blocks
    final blockPaint = Paint()..color = block;
    for (var i = 0; i < 18; i++) {
      final x = (i * 53) % w;
      final y = ((i * 97) % (h - 30)) + 10;
      final bw = 18.0 + ((i * 7) % 24);
      final bh = 14.0 + ((i * 11) % 22);
      canvas.drawRRect(
        RRect.fromRectAndRadius(Rect.fromLTWH(x, y, bw, bh), const Radius.circular(2)),
        blockPaint,
      );
    }
  }

  @override
  bool shouldRepaint(_MutedMapPainter old) => old.dark != dark;
}

class MapPin extends StatelessWidget {
  final TmCategory cat;
  final Offset position;
  final String? label;
  final bool active;
  final VoidCallback? onTap;

  const MapPin({
    super.key,
    required this.cat,
    required this.position,
    this.label,
    this.active = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final p = TmPalette.of(context);
    final def = tmCategories[cat]!;
    final size = active ? 36.0 : 28.0;
    return Positioned(
      left: position.dx - size / 2,
      top: position.dy - size - 8,
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (active && label != null) ...[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: TmColors.nearBlack,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  label!,
                  style: TmType.caption(color: Colors.white),
                ),
              ),
              const SizedBox(height: 2),
            ],
            CustomPaint(
              size: Size(size, size + 8),
              painter: _PinPainter(color: def.color(p.dark), active: active),
              child: SizedBox(
                width: size,
                height: size + 8,
                child: Padding(
                  padding: EdgeInsets.only(top: size * 0.18),
                  child: Center(
                    child: Icon(
                      def.icon,
                      size: size * 0.42,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PinPainter extends CustomPainter {
  final Color color;
  final bool active;
  _PinPainter({required this.color, required this.active});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    // Use the 36×44 reference path scaled
    final scale = w / 36.0;
    final path = Path()
      ..moveTo(18 * scale, 2 * scale)
      ..cubicTo(9 * scale, 2 * scale, 4 * scale, 9 * scale, 4 * scale, 17 * scale)
      ..cubicTo(4 * scale, 27 * scale, 18 * scale, 42 * scale, 18 * scale, 42 * scale)
      ..cubicTo(18 * scale, 42 * scale, 32 * scale, 27 * scale, 32 * scale, 17 * scale)
      ..cubicTo(32 * scale, 9 * scale, 27 * scale, 2 * scale, 18 * scale, 2 * scale)
      ..close();

    canvas.drawShadow(path, Colors.black.withValues(alpha: active ? 0.25 : 0.18), 4, true);
    canvas.drawPath(path, Paint()..color = color);
    canvas.drawPath(
      path,
      Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );
  }

  @override
  bool shouldRepaint(_PinPainter old) =>
      old.color != color || old.active != active;
}
