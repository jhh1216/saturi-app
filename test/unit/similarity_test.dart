import 'package:flutter_test/flutter_test.dart';
import 'package:saturi_app/utils/similarity.dart';

void main() {
  // ── Levenshtein distance ──────────────────────────────────────────────────

  group('levenshteinDistance', () {
    test(
      'should_return_correct_distance_when_given_different_strings',
      () {
        // "카페" → "카패": 마지막 글자 1개 치환 → 거리 1
        final result = SimilarityCalculator.levenshteinDistance('카페', '카패');
        expect(result, 1);
      },
    );

    test(
      'should_return_length_of_other_string_when_one_string_is_empty',
      () {
        // 한쪽이 빈 문자열이면 나머지 길이만큼 삽입 필요
        expect(SimilarityCalculator.levenshteinDistance('', '안녕'), 2);
        expect(SimilarityCalculator.levenshteinDistance('안녕', ''), 2);
      },
    );

    test(
      'should_return_zero_when_both_strings_are_identical',
      () {
        final result =
            SimilarityCalculator.levenshteinDistance('사투리', '사투리');
        expect(result, 0);
      },
    );
  });

  // ── 점수 계산 ─────────────────────────────────────────────────────────────

  group('calculate', () {
    test(
      'should_return_100_when_recognized_text_matches_original_exactly',
      () {
        final score =
            SimilarityCalculator.calculate('어디 가요?', '어디 가요?');
        expect(score, 100);
      },
    );

    test(
      'should_return_0_when_recognized_text_is_empty',
      () {
        final score = SimilarityCalculator.calculate('밥 먹었어요?', '');
        expect(score, 0);
      },
    );
  });
}
