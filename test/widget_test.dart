import 'package:flutter_test/flutter_test.dart';
import 'package:smart_home/main.dart';

void main() {
  testWidgets('App starts and shows login screen', (final WidgetTester tester) async {
    await tester.pumpWidget(const SmartHomeApp());
    await tester.pumpAndSettle();
    expect(find.text('Smart Home'), findsOneWidget);
    expect(find.text('Вхід у систему'), findsOneWidget);
  });
}
