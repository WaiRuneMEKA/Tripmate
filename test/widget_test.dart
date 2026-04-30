import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:tripmate/main.dart';

void main() {
  testWidgets('Tripmate boots and renders Onboarding', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: TripmateApp()));
    await tester.pump();
    expect(find.text('tripmate'), findsOneWidget);
    expect(find.text('Start a trip'), findsOneWidget);
  });
}
