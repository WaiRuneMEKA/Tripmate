import 'package:flutter/material.dart';
import '../theme/tokens.dart';

class TripData {
  final String id;
  final String title;
  final String dates;
  final int days;
  final String spent;
  final String budget;
  final List<({String initials, Color color})> members;
  final List<Color> coverColors;
  final bool live;
  final bool draft;
  const TripData({
    required this.id,
    required this.title,
    required this.dates,
    required this.days,
    required this.spent,
    required this.budget,
    required this.members,
    required this.coverColors,
    this.live = false,
    this.draft = false,
  });
}

const trips = <TripData>[
  TripData(
    id: 't1',
    title: 'Lisbon → Porto',
    dates: 'Mar 14 – Mar 22',
    days: 8,
    spent: '€612',
    budget: '€900',
    members: [
      (initials: 'YO', color: TmColors.violet500),
      (initials: 'M', color: TmColors.amber500),
      (initials: 'J', color: TmColors.sky500),
    ],
    coverColors: [Color(0xFFF1ECFF), Color(0xFFDFD3FF)],
    live: true,
  ),
  TripData(
    id: 't2',
    title: 'Bangkok loop',
    dates: 'May 02 – Jun 14',
    days: 43,
    spent: '฿18,420',
    budget: '฿28,000',
    members: [
      (initials: 'YO', color: TmColors.violet500),
      (initials: 'S', color: TmColors.violet700),
    ],
    coverColors: [Color(0xFFFBF1DD), Color(0xFFF4DDD9)],
  ),
  TripData(
    id: 't3',
    title: 'Patagonia, solo',
    dates: 'Oct 04 – Oct 28',
    days: 25,
    spent: '—',
    budget: 'CLP 1.4M',
    members: [
      (initials: 'YO', color: TmColors.violet500),
    ],
    coverColors: [Color(0xFFDEE5D8), Color(0xFFEFEDE6)],
    draft: true,
  ),
];

class DaySlot {
  final String time;
  final TmCategory cat;
  final String name;
  final String detail;
  const DaySlot({
    required this.time,
    required this.cat,
    required this.name,
    required this.detail,
  });
}

const daySlots = <DaySlot>[
  DaySlot(
    time: '08:30',
    cat: TmCategory.stay,
    name: 'Selina Secret Garden',
    detail: 'Check-out · Bairro Alto',
  ),
  DaySlot(
    time: '09:15',
    cat: TmCategory.go,
    name: 'Bus to Coimbra',
    detail: '2h 27m · €13.50',
  ),
  DaySlot(
    time: '12:30',
    cat: TmCategory.eat,
    name: 'Café Santa Cruz',
    detail: '€12 avg · 0.2 km',
  ),
  DaySlot(
    time: '14:00',
    cat: TmCategory.see,
    name: 'Universidade de Coimbra',
    detail: 'Joanina Library tour · €13.50',
  ),
  DaySlot(
    time: '17:30',
    cat: TmCategory.doActivity,
    name: 'Mondego river walk',
    detail: '4 km loop · free',
  ),
  DaySlot(
    time: '20:00',
    cat: TmCategory.eat,
    name: 'Solar Bar do Quim',
    detail: '€18 avg',
  ),
];

class MapPinData {
  final TmCategory cat;
  final double xFrac;
  final double yFrac;
  final String name;
  final String? meta;
  const MapPinData({
    required this.cat,
    required this.xFrac,
    required this.yFrac,
    required this.name,
    this.meta,
  });
}

const tripPins = <MapPinData>[
  MapPinData(cat: TmCategory.stay, xFrac: 0.22, yFrac: 0.32, name: 'Selina Secret Garden'),
  MapPinData(cat: TmCategory.go, xFrac: 0.38, yFrac: 0.50, name: 'Bus stop · Sete Rios'),
  MapPinData(cat: TmCategory.eat, xFrac: 0.58, yFrac: 0.48, name: 'Café Santa Cruz'),
  MapPinData(cat: TmCategory.see, xFrac: 0.64, yFrac: 0.36, name: 'Universidade de Coimbra'),
  MapPinData(cat: TmCategory.doActivity, xFrac: 0.52, yFrac: 0.68, name: 'Mondego river walk'),
  MapPinData(cat: TmCategory.eat, xFrac: 0.70, yFrac: 0.74, name: 'Solar Bar do Quim'),
];

