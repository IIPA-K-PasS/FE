# 🧾 Billow (빌로우) - Frontend

**헤매는 사회초년생을 위한 AI 공과금·챌린지 관리 앱**

---

## ✨ 주요 기능
- **AI 공과금 리포트:** 고지서 촬영/OCR → 자동 parsing 및 시각 리포트
- **그린 챌린지:** 미션 수행, 인증(포인트 적립)
- **슬기로운 자취 생활:** 생활 팁, 꿀팁 북마크/추천
- **마이페이지 & 그린 마켓:** 포인트 → 지역화폐 교환, 활동 내역
- **이웃 비교:** 내 사용량 vs 동네 평균 분석 리포트
- **약관 동의:** native + github 전문 외부 링크 모두 제공

---

## 🛠️ 기술 스택
- **Main:** Flutter (Dart)
- **상태관리:** Riverpod
- **의존성:** Dio, shared_preferences, url_launcher, Kakao SDK 외
- **협업/디자인:** GitHub, Figma

---

## 🏗️ 아키텍처
- **Clean Architecture + MVVM**
- `/presentation` (UI), `/domain` (비즈니스로직), `/data` (API/DB 등) 명확 분리

---

## 🚀 실행 및 설치

### APK 빌드/설치 (Android)
1. **Flutter 설치**: 3.x 이상
2. 의존성 설치:
   ```bash
   flutter pub get
   ```
3. `.env` 파일 작성 (아래 예시 참고)
4. APK 빌드:
   ```bash
   flutter build apk --release
   ```
5. 폰에 APK 설치 및 실행

### iOS
- TestFlight/Ad-hoc 추후 지원

---

### 환경 변수 파일 (.env) 예시

```env
KAKAO_NATIVE_APP_KEY=xxxxxxxxxxxxxxxxxxxxxxxxxx
BASE_URL=https://api.example.com
```
- `BASE_URL`은 공공 테스트 API 주소로 공개해도 무방 (운영·내부 민감 정보는 별도 관리)
- 카카오 키/API키 등은 제출시 별도 전달 권장

- “사전 설치/환경 변수” 챕터에  
  “**비밀키/환경파일(.env, local.properties)은 보안을 위해 git에 커밋되지 않으니 생성 예시와 위치를 아래처럼 반드시 직접 입력/복사해야 합니다**”  
- 환경파일 미작성시 실행 불가/카카오 인증 불가/빌드오류 가능 강조

- `.env.example`, `local.properties.example` 등을 커밋
    - “이 파일을 복제/이름변경하여 본인의 값을 채워야 정상 실행됨” 주석 삽입
    - ex:
  
---

## 🧑‍💻 계정 안내/테스트

- **카카오 소셜 로그인만 지원**  
  (개인/임시 계정 필요 없음, 모든 기능 즉시 체험 가능)

---

## 💻 소스 및 협업툴
- **GitHub:** [https://github.com/팀명/Repo](#)  
- **Figma:** (선택사항) [링크](#)

---

## 📸 주요 앱 화면 (예시)
- 온보딩
- 메인/리포트
- 챌린지
- 약관동의
- 꿀팁/북마크
- 그린마켓/포인트

---

### 🔗 APK 다운로드/접속 URL

- (구글드라이브/깃허브 릴리즈 등 실제 배포시 링크 삽입)
- iOS 추후 지원(심사 참고)

---

## 📝 추가 안내
- 자세한 API/구현 구조/은 README 혹은 접수신청서 PDF 내 포함
- 모든 화면/기능 more detail 스크린샷 별도 제출
- 문의사항은 issue/github/email로 응대

---

**문의 및 피드백 환영! 좋은 평가 부탁드립니다.**

---

## 🚨 [중요] 로컬 환경 변수 전달 및 실행 방법

앱 실행 또는 빌드 시, 환경 변수(KEY)들을 반드시 아래처럼 --dart-define 옵션으로 전달해야 합니다.
예시 (필수 키 모두 입력):

```sh
flutter run \
  --dart-define=KAKAO_NATIVE_APP_KEY=여기에_카카오_네이티브_키 \
  --dart-define=API_BASE_URL=여기에_API_URL \
  --dart-define=NAVER_CLIENT_ID=네이버_ID \
  --dart-define=NAVER_CLIENT_SECRET=네이버_시크릿 \
  --dart-define=OPENWEATHERMAP_API_KEY=오픈웨더MAP키
```

- Android Studio/VSCode는 해당 옵션을 Run/Edit Configurations에서 "Additional run args" 또는 Arguments 입력란에 추가할 것
- 빌드(`flutter build apk`, `flutter build web` 등)도 마찬가지로 --dart-define 옵션 필수
- ⚠️ 전달하지 않으면 앱 실행 시점에 즉시 "xxx is not set (pass via --dart-define)" 에러로 종료됩니다!
