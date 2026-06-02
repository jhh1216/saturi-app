# 테스트 전략 및 실행 방법

## 테스트 전략

사투리 앱의 자동화 테스트는 두 계층으로 구성한다.

```
통합 테스트 (test/integration/)
    ↑ 데이터 → 로직 → UI 렌더링까지 전체 흐름 검증
단위 테스트 (test/unit/)
    ↑ 채점 로직 함수 단위 검증
```

| 구분 | 범위 | 도구 |
|---|---|---|
| 단위 테스트 | `SimilarityCalculator` 함수 | `flutter_test` |
| 통합 테스트 | 사투리 데이터 → 점수 계산 → UI 렌더링 | `flutter_test` + 위젯 트리 |

음성 인식(`SpeechToText`)은 실기기 없이 자동화할 수 없으므로, `@visibleForTesting simulateRecognition()`으로 STT 결과를 주입해 검증한다.

---

## 작성된 테스트 목록

### 단위 테스트 — `test/unit/similarity_test.dart`

#### `levenshteinDistance` 그룹

| 테스트 이름 | 설명 |
|---|---|
| `should_return_correct_distance_when_given_different_strings` | `'카페'` vs `'카패'` → 마지막 글자 1개 치환, 거리 1 반환 |
| `should_return_length_of_other_string_when_one_string_is_empty` | 한쪽이 빈 문자열이면 나머지 길이만큼 거리 반환 |
| `should_return_zero_when_both_strings_are_identical` | 동일 문자열 → 거리 0 반환 |

#### `calculate` 그룹

| 테스트 이름 | 설명 |
|---|---|
| `should_return_100_when_recognized_text_matches_original_exactly` | 인식 텍스트가 원문과 완전히 일치하면 100점 반환 |
| `should_return_0_when_recognized_text_is_empty` | 인식된 텍스트가 없으면 0점 반환 |

---

### 통합 테스트 — `test/integration/dialect_scoring_test.dart`

#### `사투리 점수 계산 통합 테스트` 그룹

| 테스트 이름 | 설명 |
|---|---|
| `should_show_perfect_score_and_feedback_when_user_speaks_dialect_correctly` | 부산 사투리 실제 데이터 문장을 완벽히 발화했을 때 100점·피드백 메시지·재시도 버튼이 UI에 표시되는지 검증 |

**검증 흐름:**

```
dialect_data  →  RecordSheet  →  SimilarityCalculator  →  _ResultSection
(실제 데이터)     (UI 렌더링)      (점수 계산)              (점수·피드백 표시)

Given : 부산 지역 실제 사투리 문장이 화면에 표시됨
When  : simulateRecognition(sentence.dialect) — 완벽 발화 시뮬레이션
Then  : score=100, "완벽해요! 진짜 현지인 같아요 🎉", "다시 해보기" 버튼 확인
```

---

### 위젯 스모크 테스트 — `test/widget_test.dart`

| 테스트 이름 | 설명 |
|---|---|
| `App smoke test` | 앱 시작 시 스플래시 화면이 렌더링되고, 2.5초 후 메인 화면으로 자동 전환되는지 검증 |

---

## 실행 방법

```bash
# 전체 테스트 실행
flutter test

# 상세 출력
flutter test --reporter=expanded

# 계층별 실행
flutter test test/unit/
flutter test test/integration/
flutter test test/widget_test.dart
```

### 현재 테스트 결과

```
+7: All tests passed!

test/unit/similarity_test.dart         5개 통과
test/integration/dialect_scoring_test.dart  1개 통과
test/widget_test.dart                  1개 통과
```
