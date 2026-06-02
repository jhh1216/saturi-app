import 'dart:math';
import 'package:flutter/foundation.dart';

class SimilarityCalculator {
  static int _levenshtein(String a, String b) {
    final m = a.length;
    final n = b.length;
    final dp = List.generate(m + 1, (_) => List.filled(n + 1, 0));

    for (int i = 0; i <= m; i++) { dp[i][0] = i; }
    for (int j = 0; j <= n; j++) { dp[0][j] = j; }

    for (int i = 1; i <= m; i++) {
      for (int j = 1; j <= n; j++) {
        if (a[i - 1] == b[j - 1]) {
          dp[i][j] = dp[i - 1][j - 1];
        } else {
          dp[i][j] = 1 + min(dp[i - 1][j - 1], min(dp[i - 1][j], dp[i][j - 1]));
        }
      }
    }

    return dp[m][n];
  }

  // 공백·특수문자 제거 후 소문자로 정규화
  static String _normalize(String text) {
    return text.replaceAll(RegExp(r'[^가-힣a-zA-Z0-9]'), '').toLowerCase();
  }

  @visibleForTesting
  static int levenshteinDistance(String a, String b) => _levenshtein(a, b);

  /// 원문과 인식된 텍스트를 비교해 0~100 점수 반환
  static int calculate(String original, String recognized) {
    final a = _normalize(original);
    final b = _normalize(recognized);

    if (a.isEmpty && b.isEmpty) return 100;
    if (b.isEmpty) return 0;

    final maxLen = max(a.length, b.length);
    final distance = _levenshtein(a, b);
    final score = ((maxLen - distance) / maxLen * 100).round();
    return score.clamp(0, 100);
  }
}
