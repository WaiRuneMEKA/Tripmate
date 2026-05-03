import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' show LatLng;
import '../data/mock.dart';
import '../theme/tokens.dart';
import '../widgets/primitives.dart';

class CityMapScreen extends StatefulWidget {
  final VoidCallback? onBack;
  const CityMapScreen({super.key, this.onBack});

  @override
  State<CityMapScreen> createState() => _CityMapScreenState();
}

class _CityMapScreenState extends State<CityMapScreen> {
  int active = 2;
  TmCategory? filter;
  final _mapController = MapController();

  static const _filters = [
    (id: null, label: 'All'),
    (id: TmCategory.eat, label: 'Eat'),
    (id: TmCategory.see, label: 'See'),
    (id: TmCategory.stay, label: 'Stay'),
    (id: TmCategory.doActivity, label: 'Do'),
    (id: TmCategory.go, label: 'Go'),
  ];

  // Coordinates matching cityPins order in mock.dart
  static const _latLngs = [
    LatLng(38.7086, -9.1465), // Selina Secret Garden
    LatLng(38.7166, -9.1421), // The Independente
    LatLng(38.7069, -9.1459), // Time Out Market
    LatLng(38.7152, -9.1308), // Lost in Esplanada
    LatLng(38.6975, -9.2040), // Pasties de Belem
    LatLng(38.7139, -9.1335), // Castelo de Sao Jorge
    LatLng(38.6980, -9.2066), // Mosteiro dos Jeronimos
    LatLng(38.7002, -9.1791), // LX Factory
    LatLng(38.7240, -9.1012), // Tile Museum
    LatLng(38.7178, -9.1336), // Tram 28
  ];

  void _selectPin(int index) {
    setState(() => active = index);
    _mapController.move(_latLngs[index], 14.5);
  }

  @override
  Widget build(BuildContext context) {
    final p = TmPalette.of(context);
    final visible = filter == null
        ? cityPins
        : cityPins.where((pin) => pin.cat == filter).toList();
    final pin = cityPins[active];
    final def = tmCategories[pin.cat]!;

    return Stack(
      children: [
        FlutterMap(
          mapController: _mapController,
          options: MapOptions(
            initialCenter: _latLngs[active],
            initialZoom: 14.0,
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
            MarkerLayer(
              markers: [
                for (final mapPin in visible) _buildMarker(mapPin, p),
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
        // Search bar
        Positioned(
          top: MediaQuery.of(context).padding.top + 12,
          left: 12,
          right: 12,
          child: Container(
            height: 48,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: p.dark
                  ? p.bg.withValues(alpha: 0.92)
                  : Colors.white.withValues(alpha: 0.95),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: p.border),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.10),
                  offset: const Offset(0, 4),
                  blurRadius: 12,
                ),
              ],
            ),
            child: Row(
              children: [
                IconButtonBare(icon: Icons.chevron_left, size: 20, onPressed: widget.onBack),
                const SizedBox(width: 6),
                Icon(Icons.search, size: 18, color: p.muted),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search Lisbon',
                      hintStyle: TmType.body(color: p.muted),
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                    ),
                    style: TmType.body(color: p.fg),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: p.dark ? TmColors.darkBorder : const Color(0xFFF1ECFF),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.map_outlined, size: 16, color: p.accentSoftFg),
                ),
              ],
            ),
          ),
        ),
        // Filter chips
        Positioned(
          top: MediaQuery.of(context).padding.top + 72,
          left: 0,
          right: 0,
          child: SizedBox(
            height: 34,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              children: [
                for (final f in _filters) ...[
                  _FloatChip(
                    active: filter == f.id,
                    cat: f.id,
                    label: f.label,
                    onTap: () => setState(() => filter = f.id),
                  ),
                  const SizedBox(width: 8),
                ],
              ],
            ),
          ),
        ),
        // Right-side action buttons
        Positioned(
          right: 14,
          top: MediaQuery.of(context).padding.top + 130,
          child: Column(
            children: [
              for (final icon in const [Icons.explore_outlined, Icons.add])
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: p.surf,
                      shape: BoxShape.circle,
                      border: Border.all(color: p.border),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.10),
                          offset: const Offset(0, 4),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                    child: Icon(icon, size: 18, color: p.fg),
                  ),
                ),
            ],
          ),
        ),
        // Bottom sheet
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: Container(
            decoration: BoxDecoration(
              color: p.dark
                  ? p.bg.withValues(alpha: 0.95)
                  : Colors.white.withValues(alpha: 0.95),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              border: Border(top: BorderSide(color: p.border)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.12),
                  offset: const Offset(0, -8),
                  blurRadius: 24,
                ),
              ],
            ),
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
            child: SafeArea(
              top: false,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 36,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 14, top: 4),
                    decoration: BoxDecoration(
                      color: p.borderStrong,
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                  Row(
                    children: [
                      CategoryDot(cat: pin.cat, size: 40),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(pin.name, style: TmType.h2(color: p.fg)),
                            const SizedBox(height: 2),
                            Text(
                              '${def.label} · ${pin.meta}',
                              style: TmType.mono(color: p.muted, size: 13),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: p.border),
                        ),
                        child: Icon(Icons.bookmark_border, size: 16, color: p.fg),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 64,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        for (var i = 0; i < 4; i++) ...[
                          Container(
                            width: 88,
                            height: 64,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              gradient: i == 0
                                  ? LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        def.color(p.dark).withValues(alpha: 0.2),
                                        def.color(p.dark).withValues(alpha: 0.4),
                                      ],
                                    )
                                  : null,
                              color: i == 0 ? null : p.surfSunken,
                            ),
                          ),
                          const SizedBox(width: 8),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: TmButton(
                          fullWidth: true,
                          child: const Text('Add to Day 4'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      TmButton(
                        variant: TmButtonVariant.secondary,
                        child: const Text('Directions'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Marker _buildMarker(MapPinData mapPin, TmPalette p) {
    final idx = cityPins.indexOf(mapPin);
    final isActive = idx == active;
    return Marker(
      width: isActive ? 110.0 : 44.0,
      height: isActive ? 88.0 : 52.0,
      point: _latLngs[idx],
      alignment: Alignment.bottomCenter,
      child: _TmPin(
        cat: mapPin.cat,
        active: isActive,
        label: isActive ? mapPin.name : null,
        onTap: () => _selectPin(idx),
      ),
    );
  }
}

// ── Pin widget for flutter_map (no Positioned wrapper) ──────────────────────

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

// ── Float chip (unchanged from original) ────────────────────────────────────

class _FloatChip extends StatelessWidget {
  final bool active;
  final TmCategory? cat;
  final String label;
  final VoidCallback onTap;
  const _FloatChip({
    required this.active,
    required this.cat,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final p = TmPalette.of(context);
    return Material(
      color: active
          ? (p.dark ? p.bg.withValues(alpha: 0.95) : TmColors.nearBlack)
          : (p.dark ? p.bg.withValues(alpha: 0.92) : Colors.white.withValues(alpha: 0.95)),
      borderRadius: BorderRadius.circular(999),
      elevation: 2,
      shadowColor: Colors.black.withValues(alpha: 0.08),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: Container(
          height: 34,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: active ? Colors.transparent : p.border),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (cat != null) ...[
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: tmCategories[cat]!.color(p.dark),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
              ],
              Text(
                label,
                style: TmType.small(
                  color: active ? Colors.white : p.fg,
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
