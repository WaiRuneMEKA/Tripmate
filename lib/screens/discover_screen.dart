import 'package:flutter/material.dart';
import '../theme/tokens.dart';
import '../widgets/place_card.dart';
import '../widgets/primitives.dart';

class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({super.key});

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  final added = <int, bool>{};

  static const _places = [
    TmPlace(name: 'Time Out Market', cat: TmCategory.eat, cost: '€15–25', dist: '0.4 km'),
    TmPlace(name: 'Castelo de São Jorge', cat: TmCategory.see, cost: '€15', dist: '1.1 km'),
    TmPlace(name: 'Tram 28', cat: TmCategory.go, cost: '€3', dist: '0.3 km'),
    TmPlace(name: 'Lost in Esplanada', cat: TmCategory.eat, cost: '€18 avg', dist: '0.8 km'),
    TmPlace(name: 'LX Factory', cat: TmCategory.doActivity, cost: 'Free', dist: '2.4 km'),
    TmPlace(name: 'Selina Secret Garden', cat: TmCategory.stay, cost: '€38/n', dist: '0.9 km'),
  ];

  @override
  Widget build(BuildContext context) {
    final p = TmPalette.of(context);
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
              children: const [
                TmChip(active: true, child: Text('Near me')),
                SizedBox(width: 8),
                TmChip(child: Text('Eat')),
                SizedBox(width: 8),
                TmChip(child: Text('See')),
                SizedBox(width: 8),
                TmChip(child: Text('Stay')),
                SizedBox(width: 8),
                TmChip(child: Text('Under €20')),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text('For your Day 4', style: TmType.h2(color: p.fg)),
          const SizedBox(height: 10),
          for (var i = 0; i < _places.length; i++) ...[
            PlaceCard(
              place: _places[i],
              added: added[i] ?? false,
              onAdd: () => setState(() => added[i] = !(added[i] ?? false)),
            ),
            if (i < _places.length - 1) const SizedBox(height: 10),
          ],
        ],
      ),
    );
  }
}
