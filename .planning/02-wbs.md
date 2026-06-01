# 작업 분류 구조 (WBS) — 사투리 앱

## 1. 프로젝트 관리

- 1.1 요구사항 분석 및 기획
  - 1.1.1 지역별 방언 데이터 수집
  - 1.1.2 MoSCoW 요구사항 정의
  - 1.1.3 UI/UX 레퍼런스 수집
- 1.2 설계
  - 1.2.1 앱 아키텍처 설계
  - 1.2.2 화면 흐름(Flow) 설계
  - 1.2.3 데이터 모델 설계
- 1.3 문서화
  - 1.3.1 비전 문서 작성
  - 1.3.2 ADR 작성
  - 1.3.3 README 작성

---

## 2. 환경 설정

- 2.1 개발 환경
  - 2.1.1 Flutter SDK 설치 및 버전 고정
  - 2.1.2 pubspec.yaml 의존성 정의
  - 2.1.3 Android 권한 설정 (RECORD_AUDIO)
  - 2.1.4 iOS 권한 설정 (NSMicrophoneUsageDescription)
- 2.2 형상 관리
  - 2.2.1 Git 저장소 초기화
  - 2.2.2 .gitignore 설정
  - 2.2.3 GitHub remote 연결

---

## 3. 데이터 레이어

- 3.1 방언 데이터 정의
  - 3.1.1 DialectSentence 모델 클래스
  - 3.1.2 Region 모델 클래스
  - 3.1.3 서울 방언 문장 입력
  - 3.1.4 부산 방언 문장 입력
  - 3.1.5 전라 방언 문장 입력
  - 3.1.6 충청 방언 문장 입력
  - 3.1.7 강원 방언 문장 입력
  - 3.1.8 제주 방언 문장 입력

---

## 4. 핵심 기능 구현

- 4.1 음성 인식 (speech_to_text)
  - 4.1.1 SpeechToText 초기화 및 권한 요청
  - 4.1.2 녹음 시작/중지 로직
  - 4.1.3 실시간 인식 텍스트 스트림 처리
  - 4.1.4 finalResult 처리 및 채점 트리거
- 4.2 유사도 계산 (similarity.dart)
  - 4.2.1 Levenshtein distance 알고리즘 구현
  - 4.2.2 0~100 정규화 점수 변환
  - 4.2.3 엣지케이스 처리 (빈 문자열, 동일 문자열)
- 4.3 효과음 (sound_player.dart)
  - 4.3.1 성공 효과음 재생 (70점 이상)
  - 4.3.2 실패 효과음 재생 (70점 미만)

---

## 5. UI 구현

- 5.1 테마 / 디자인 시스템
  - 5.1.1 지역별 색상 팔레트 정의 (app_theme.dart)
  - 5.1.2 파스텔 색상 계산 로직 (Color.lerp)
  - 5.1.3 MaterialApp 테마 설정
- 5.2 메인 화면 (RegionGridPage)
  - 5.2.1 AppBar — 국기 이모지 + '사투리' 타이틀
  - 5.2.2 2열 그리드 레이아웃
  - 5.2.3 지역 카드 컴포넌트 (_RegionCard)
- 5.3 지역 상세 화면 (RegionDetailPage)
  - 5.3.1 AppBar — 지역 이모지 + 이름
  - 5.3.2 문장 리스트 (ListView)
  - 5.3.3 문장 타일 컴포넌트 (_SentenceTile)
  - 5.3.4 마이크 버튼 → BottomSheet 연결
- 5.4 녹음 바텀시트 (RecordSheet)
  - 5.4.1 핸들 바 + 지역명 칩
  - 5.4.2 방언 문장 + 표준어 표시
  - 5.4.3 녹음 섹션 (_RecordSection)
  - 5.4.4 결과 섹션 (_ResultSection)
  - 5.4.5 다시 하기 버튼
- 5.5 애니메이션
  - 5.5.1 WaveRing 파동 애니메이션 (wave_ring.dart)
  - 5.5.2 점수 카운트업 TweenAnimationBuilder
  - 5.5.3 원형 CircularProgressIndicator 애니메이션

---

## 6. 테스트

- 6.1 유닛 테스트
  - 6.1.1 SimilarityCalculator 경계값 테스트
  - 6.1.2 동일 문자열 → 100점 검증
  - 6.1.3 완전히 다른 문자열 → 0점 검증
- 6.2 위젯 테스트
  - 6.2.1 RegionGridPage 렌더링 테스트
  - 6.2.2 지역 카드 탭 → 화면 전환 테스트
- 6.3 수동 테스트
  - 6.3.1 실제 기기/에뮬레이터 음성 인식 테스트
  - 6.3.2 Chrome 웹 빌드 동작 확인

---

## 7. 배포

- 7.1 웹 배포 (Firebase Hosting / GitHub Pages)
  - 7.1.1 flutter build web
  - 7.1.2 배포 스크립트 작성
- 7.2 Android 빌드
  - 7.2.1 릴리즈 APK 빌드
  - 7.2.2 서명 키 설정
- 7.3 문서
  - 7.3.1 배포 가이드 작성 (docs/deploy.md)
  - 7.3.2 GitHub README 최종 업데이트
