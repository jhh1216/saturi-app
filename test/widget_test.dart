import 'package:flutter_test/flutter_test.dart';
import 'package:saturi_app/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const SaturiApp());
    await tester.pump();

    // 스플래시 화면 렌더링 확인
    expect(find.text('사투리'), findsOneWidget);
    expect(find.text('방방곡곡 우리말 여행'), findsOneWidget);

    // 스플래시 타이머 전체 소진 (200ms + 500ms + 1800ms = 2500ms)
    // → _navigateToHome() 호출 후 SplashScreen dispose, 타이머 정리
    await tester.pump(const Duration(milliseconds: 2600));
    await tester.pumpAndSettle();
  });
}
