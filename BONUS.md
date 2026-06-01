# BONUS.md — 가산점 신청 항목

## 신청 개요

프로젝트명: **사투리 (Saturi)** — 음성 인식 기반 방언 학습 Flutter 앱  
GitHub: https://github.com/jhh1216/saturi-app

---

## 가산점 항목

### 1. AI 코딩 어시스턴트 활용 (Claude Code)

**내용:** Claude Code CLI를 활용하여 프로젝트 전반에 걸쳐 개발을 진행했다.

**활용 내역:**

| 작업 | 활용 내용 |
|---|---|
| UI 설계 | 단청 스타일 → Samsung One UI 파스텔 스타일 리디자인 |
| 코드 작성 | RecordSheet, WaveRing, SimilarityCalculator 구현 |
| 리팩토링 | 색상 팔레트 분리, 파스텔 계산 로직 통일 |
| 문서화 | 14개 프로젝트 문서 작성 (아키텍처, ADR, 설정 가이드 등) |
| 디버깅 | Flutter Chrome 실행 오류, 브랜치명 오류 해결 |

**근거 파일:** `AGENTS.md` — Claude Code 사용 패턴 및 프롬프트 가이드 문서화

---

### 2. 아키텍처 설계 문서화 (ADR)

**내용:** 핵심 기술 결정 사항을 Architecture Decision Record(ADR) 형식으로 문서화했다.

| 문서 | 내용 |
|---|---|
| [ADR-001](.planning/decisions/ADR-001.md) | Flutter 선택 — React Native, Native 대비 이유 |
| [ADR-002](.planning/decisions/ADR-002.md) | speech_to_text 선택 — Google Cloud STT, Whisper 대비 |
| [ADR-003](.planning/decisions/ADR-003.md) | Levenshtein distance 선택 — 완전 일치, 자카드 대비 |

---

### 3. 체계적 프로젝트 관리 문서

**내용:** 소프트웨어 공학 방법론을 적용한 문서 체계를 구축했다.

| 문서 | 위치 | 설명 |
|---|---|---|
| 비전 문서 | `.planning/00-vision.md` | 앱 목적, 대상 사용자, 장기 방향 |
| MoSCoW 요구사항 | `.planning/01-requirements.md` | Must/Should/Could/Won't 분류 |
| WBS | `.planning/02-wbs.md` | 7개 주요 작업 영역, 세부 태스크 분류 |
| 일정 | `.planning/04-schedule.md` | 9~15주차 주차별 목표 및 체크리스트 |

---

### 4. 크로스플랫폼 지원

**내용:** 단일 코드베이스로 Android, iOS, Web(Chrome) 빌드를 모두 지원한다.

- `flutter run -d chrome` — 웹 브라우저에서 즉시 실행 가능
- `flutter build apk` — Android APK 빌드
- `flutter build web` — 정적 웹 빌드 (GitHub Pages 배포 가능)

---

### 5. 음성 인식 기반 인터랙티브 학습

**내용:** 단순 텍스트 학습을 넘어 사용자가 직접 발음하고 즉각 채점받는 인터랙티브 경험을 구현했다.

- 실시간 음성 인식 (`speech_to_text`, `ko_KR`)
- Levenshtein distance 기반 부분 채점 (0~100점)
- 점수 카운트업 애니메이션 + 4단계 피드백
- 성공/실패 효과음

---

### 6. 사용자 경험(UX) 품질

**내용:** 실제 모바일 앱 수준의 UI/UX를 구현했다.

- **Samsung One UI 스타일** 파스텔 카드 디자인
- 지역별 고유 색상 + 자동 파스텔 계산 (`Color.lerp`)
- WaveRing 녹음 파동 애니메이션 (3-layer stagger)
- 바텀시트 기반 녹음 UI (모달)
- 마이크 버튼 → 정지 버튼 애니메이션 전환

---

### 7. 문화적 가치 — 방언 보존

**내용:** 사라져가는 한국 지역 방언을 디지털로 기록하고 학습 콘텐츠화했다.

- 6개 지역 × 약 8~10문장 = 약 54개 방언 표현 수록
- 방언 ↔ 표준어 대역 제공
- 제주어, 강원 방언 등 소수 방언 포함
