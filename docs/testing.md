# 테스트 전략 및 실행 방법

## 테스트 전략 개요

사투리 앱의 테스트는 세 계층으로 구성된다.

```
수동 테스트 (E2E)
    ↑ 실제 기기/브라우저에서 전체 흐름 확인
위젯 테스트
    ↑ 화면 렌더링 및 사용자 인터랙션 검증
유닛 테스트
    ↑ 채점 로직, 데이터 모델 단위 검증
```

---

## 1. 유닛 테스트

### 1.1 SimilarityCalculator 테스트

`test/similarity_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:saturi_app/utils/similarity.dart';

void main() {
  group('SimilarityCalculator', () {
    test('동일한 문자열은 100점', () {
      expect(SimilarityCalculator.calculate('안녕하세요', '안녕하세요'), 100);
    });

    test('완전히 다른 문자열은 낮은 점수', () {
      final score = SimilarityCalculator.calculate('가나다라', '힘들어요');
      expect(score, lessThan(30));
    });

    test('빈 문자열 둘 다 100점', () {
      expect(SimilarityCalculator.calculate('', ''), 100);
    });

    test('한쪽만 빈 문자열은 0점', () {
      expect(SimilarityCalculator.calculate('안녕', ''), 0);
      expect(SimilarityCalculator.calculate('', '안녕'), 0);
    });

    test('1글자 차이는 높은 점수', () {
      // '머꼬' vs '머고' — 받침 하나 차이
      final score = SimilarityCalculator.calculate('머꼬', '머고');
      expect(score, greaterThan(70));
    });

    test('점수는 0~100 범위 내', () {
      final score = SimilarityCalculator.calculate('와 진짜 맛있겠다', '와 맛있다');
      expect(score, inInclusiveRange(0, 100));
    });
  });
}
```

### 1.2 테스트 실행

```bash
# 전체 유닛 테스트
flutter test

# 특정 파일만
flutter test test/similarity_test.dart

# 상세 출력
flutter test --reporter expanded
```

---

## 2. 위젯 테스트

### 2.1 메인 화면 렌더링 테스트

`test/widget_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:saturi_app/main.dart';

void main() {
  testWidgets('메인 화면에 지역 카드 6개가 표시된다', (WidgetTester tester) async {
    await tester.pumpWidget(const SaturiApp());
    await tester.pumpAndSettle();

    // AppBar 제목 확인
    expect(find.text('사투리'), findsOneWidget);

    // 6개 지역 이름 확인
    expect(find.text('서울'), findsOneWidget);
    expect(find.text('부산'), findsOneWidget);
    expect(find.text('전라'), findsOneWidget);
    expect(find.text('충청'), findsOneWidget);
    expect(find.text('강원'), findsOneWidget);
    expect(find.text('제주'), findsOneWidget);
  });

  testWidgets('지역 카드 탭 시 상세 화면으로 이동', (WidgetTester tester) async {
    await tester.pumpWidget(const SaturiApp());
    await tester.pumpAndSettle();

    // 서울 카드 탭
    await tester.tap(find.text('서울'));
    await tester.pumpAndSettle();

    // 상세 화면 AppBar에 서울 표시 확인
    expect(find.text('서울'), findsWidgets);
  });
}
```

### 2.2 위젯 테스트 실행

```bash
flutter test test/widget_test.dart
```

---

## 3. 수동 테스트 시나리오

음성 인식은 자동 테스트가 어려우므로 수동으로 검증한다.

### 3.1 핵심 기능 테스트 시나리오

#### TC-001: 지역 선택 및 문장 목록 확인
1. 앱 실행
2. 메인 화면에 6개 지역 카드 확인
3. '부산' 카드 탭
4. 부산 방언 문장 목록이 표시되는지 확인
5. 각 문장에 방언 텍스트 + 표준어 번역이 표시되는지 확인
- **기대 결과:** ✅ 문장 목록 정상 표시

#### TC-002: 녹음 시작
1. 문장 목록에서 첫 번째 문장의 마이크 버튼 탭
2. 바텀시트가 올라오는지 확인
3. '버튼을 눌러 말해보세요' 텍스트 확인
4. 마이크 버튼 탭
5. '녹음 중...' 메시지 + WaveRing 애니메이션 확인
- **기대 결과:** ✅ 녹음 상태 진입

#### TC-003: 발음 채점 (70점 이상)
1. TC-002에 이어서
2. 방언 문장을 최대한 정확히 발음
3. 인식 완료 후 결과 화면 확인
4. 70점 이상이면 성공 효과음 + 초록/주황 점수 표시 확인
- **기대 결과:** ✅ 점수 카운트업 애니메이션 + 피드백 메시지

#### TC-004: 다시 하기
1. 결과 화면에서 '다시 해보기' 버튼 탭
2. 녹음 초기 상태(idle)로 돌아가는지 확인
- **기대 결과:** ✅ 마이크 버튼 + '버튼을 눌러 말해보세요' 복귀

#### TC-005: 뒤로 가기
1. 상세 화면에서 뒤로가기 버튼 탭
2. 메인 그리드 화면으로 돌아가는지 확인
- **기대 결과:** ✅ 메인 화면 복귀

### 3.2 엣지 케이스 테스트

| 시나리오 | 절차 | 기대 결과 |
|---|---|---|
| 아무 말 안 함 | 녹음 시작 후 10초 대기 | 0점 결과 표시 |
| 관계없는 말 발화 | "오늘 날씨 좋다" 발화 | 낮은 점수 (0~40점) |
| 마이크 권한 거부 | 권한 팝업에서 거부 | '마이크 권한이 필요해요' 표시 |
| 빠르게 중지 | 녹음 시작 후 즉시 중지 탭 | 인식된 텍스트 없음, 0점 |

---

## 4. 플랫폼별 테스트 체크리스트

### Chrome (웹)
- [ ] 앱 로딩 정상
- [ ] 6개 지역 카드 표시
- [ ] 마이크 권한 팝업 노출
- [ ] 음성 인식 동작
- [ ] 점수 애니메이션 정상
- [ ] 뒤로가기 정상

### Android
- [ ] APK 설치 성공
- [ ] 마이크 권한 요청 팝업
- [ ] 음성 인식 동작 (네트워크 필요)
- [ ] 효과음 재생
- [ ] 화면 회전 시 상태 유지

---

## 5. 커버리지 확인

```bash
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

현재 테스트 커버리지 목표: **유틸리티 레이어 80% 이상**
