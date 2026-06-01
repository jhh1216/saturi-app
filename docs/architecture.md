# 앱 아키텍처 — 사투리 (Saturi)

## 전체 구조

사투리 앱은 단일 Flutter 프로젝트로, 별도의 백엔드 서버 없이 모든 데이터와 로직이 클라이언트에 내장된다.

```
saturi_app/
├── lib/
│   ├── main.dart                  # 앱 진입점, RegionGridPage
│   ├── data/
│   │   └── dialect_data.dart      # 방언 데이터 (정적 상수)
│   ├── screens/
│   │   └── region_detail_page.dart # 지역 상세 화면
│   ├── widgets/
│   │   ├── record_sheet.dart       # 녹음 바텀시트
│   │   └── wave_ring.dart          # 파동 애니메이션 위젯
│   ├── theme/
│   │   └── app_theme.dart          # 색상 팔레트, ThemeData
│   └── utils/
│       ├── similarity.dart         # Levenshtein distance 채점
│       └── sound_player.dart       # 효과음 재생
```

---

## 화면 흐름

```
RegionGridPage (메인)
    │
    │  탭(지역 카드)
    ▼
RegionDetailPage (문장 목록)
    │
    │  탭(마이크 버튼)
    ▼
RecordSheet (ModalBottomSheet)
    ├── idle    → 마이크 버튼 표시
    ├── recording → WaveRing 애니메이션, 실시간 텍스트
    └── done    → 점수 + 피드백 + 다시하기
```

---

## 레이어 설명

### 1. 데이터 레이어 (`lib/data/`)

모든 방언 데이터는 빌드 타임에 Dart 상수로 내장된다. 외부 API나 DB가 없다.

```dart
class DialectSentence {
  final String dialect;   // 방언 표현
  final String standard;  // 표준어 번역
}

class Region {
  final String name;
  final String emoji;
  final List<DialectSentence> sentences;
}

const List<Region> regions = [ /* 6개 지역 */ ];
```

### 2. 유틸리티 레이어 (`lib/utils/`)

#### `similarity.dart` — Levenshtein Distance 채점

두 문자열 간의 편집 거리(Edit Distance)를 계산하여 0~100점으로 정규화한다.

```dart
static int calculate(String target, String input) {
  // 1. Levenshtein distance(a, b) 계산 — O(m×n) DP
  // 2. score = (1 - distance / max(len_a, len_b)) * 100
  // 3. clamp(0, 100) 후 반환
}
```

**선택 이유:** 오탈자·받침 차이에도 부분 점수를 주어 학습 동기를 유지한다. 단순 일치 비교는 '거의 맞음'에도 0점을 주는 문제가 있다.

#### `sound_player.dart` — 효과음

`audioplayers` 패키지로 로컬 asset 효과음을 재생한다.

```dart
static void playSuccess() => ...  // 70점 이상
static void playFail()    => ...  // 70점 미만
```

### 3. UI 레이어 (`lib/screens/`, `lib/widgets/`)

#### 상태 관리

`RecordSheet`는 `StatefulWidget`으로 내부 상태를 직접 관리한다. 앱 규모가 작아 Provider/Riverpod 같은 외부 상태관리 라이브러리를 사용하지 않는다.

```dart
enum _State { idle, recording, done }

class _RecordSheetState extends State<RecordSheet> {
  _State _state = _State.idle;
  String _recognized = '';
  int    _score = 0;
  bool   _ready = false;
}
```

#### 파스텔 색상 계산

지역별 고유 색상에서 파스텔 배경색을 동적으로 계산한다.

```dart
final Color pastel = Color.lerp(accentColor, Colors.white, 0.82)!;
```

`0.82`는 흰색 방향으로 82% 블렌드 — 배경은 연하고, 텍스트/아이콘에는 원색 사용.

#### `WaveRing` 애니메이션

3개의 `AnimationController`를 520ms 간격으로 stagger하여 파동 효과를 만든다.

```dart
// scale: 1.0 → 2.3 (easeOut)
// opacity: 0.65 → 0.0 (easeOut)
// 반복 주기: 1700ms
```

---

## 핵심 패키지

| 패키지 | 버전 | 역할 |
|---|---|---|
| `speech_to_text` | ^7.x | 마이크 음성 → 텍스트 변환 (한국어 ko_KR) |
| `audioplayers` | ^6.x | 효과음 재생 (성공/실패 사운드) |
| `flutter` SDK | ≥3.0 | UI 프레임워크 |

---

## 음성 인식 흐름

```
사용자 발화
    │
    ▼
SpeechToText.listen(localeId: 'ko_KR')
    │
    ├── onResult(partial) → setState(_recognized = words)
    │
    └── onResult(final)   → _finish()
                                │
                                ▼
                        SimilarityCalculator.calculate(
                            target: sentence.dialect,
                            input:  _recognized
                        )
                                │
                                ▼
                        score 0~100
                        setState(_state = done)
                        SoundPlayer.play(score)
```

---

## 플랫폼별 고려사항

| 플랫폼 | 음성 인식 | 주의사항 |
|---|---|---|
| Android | ✅ 지원 | `RECORD_AUDIO` 권한 필요 |
| iOS | ✅ 지원 | `NSMicrophoneUsageDescription` Info.plist 필요 |
| Web (Chrome) | ✅ 지원 | HTTPS 또는 localhost 필요, Web Speech API 사용 |
| Windows | ⚠️ 제한적 | Developer Mode 활성화 필요 |

---

## 확장 포인트

향후 기능 추가 시 영향 받는 파일:

| 기능 | 수정 파일 |
|---|---|
| 방언 문장 추가 | `lib/data/dialect_data.dart` |
| 지역 추가 | `dialect_data.dart` + `app_theme.dart` (kRegionColors) |
| TTS 듣기 기능 | `lib/utils/sound_player.dart` 또는 새 tts_player.dart |
| 점수 저장 | 새 `lib/utils/score_storage.dart` (SharedPreferences) |
| 다크 모드 | `lib/theme/app_theme.dart` |
