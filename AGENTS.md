# AGENTS.md — Claude Code 사용 가이드

이 파일은 Claude Code(AI 코딩 어시스턴트)가 이 프로젝트를 작업할 때 참고하는 지침이다.

---

## 프로젝트 개요

- **앱 이름:** 사투리 (Saturi)
- **플랫폼:** Flutter (Dart)
- **주요 기능:** 6개 지역 방언 학습 + 음성 인식 채점
- **GitHub:** https://github.com/jhh1216/saturi-app

---

## 핵심 파일 맵

| 파일 | 역할 | 수정 빈도 |
|---|---|---|
| `lib/main.dart` | 메인 화면 (그리드, AppBar, 카드) | 높음 |
| `lib/data/dialect_data.dart` | 방언 문장 데이터 | 중간 |
| `lib/theme/app_theme.dart` | 색상, 테마 | 중간 |
| `lib/screens/region_detail_page.dart` | 지역 상세 + 문장 타일 | 중간 |
| `lib/widgets/record_sheet.dart` | 녹음 바텀시트 | 낮음 |
| `lib/widgets/wave_ring.dart` | 파동 애니메이션 | 낮음 |
| `lib/utils/similarity.dart` | Levenshtein 채점 | 낮음 |
| `lib/utils/sound_player.dart` | 효과음 | 낮음 |

---

## 코딩 컨벤션

- **상태관리:** `StatefulWidget` 직접 사용 (Provider/Riverpod 없음)
- **색상:** `app_theme.dart`의 `kRegionColors` 리스트 인덱스로 관리
- **파스텔 색상:** `Color.lerp(color, Colors.white, 0.82)` 패턴
- **Dart:** `const` 생성자 적극 사용, `withValues(alpha:)` (deprecated된 `withOpacity` 대신)
- **주석:** 최소화, 섹션 구분선(`// ── 제목 ──`)만 사용

---

## 자주 쓰는 프롬프트 패턴

### 방언 문장 추가
```
dialect_data.dart에 경상도 지역(부산) 방언 문장 5개 추가해줘.
방언 표현과 표준어 번역 쌍으로.
```

### UI 색상 변경
```
app_theme.dart에서 제주 지역 색상을 #FF6B6B에서 #FF8E53으로 바꿔줘.
```

### 새 화면 추가
```
학습 통계 화면 추가해줘. 지역별 평균 점수를 bar chart로 보여줘.
lib/screens/stats_page.dart로 만들고 main.dart AppBar에 아이콘 버튼 추가.
```

### 기능 버그 수정
```
RecordSheet에서 녹음 중 뒤로가기를 누르면 앱이 튕기는 버그 수정해줘.
dispose()에서 speech cancel이 제대로 안 되는 것 같아.
```

### 빌드 및 실행
```
flutter run -d chrome
flutter build web --release --base-href "/saturi-app/"
flutter test
```

---

## 금지 사항

- `lib/data/dialect_data.dart`의 기존 문장 임의 삭제 금지
- `kRegionColors` 리스트 순서 변경 금지 (인덱스로 지역과 1:1 매핑됨)
- `speech_to_text` 패키지를 다른 패키지로 교체 시 ADR 문서 업데이트 필요
- `withOpacity()` 사용 금지 → `withValues(alpha:)` 사용

---

## 테스트 실행

```bash
flutter test                    # 전체 테스트
flutter test --reporter expanded # 상세 출력
flutter analyze                 # 정적 분석
```

---

## 브랜치 전략

```
main        — 안정 버전, 배포 기준
feature/*   — 기능 개발
fix/*       — 버그 수정
docs/*      — 문서 작업
```

---

## 이 앱에서 Claude Code가 잘 하는 것

1. **방언 데이터 추가** — `dialect_data.dart` 포맷을 이해하고 새 문장 삽입
2. **UI 컴포넌트 수정** — Flutter 위젯 트리 구조 이해, 색상/패딩 조정
3. **애니메이션 구현** — AnimationController, TweenAnimationBuilder 패턴
4. **Dart 리팩토링** — 중복 코드 제거, const 추가
5. **문서 작성** — Markdown 형식 프로젝트 문서

## Claude Code 세션 시작 시 추천 컨텍스트

```
사투리 앱 Flutter 프로젝트야.
6개 지역 방언 학습 앱으로 speech_to_text로 음성 인식하고
Levenshtein distance로 채점해.
현재 lib/ 구조 보고 [작업 내용] 해줘.
```
