import 'package:flutter_test/flutter_test.dart';
import 'package:saturi_app/utils/similarity.dart';

void main() {
  group('SimilarityCalculator.calculate', () {
    test('동일한 문장 → 100점', () {
      expect(SimilarityCalculator.calculate('어디 가요?', '어디 가요?'), equals(100));
      expect(SimilarityCalculator.calculate('안녕하세요', '안녕하세요'), equals(100));
      expect(SimilarityCalculator.calculate('', ''), equals(100));
    });

    test('완전히 다른 문장 → 0점에 가까운 점수', () {
      // 한글 vs 영문: 공통 문자 없음, 정규화 후 모두 다름
      final score = SimilarityCalculator.calculate('가나다라마바사', 'ABCDEFG');
      expect(score, lessThanOrEqualTo(15));
    });

    test('절반 정도 비슷한 문장 → 40~60점 사이', () {
      // '안녕하세요반갑습니다'(10자) vs '안녕하세요'(5자): 거리=5, 점수=50
      final score = SimilarityCalculator.calculate('안녕하세요반갑습니다', '안녕하세요');
      expect(score, inInclusiveRange(40, 60));
    });

    test('한 글자만 다른 문장 → 90점 이상', () {
      // 10자 문장에서 마지막 글자 1개만 다름: 거리=1, 점수=90
      final score = SimilarityCalculator.calculate('안녕하세요반갑습니다', '안녕하세요반갑습니가');
      expect(score, greaterThanOrEqualTo(90));
    });
  });

  group('SimilarityCalculator.levenshteinDistance', () {
    test('동일 문자열 → 거리 0', () {
      expect(SimilarityCalculator.levenshteinDistance('사투리', '사투리'), equals(0));
    });

    test('한 글자 교체 → 거리 1', () {
      expect(SimilarityCalculator.levenshteinDistance('카페', '카패'), equals(1));
    });

    test('한 글자 삽입 → 거리 1', () {
      expect(SimilarityCalculator.levenshteinDistance('abc', 'abcd'), equals(1));
    });

    test('한 글자 삭제 → 거리 1', () {
      expect(SimilarityCalculator.levenshteinDistance('abcd', 'abc'), equals(1));
    });

    test('빈 문자열 vs 문자열 → 문자열 길이', () {
      expect(SimilarityCalculator.levenshteinDistance('', '안녕'), equals(2));
      expect(SimilarityCalculator.levenshteinDistance('안녕', ''), equals(2));
    });
  });
}