const cityPins = <MapPinData>[
  MapPinData(cat: TmCategory.stay, xFrac: 0.24, yFrac: 0.28, name: 'Selina Secret Garden', meta: '€38/n · 4.6★'),
  MapPinData(cat: TmCategory.stay, xFrac: 0.52, yFrac: 0.20, name: 'The Independente', meta: '€45/n · 4.4★'),
  MapPinData(cat: TmCategory.eat, xFrac: 0.38, yFrac: 0.42, name: 'Time Out Market', meta: '€15–25 · 4.7★'),
  MapPinData(cat: TmCategory.eat, xFrac: 0.64, yFrac: 0.54, name: 'Lost in Esplanada', meta: '€18 avg · 4.5★'),
  MapPinData(cat: TmCategory.eat, xFrac: 0.20, yFrac: 0.62, name: 'Pastéis de Belém', meta: '€4 · 4.8★'),
  MapPinData(cat: TmCategory.see, xFrac: 0.72, yFrac: 0.32, name: 'Castelo de São Jorge', meta: '€15 · 4.6★'),
  MapPinData(cat: TmCategory.see, xFrac: 0.46, yFrac: 0.70, name: 'Mosteiro dos Jerónimos', meta: '€12 · 4.7★'),
  MapPinData(cat: TmCategory.doActivity, xFrac: 0.78, yFrac: 0.64, name: 'LX Factory', meta: 'Free · 4.5★'),
  MapPinData(cat: TmCategory.doActivity, xFrac: 0.32, yFrac: 0.78, name: 'Tile Museum', meta: '€8 · 4.4★'),
  MapPinData(cat: TmCategory.go, xFrac: 0.58, yFrac: 0.38, name: 'Tram 28', meta: '€3 · iconic'),
];

const dayPlan = <int, ({TmCategory cat, String label, String detail})>{
  14: (cat: TmCategory.go, label: 'Lisbon arrival', detail: 'Flight TP 217 · 14:20'),
  15: (cat: TmCategory.stay, label: 'Alfama wander', detail: '4 stops · 6 km'),
  16: (cat: TmCategory.see, label: 'Belém day', detail: 'Mosteiro, Pastéis, MAAT'),
  17: (cat: TmCategory.eat, label: 'Mercado da Ribeira', detail: 'Dinner crawl'),
  18: (cat: TmCategory.doActivity, label: 'Sintra day-trip', detail: 'Train 09:11 · Pena'),
  19: (cat: TmCategory.go, label: 'Bus to Coimbra', detail: 'Rede Expressos · 2h 27m'),
  20: (cat: TmCategory.see, label: 'Coimbra old town', detail: 'Universidade · Joanina'),
  21: (cat: TmCategory.go, label: 'Train to Porto', detail: 'CP IC · 1h 06m'),
  22: (cat: TmCategory.eat, label: 'Porto · Ribeira', detail: 'Wine tasting · departure'),
};

const expenseRows = <({
  List<({String initials, Color color})> people,
  String title,
  String sub,
  String amount,
  String who,
  int balance,
})>[
  (
    people: [
      (initials: 'S', color: TmColors.violet700),
      (initials: 'M', color: TmColors.amber500),
      (initials: 'J', color: TmColors.sky500),
    ],
    title: 'Hostel · 2 nights',
    sub: 'Sam paid · split 4 ways',
    amount: '€38.00',
    who: 'Sam',
    balance: -1,
  ),
  (
    people: [
      (initials: 'YO', color: TmColors.violet500),
      (initials: 'M', color: TmColors.amber500),
    ],
    title: 'Tuk-tuk to Belém',
    sub: 'You paid · split with Maya',
    amount: '€6.00',
    who: 'Maya',
    balance: 1,
  ),
  (
    people: [
      (initials: 'M', color: TmColors.amber500),
      (initials: 'YO', color: TmColors.violet500),
      (initials: 'J', color: TmColors.sky500),
    ],
    title: 'Pastéis de Belém',
    sub: 'Maya paid · split 3 ways',
    amount: '€4.20',
    who: 'Maya',
    balance: -1,
  ),
  (
    people: [
      (initials: 'YO', color: TmColors.violet500),
      (initials: 'J', color: TmColors.sky500),
    ],
    title: 'Train to Sintra',
    sub: 'You paid · split with Jules',
    amount: '€2.25',
    who: 'Jules',
    balance: 1,
  ),
];
