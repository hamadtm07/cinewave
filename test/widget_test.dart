import 'package:flutter_test/flutter_test.dart';
import 'package:cinewave/main.dart';
import 'package:cinewave/screens/screens.dart';

void main() {
  testWidgets('Carga inicial CineWave', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    expect(find.byType(HomeScreen), findsOneWidget);
  });
}
