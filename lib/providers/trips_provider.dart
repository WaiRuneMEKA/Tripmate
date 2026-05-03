import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/mock.dart';

class TripsNotifier extends Notifier<List<TripData>> {
  @override
  List<TripData> build() => List.from(trips);

  void add(TripData trip) => state = [...state, trip];
}

final tripsProvider = NotifierProvider<TripsNotifier, List<TripData>>(
  TripsNotifier.new,
);
