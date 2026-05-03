import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' show LatLng;
import '../data/mock.dart';
import '../theme/tokens.dart';
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
  final _mapController = MapController();

  // Coordinates for tripPins (all in Lisbon area, matching Day 4 itinerary)
  static const _latLngs = [
    LatLng(38.7086, -9.1465), // Selina Secret Garden (Bairro Alto)
    LatLng(38.7372, -9.1693), // Bus stop - Sete Rios
    LatLng(38.7108, -9.1368), // Cafe Santa Cruz
    LatLng(38.7196, -9.1540), // Universidade de Coimbra area
    LatLng(38.7003, -9.1791), // Mondego river walk (LX Factory area)
    LatLng(38.7091, -9.1417), // Solar Bar do Quim
  ];

  void _selectPin(int index) {
    setState(() => active = index);
    _mapController.move(_latLngs[index], 14.5);
  }

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
          child: Stack(
            children: [
              FlutterMap(
                mapController: _mapController,
                options: MapOptions(
                  initialCenter: _latLngs[active],
                  initialZoom: 13.5,
                  minZoom: 10.0,
                  maxZoom: 18.0,
                ),
                children: [
                  TileLayer(
                    urlTemplate: p.dark
                        ? 'https://a.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}.png'
                        : 'https://a.basemaps.cartocdn.com/rastertiles/voyager/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.example.tripmate',
                  ),
                  PolylineLayer(
                    polylines: [
                      Polyline(
                        points: _latLngs.toList(),
                        strokeWidth: 3.5,
                        color: p.accent.withValues(alpha: 0.85),
                        pattern: const StrokePattern.dotted(),
                      ),
                    ],
                  ),
                  MarkerLayer(
                    markers: [
                      for (var i = 0; i < tripPins.length; i++)
                        _buildMarker(i, p),
                    ],
                  ),
                  RichAttributionWidget(
                    attributions: [
                      TextSourceAttribution('OpenStreetMap', onTap: () {}),
                      TextSourceAttribution('Carto', onTap: () {}),
                    ],
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
          ),
        ),
      ],
    );
  }

  Marker _buildMarker(int index, TmPalette p) {
    final isActive = index == active;
    final tp = tripPins[index];
    return Marker(
      width: isActive ? 110.0 : 44.0,
      height: isActive ? 88.0 : 52.0,
      point: _latLngs[index],
      alignment: Alignment.bottomCenter,
      child: _TmPin(
        cat: tp.cat,
        active: isActive,
        label: isActive ? tp.name : null,
        onTap: () => _selectPin(index),
      ),
    );
  }
}

// ── Pin widget for flutter_map ───────────────────────────────────────────────

class _TmPin extends StatelessWidget {
  final TmCategory cat;
  final bool active;
  final String? label;
  final VoidCallback? onTap;
  const _TmPin({required this.cat, this.active = false, this.label, this.onTap});

  @override
  Widget build(BuildContext context) {
    final p = TmPalette.of(context);
    final def = tmCategories[cat]!;
    final size = active ? 36.0 : 28.0;
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (active && label != null) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: TmColors.nearBlack,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.25),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                label!,
                style: TmType.caption(color: Colors.white).copyWith(fontSize: 11),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: 3),
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
                  child: Icon(def.icon, size: size * 0.42, color: Colors.white),
                ),
              ),
            ),
          ),
        ],
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
    final scale = w / 36.0;
    final path = ui.Path()
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
  bool shouldRepaint(_PinPainter old) => old.color != color || old.active != active;
}

// ── Bottom sheet (same design as before) ────────────────────────────────────

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
