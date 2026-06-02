// 통합 테스트: 사투리 문장 입력 → 유사도 점수 반환 전체 흐름
//
// 흐름: dialect_data(데이터) → RecordSheet(UI) → SimilarityCalculator(점수) → 결과 렌더링
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:saturi_app/data/dialect_data.dart';
import 'package:saturi_app/theme/app_theme.dart';
import 'package:saturi_app/utils/similarity.dart';
import 'package:saturi_app/widgets/record_sheet.dart';

void main() {
  group('사투리 점수 계산 통합 테스트', () {
    testWidgets(
      'should_show_perfect_score_and_feedback_when_user_speaks_dialect_correctly',
      (tester) async {
        // ── Given: 실제 사투리 데이터에서 부산 지역 첫 번째 문장 사용 ──────────
        final busanRegion =
            regions.firstWhere((r) => r.name.contains('부산'));
        final sentence = busanRegion.sentences.first;

        await tester.pumpWidget(
          MaterialApp(
            theme: buildAppTheme(),
            home: Scaffold(
              body: RecordSheet(
                sentence: sentence,
                regionName: busanRegion.name,
                accentColor: kRegionColors[1], // 부산 — 코랄
              ),
            ),
          ),
        );
        await tester.pump();

        // 사투리 문장이 UI에 표시되는지 확인
        expect(find.text(sentence.dialect), findsOneWidget);

        // ── When: 사투리 문장과 동일하게 발화 (STT 결과 시뮬레이션) ──────────
        final state =
            tester.state<RecordSheetState>(find.byType(RecordSheet));
        state.simulateRecognition(sentence.dialect);

        // 점수 카운트업 애니메이션(1400ms) 완료까지 대기
        await tester.pumpAndSettle(const Duration(seconds: 2));

        // ── Then: SimilarityCalculator가 100점 반환, UI에 점수·피드백 표시 ──
        final score = SimilarityCalculator.calculate(
          sentence.dialect,
          sentence.dialect,
        );
        expect(score, 100);
        expect(find.text('$score'), findsOneWidget);
        expect(find.text('완벽해요! 진짜 현지인 같아요 🎉'), findsOneWidget);
        expect(find.text('다시 해보기'), findsOneWidget);
      },
    );
  });
}
