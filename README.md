# 🇰🇷 사투리 (Saturi)

대한민국 6개 지역 방언을 **직접 말하며 배우는** 음성 인식 기반 사투리 학습 앱

[![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.x-0175C2?logo=dart)](https://dart.dev)
[![License](https://img.shields.io/badge/License-MIT-green)](LICENSE)

---

## 주요 기능

### 지역별 방언 학습
- 서울, 부산, 전라, 충청, 강원, 제주 **6개 지역** 방언 수록
- 각 지역별 방언 표현 + 표준어 번역 제공

### 음성 인식 발음 연습
- 마이크 버튼을 눌러 방언 문장을 따라 말한다
- `speech_to_text` 패키지로 한국어(`ko_KR`) 실시간 인식
- 녹음 중 WaveRing 파동 애니메이션

### 즉각적 발음 채점
- **Levenshtein distance** 알고리즘으로 0~100점 채점
- 점수 카운트업 애니메이션
- 4단계 피드백 메시지

| 점수 | 피드백 |
|---|---|
| 90~100점 | 완벽해요! 진짜 현지인 같아요 🎉 |
| 70~89점 | 괜찮아요! 조금만 더 연습하면 돼요 👍 |
| 50~69점 | 아쉬워요. 다시 들어보고 따라해봐요 🔄 |
| 0~49점 | 처음부터 다시 해봐요! 💪 |

- 70점 이상: 성공 효과음 / 미만: 실패 효과음

---

## 기술 스택

| 구분 | 기술 |
|---|---|
| 프레임워크 | Flutter 3.x (Dart 3.x) |
| 음성 인식 | `speech_to_text ^7.x` |
| 효과음 | `audioplayers ^6.x` |
| 채점 알고리즘 | Levenshtein Distance (순수 Dart 구현) |
| 상태 관리 | StatefulWidget (내장) |
| 디자인 시스템 | Material Design 3 + 커스텀 파스텔 팔레트 |

---

## 설치 및 실행

### 사전 요구사항

- Flutter SDK 3.0.0 이상
- Chrome (웹 실행 시)

### 빠른 시작

```bash
# 1. 저장소 클론
git clone https://github.com/jhh1216/saturi-app.git
cd saturi-app

# 2. 의존성 설치
flutter pub get

# 3. Chrome에서 실행
flutter run -d chrome
```

자세한 설정 방법은 [docs/setup.md](docs/setup.md) 참고

---

## 프로젝트 구조

```
lib/
├── main.dart                   # 앱 진입점, 메인 그리드 화면
├── data/
│   └── dialect_data.dart       # 6개 지역 방언 데이터
├── screens/
│   └── region_detail_page.dart # 지역 상세 화면
├── widgets/
│   ├── record_sheet.dart       # 녹음 바텀시트
│   └── wave_ring.dart          # 파동 애니메이션
├── theme/
│   └── app_theme.dart          # 색상 팔레트, 테마
└── utils/
    ├── similarity.dart         # Levenshtein 채점 로직
    └── sound_player.dart       # 효과음 재생
```

---

## 지원 지역

| 지역 | 이모지 | 특징 |
|---|---|---|
| 서울/표준어 | 🏙️ | 표준어 기반, 기준점 학습 |
| 부산/경상도 | 🌊 | 강한 억양, 독특한 어미 |
| 전라도 | 🌾 | 부드러운 말투, 고유 어미 |
| 충청도 | 🌻 | 느린 리듬, 온화한 표현 |
| 강원도 | 🏔️ | 산간 방언, 독특한 어휘 |
| 제주도 | 🍊 | 가장 이질적, 풍부한 고유어 |

---

## 문서

- [아키텍처](docs/architecture.md) — 앱 구조, 음성 인식 흐름, 채점 알고리즘
- [개발환경 설정](docs/setup.md) — Flutter 설치부터 실행까지
- [배포 가이드](docs/deploy.md) — GitHub Pages, Firebase Hosting, APK
- [테스트](docs/testing.md) — 유닛/위젯/수동 테스트 방법

### 설계 결정 (ADR)
- [ADR-001](.planning/decisions/ADR-001.md) — Flutter 선택 이유
- [ADR-002](.planning/decisions/ADR-002.md) — speech_to_text 패키지 선택
- [ADR-003](.planning/decisions/ADR-003.md) — Levenshtein distance 채점 선택

---

## 라이선스

MIT License — 자유롭게 사용, 수정, 배포 가능
