import 'package:flutter/material.dart';
import '../theme/tokens.dart';
import '../widgets/place_card.dart';
import '../widgets/primitives.dart';

enum _DiscoverFilter { nearMe, eat, see, stay, under20 }

class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({super.key});

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  final added = <String, bool>{};
  _DiscoverFilter _filter = _DiscoverFilter.nearMe;

  static const _places = [
    TmPlace(name: 'Time Out Market', cat: TmCategory.eat, cost: '€15–25', dist: '0.4 km'),
    TmPlace(name: 'Castelo de São Jorge', cat: TmCategory.see, cost: '€15', dist: '1.1 km'),
    TmPlace(name: 'Tram 28', cat: TmCategory.go, cost: '€3', dist: '0.3 km'),
    TmPlace(name: 'Lost in Esplanada', cat: TmCategory.eat, cost: '€18 avg', dist: '0.8 km'),
    TmPlace(name: 'LX Factory', cat: TmCategory.doActivity, cost: 'Free', dist: '2.4 km'),
    TmPlace(name: 'Selina Secret Garden', cat: TmCategory.stay, cost: '€38/n', dist: '0.9 km'),
  ];

  double _parseKm(String dist) {
    final m = RegExp(r'(\d+(?:\.\d+)?)').firstMatch(dist);
    return m == null ? 999 : double.parse(m.group(1)!);
  }

  double? _parseCost(String cost) {
    if (cost.toLowerCase() == 'free') return 0;
    final m = RegExp(r'(\d+(?:\.\d+)?)').firstMatch(cost);
    return m == null ? null : double.parse(m.group(1)!);
  }

  @override
  Widget build(BuildContext context) {
    final p = TmPalette.of(context);
    final filtered = switch (_filter) {
      _DiscoverFilter.nearMe => [..._places]
        ..sort((a, b) => _parseKm(a.dist).compareTo(_parseKm(b.dist))),
      _DiscoverFilter.eat =>
        _places.where((place) => place.cat == TmCategory.eat).toList(),
      _DiscoverFilter.see =>
        _places.where((place) => place.cat == TmCategory.see).toList(),
      _DiscoverFilter.stay =>
        _places.where((place) => place.cat == TmCategory.stay).toList(),
      _DiscoverFilter.under20 => _places.where((place) {
          final c = _parseCost(place.cost);
          return c != null && c < 20;
        }).toList(),
    };
    return SafeArea(
      bottom: false,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 90),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(
              'Discover',
              style: TmType.display(color: p.fg).copyWith(
                fontSize: 28,
                height: 34 / 28,
                letterSpacing: -0.56,
              ),
            ),
          ),
          const SizedBox(height: 6),
          Container(
            height: 44,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: p.surf,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: p.border),
            ),
            child: Row(
              children: [
                Icon(Icons.search, size: 18, color: p.muted),
                const SizedBox(width: 10),
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
              ],
            ),
          ),
          const SizedBox(height: 14),
          SizedBox(
            height: 36,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                for (final entry in const [
                  (_DiscoverFilter.nearMe, 'Near me'),
                  (_DiscoverFilter.eat, 'Eat'),
                  (_DiscoverFilter.see, 'See'),
                  (_DiscoverFilter.stay, 'Stay'),
                  (_DiscoverFilter.under20, 'Under €20'),
                ]) ...[
                  TmChip(
                    active: _filter == entry.$1,
                    onPressed: () => setState(() => _filter = entry.$1),
                    child: Text(entry.$2),
                  ),
                  const SizedBox(width: 8),
                ],
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text('For your Day 4', style: TmType.h2(color: p.fg)),
          const SizedBox(height: 10),
          if (filtered.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 32),
              child: Center(
                child: Text('No matches', style: TmType.body(color: p.muted)),
              ),
            )
          else
            for (var i = 0; i < filtered.length; i++) ...[
              PlaceCard(
                place: filtered[i],
                added: added[filtered[i].name] ?? false,
                onAdd: () => setState(() {
                  final name = filtered[i].name;
                  added[name] = !(added[name] ?? false);
                }),
              ),
              if (i < filtered.length - 1) const SizedBox(height: 10),
            ],
        ],
      ),
    );
  }
}
