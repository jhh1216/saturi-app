# 프로젝트 일정 — 9주차 ~ 15주차

## 전체 일정 개요

| 주차 | 기간 | 주요 목표 | 상태 |
|---|---|---|---|
| 9주차 | ~ | 기획 확정 + 환경 설정 | ✅ 완료 |
| 10주차 | ~ | 데이터 레이어 + 핵심 기능 | ✅ 완료 |
| 11주차 | ~ | UI 1차 구현 (메인 + 상세) | ✅ 완료 |
| 12주차 | ~ | UI 2차 (녹음 시트 + 애니메이션) | ✅ 완료 |
| 13주차 | ~ | UI 리디자인 + 테스트 | ✅ 완료 |
| 14주차 | ~ | 문서화 + 배포 준비 | 🔄 진행 중 |
| 15주차 | ~ | 최종 점검 + 제출 | ⬜ 예정 |

---

## 9주차 — 기획 및 환경 설정

**목표:** 프로젝트 방향 확정, 개발 환경 구축

### 할 일
- [x] 앱 아이디어 확정 (사투리 학습 앱)
- [x] 지원 지역 6개 선정 (서울·부산·전라·충청·강원·제주)
- [x] Flutter 프로젝트 생성 (`flutter create saturi_app`)
- [x] 핵심 패키지 선정 및 pubspec.yaml 설정
  - `speech_to_text` — 음성 인식
  - `audioplayers` — 효과음
- [x] Android 마이크 권한 설정
- [x] 데이터 모델 설계 (`Region`, `DialectSentence`)
- [x] 비전 문서 초안 작성

**산출물:** Flutter 프로젝트 초기 구조, pubspec.yaml

---

## 10주차 — 데이터 레이어 + 핵심 기능

**목표:** 방언 데이터 입력 완료, 음성 인식 + 채점 로직 구현

### 할 일
- [x] 6개 지역 방언 문장 데이터 입력 (`lib/data/dialect_data.dart`)
  - 지역별 8~10개 문장
  - 방언 표현 + 표준어 번역 쌍
- [x] Levenshtein distance 알고리즘 구현 (`lib/utils/similarity.dart`)
- [x] 0~100 점수 정규화 함수
- [x] `speech_to_text` 초기화 및 한국어 설정
- [x] 녹음 시작/중지/결과 처리 로직
- [x] 효과음 플레이어 구현 (`lib/utils/sound_player.dart`)

**산출물:** similarity.dart, sound_player.dart, dialect_data.dart

---

## 11주차 — UI 1차 구현

**목표:** 메인 화면(지역 그리드) + 상세 화면(문장 목록) 구현

### 할 일
- [x] 테마 및 색상 팔레트 정의 (`lib/theme/app_theme.dart`)
  - 지역별 단청 색상 (초기 버전)
- [x] `RegionGridPage` 구현 (main.dart)
  - 2열 그리드
  - AppBar 타이틀
- [x] `_RegionCard` 위젯 구현
  - 이모지 + 지역명 + 문장 수 뱃지
- [x] `RegionDetailPage` 구현
  - 문장 리스트 (ListView)
  - `_SentenceTile` 위젯

**산출물:** main.dart, region_detail_page.dart, app_theme.dart

---

## 12주차 — 녹음 시트 + 애니메이션

**목표:** 녹음 UI 완성, 파동 애니메이션, 점수 애니메이션

### 할 일
- [x] `RecordSheet` 바텀시트 구현 (`lib/widgets/record_sheet.dart`)
  - 핸들 바, 지역명, 방언 문장 표시
  - 상태 관리 (idle / recording / done)
- [x] `_RecordSection` 위젯 (녹음 전/중)
- [x] `_ResultSection` 위젯 (채점 결과)
  - 원형 점수 + 카운트업 애니메이션
  - 피드백 메시지 (4단계)
  - 다시 하기 버튼
- [x] `WaveRings` 파동 애니메이션 위젯 (`lib/widgets/wave_ring.dart`)
  - 3개 레이어 ripple 효과
  - AnimationController 기반

**산출물:** record_sheet.dart, wave_ring.dart

---

## 13주차 — UI 리디자인 + 테스트

**목표:** 디자인 개선 (Samsung One UI 스타일), 기능 검증

### 할 일
- [x] 디자인 전면 리디자인
  - 단청 스타일 → 파스텔 카드 스타일
  - AppBar: 흰 배경 + 다크 텍스트
  - 카드: 파스텔 배경 (`Color.lerp(color, Colors.white, 0.82)`)
  - 카드 레이아웃: 이모지 좌상단, 텍스트 하단
- [x] 지역 색상 교체 (블루·코랄·그린·오렌지·스카이·퍼플)
- [x] 앱 타이틀 변경: '사투리 배우기' → '🇰🇷 사투리'
- [x] 앱 이름 변경: AndroidManifest.xml, web/index.html, manifest.json
- [x] Chrome 빌드 (`flutter run -d chrome`) 동작 확인
- [x] GitHub 초기 커밋 및 push

**산출물:** 리디자인된 전체 UI, GitHub 저장소

---

## 14주차 — 문서화 + 배포 준비

**목표:** 프로젝트 문서 완성, 배포 빌드 준비

### 할 일
- [x] `.planning/` 디렉토리 문서 작성
  - 00-vision.md, 01-requirements.md, 02-wbs.md, 04-schedule.md
- [x] `docs/` 디렉토리 문서 작성
  - architecture.md, setup.md, deploy.md, testing.md
- [x] ADR 작성 (3개)
- [x] AGENTS.md 작성
- [x] README.md 완성
- [x] BONUS.md 작성
- [ ] `flutter build web` 웹 배포 빌드
- [ ] Firebase Hosting 또는 GitHub Pages 배포

**산출물:** 전체 프로젝트 문서, 배포 빌드

---

## 15주차 — 최종 점검 + 제출

**목표:** 버그 수정, 최종 데모 준비, 제출

### 할 일
- [ ] 전체 기능 최종 검수
  - 6개 지역 카드 탭 → 상세 화면 이동
  - 마이크 버튼 → 녹음 → 채점 → 결과
  - 다시 하기 → 초기 상태
- [ ] 알려진 버그 수정
  - 웹(Chrome)에서 Noto 폰트 경고 처리
- [ ] 발표 자료 준비 (시연 동영상 또는 스크린샷)
- [ ] 최종 GitHub push
- [ ] 제출

**산출물:** 완성된 앱, 발표 자료

---

## 마일스톤

```
9주  ──┬── 환경설정 완료
10주 ──┼── 핵심 로직 완료 (음성인식 + 채점)
11주 ──┼── MVP UI 완료
12주 ──┼── 전체 기능 완료
13주 ──┼── 디자인 완성 + GitHub 공개
14주 ──┼── 문서화 완료 ◀ 현재
15주 ──┴── 최종 제출
```
