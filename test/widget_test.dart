import 'package:flutter_test/flutter_test.dart';
import 'package:saturi_app/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const SaturiApp());
    expect(find.text('🗣️ 지역별 사투리 모음'), findsOneWidget);
  });
}
