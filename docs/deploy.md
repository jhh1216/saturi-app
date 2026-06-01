# 배포 가이드

## 배포 타겟 개요

| 플랫폼 | 방법 | 상태 |
|---|---|---|
| 웹 (Chrome) | GitHub Pages / Firebase Hosting | 권장 |
| Android APK | 직접 배포 / Google Play | 가능 |
| iOS | App Store (Mac 필요) | 해당시 |

---

## 1. 웹 배포 — GitHub Pages

### 1.1 웹 빌드

```bash
cd saturi_app
flutter build web --release --base-href "/saturi-app/"
```

> `--base-href`는 GitHub Pages 저장소 이름에 맞게 변경한다.
> 예: 저장소가 `jhh1216/saturi-app`이면 `/saturi-app/`

빌드 결과물은 `build/web/` 폴더에 생성된다.

### 1.2 gh-pages 브랜치로 배포

```bash
# 빌드 결과를 gh-pages 브랜치로 push
git subtree push --prefix build/web origin gh-pages
```

### 1.3 GitHub Pages 설정

1. GitHub 저장소 → Settings → Pages
2. Source: `Deploy from a branch`
3. Branch: `gh-pages` / `/(root)` 선택
4. Save

배포 URL: `https://jhh1216.github.io/saturi-app/`

---

## 2. 웹 배포 — Firebase Hosting (대안)

### 2.1 Firebase CLI 설치

```bash
npm install -g firebase-tools
firebase login
```

### 2.2 프로젝트 초기화

```bash
firebase init hosting
# Public directory: build/web
# Single-page app: Yes
# Overwrite index.html: No
```

### 2.3 빌드 및 배포

```bash
flutter build web --release
firebase deploy
```

배포 URL: `https://<project-id>.web.app`

---

## 3. Android APK 배포

### 3.1 릴리즈 APK 빌드

```bash
flutter build apk --release
```

결과 파일: `build/app/outputs/flutter-apk/app-release.apk`

> APK를 직접 설치하려면 기기에서 **출처를 알 수 없는 앱 허용** 설정이 필요하다.

### 3.2 App Bundle (Google Play 업로드용)

```bash
flutter build appbundle --release
```

결과 파일: `build/app/outputs/bundle/release/app-release.aab`

### 3.3 서명 키 설정 (Play Store 배포 시)

```bash
# 1. keystore 생성
keytool -genkey -v -keystore ~/upload-keystore.jks \
  -keyalg RSA -keysize 2048 -validity 10000 \
  -alias upload

# 2. android/key.properties 파일 생성 (gitignore에 포함)
storePassword=<비밀번호>
keyPassword=<비밀번호>
keyAlias=upload
storeFile=<keystore 경로>

# 3. android/app/build.gradle.kts에 서명 설정 추가
```

> `key.properties`는 절대 git에 커밋하지 않는다.

---

## 4. iOS 배포 (macOS 필요)

```bash
flutter build ios --release
```

Xcode에서 Archive → Distribute App → App Store Connect 업로드

---

## 5. 환경별 빌드 스크립트

`scripts/build_web.sh` (또는 PowerShell):

```bash
#!/bin/bash
echo "🔨 Flutter 웹 빌드 시작..."
flutter clean
flutter pub get
flutter build web --release --base-href "/saturi-app/"
echo "✅ 빌드 완료: build/web/"
echo "🚀 GitHub Pages 배포 중..."
git subtree push --prefix build/web origin gh-pages
echo "🎉 배포 완료!"
```

---

## 6. 배포 체크리스트

배포 전 반드시 확인:

- [ ] `flutter doctor` 경고 없음
- [ ] `flutter test` 전체 통과
- [ ] 디버그 배너 비활성화 확인 (`debugShowCheckedModeBanner: false`)
- [ ] 앱 이름 확인 (`사투리`) — AndroidManifest.xml, web/index.html, manifest.json
- [ ] 마이크 권한 문구 적절한지 확인
- [ ] `flutter build web` 오류 없이 완료
- [ ] 빌드된 웹앱 localhost에서 최종 동작 확인

---

## 7. 버전 관리

`pubspec.yaml`의 `version` 필드로 관리:

```yaml
version: 1.0.0+1
#        ^     ^
#        |     빌드 번호 (정수, 매 배포마다 증가)
#        버전 이름 (semver)
```

배포 전:
```bash
# pubspec.yaml version 업데이트 후
git tag v1.0.0
git push origin v1.0.0
```
