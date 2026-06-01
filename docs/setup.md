# 개발 환경 설정 가이드

## 사전 요구사항

| 도구 | 최소 버전 | 확인 명령 |
|---|---|---|
| Flutter SDK | 3.0.0 이상 | `flutter --version` |
| Dart SDK | 3.0.0 이상 (Flutter 내장) | `dart --version` |
| Git | 2.x | `git --version` |
| Chrome | 최신 버전 | (웹 빌드 시) |
| Android Studio 또는 VS Code | 최신 | — |

---

## 1. Flutter SDK 설치

### Windows

1. [flutter.dev/install](https://flutter.dev/docs/get-started/install/windows) 에서 Flutter SDK ZIP 다운로드
2. `C:\flutter` 에 압축 해제
3. 환경 변수 PATH에 `C:\flutter\bin` 추가
   ```
   시스템 속성 → 환경 변수 → Path → 새로 만들기 → C:\flutter\bin
   ```
4. 터미널 재시작 후 확인:
   ```
   flutter --version
   ```

### macOS

```bash
# Homebrew 사용
brew install --cask flutter

# 또는 직접 설치
curl -O https://storage.googleapis.com/flutter_infra_release/releases/stable/macos/flutter_macos_arm64_3.x.x-stable.zip
unzip flutter_macos_arm64_*.zip
export PATH="$PATH:`pwd`/flutter/bin"
```

---

## 2. Flutter 환경 점검

```bash
flutter doctor
```

모든 항목이 ✓ 이어야 한다. 문제 항목이 있으면 출력된 안내에 따라 해결한다.

일반적인 해결 방법:
- **Android toolchain:** Android Studio → SDK Manager에서 Android SDK Command-line Tools 설치
- **Chrome:** Chrome 브라우저 설치
- **VS Code:** Flutter + Dart 확장 설치

---

## 3. 저장소 클론

```bash
git clone https://github.com/jhh1216/saturi-app.git
cd saturi-app
```

---

## 4. 의존성 설치

```bash
flutter pub get
```

설치되는 주요 패키지:

| 패키지 | 역할 |
|---|---|
| `speech_to_text` | 음성 인식 (한국어 ko_KR) |
| `audioplayers` | 효과음 재생 |

---

## 5. 실행

### Chrome (웹) — 가장 빠른 방법

```bash
flutter run -d chrome
```

브라우저가 자동으로 열리고 앱이 실행된다.

> 마이크 권한 팝업이 뜨면 **허용**을 눌러야 음성 인식이 작동한다.

### Android 에뮬레이터

1. Android Studio → AVD Manager → 에뮬레이터 생성 및 실행
2. 에뮬레이터가 켜진 상태에서:
   ```bash
   flutter run -d android
   ```

### 실제 Android 기기

1. 개발자 옵션 → USB 디버깅 활성화
2. USB 연결 후:
   ```bash
   flutter devices        # 연결된 기기 확인
   flutter run -d <기기ID>
   ```

### Windows 앱 (주의)

Windows 빌드는 **개발자 모드**가 필요하다.

```
설정 → 개인 정보 보호 및 보안 → 개발자용 → 개발자 모드 ON
```

이후:
```bash
flutter run -d windows
```

---

## 6. 개발 도구 설정 (VS Code 권장)

### 확장 프로그램 설치

- **Flutter** (Dart Code 팀) — 필수
- **Dart** (Dart Code 팀) — 필수
- **Material Icon Theme** — 선택

### 유용한 단축키

| 동작 | 단축키 |
|---|---|
| Hot Reload | `r` (터미널) 또는 `Ctrl+F5` |
| Hot Restart | `R` (터미널, 상태 초기화) |
| 앱 종료 | `q` |
| 디바이스 목록 | `flutter devices` |

---

## 7. 폴더 구조 이해

```
lib/
├── main.dart               # 앱 시작점, 메인 화면
├── data/dialect_data.dart  # 방언 데이터 (여기에 문장 추가)
├── screens/                # 화면 단위 위젯
├── widgets/                # 재사용 위젯
├── theme/app_theme.dart    # 색상 변경 시 여기 수정
└── utils/                  # 유틸리티 (채점, 효과음)
```

---

## 8. 흔한 문제 해결

### `flutter pub get` 실패

```bash
flutter clean
flutter pub get
```

### Chrome에서 마이크가 안 됨

- 주소창 왼쪽 자물쇠 아이콘 → 마이크 → 허용

### Android에서 `speech_to_text` 초기화 실패

- 기기 설정 → 앱 → 사투리 앱 → 권한 → 마이크 허용

### `Waiting for connection...`이 너무 오래 걸림

- 이전 Flutter 프로세스가 Chrome을 점유 중일 수 있다
- Chrome을 완전히 종료 후 재실행
