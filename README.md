# 🧾 Billow (빌로우) - Frontend

**헤매는 사회초년생을 위한 첫 독립 가이드**

---

### **✨ 주요 기능 (Key Features)**

- **AI 공과금 리포트:** Naver Clova OCR을 활용한 고지서 자동 분석 및 시각화.
- **그린 챌린지:** 일상 속 환경 보호 미션을 게임처럼 즐기고 인증하는 시스템.
- **슬기로운 자취 생활:** 사회초년생을 위한 실용적인 생활 꿀팁 및 정보 제공.
- **마이페이지 & 그린 마켓:** 활동 포인트를 지역화폐로 교환하는 실질적인 보상 허브.
- **이웃 비교:** 위치 기반 데이터를 활용해 주변 평균 사용량과 비교 리포트 제공.

---

### **🛠️ 기술 스택 (Tech Stack)**

- **Main:** `Flutter`
- **State Management:** `Riverpod`
- **Navigation:** `go_router`
- **API Communication:** `Dio`
- **Dependency Injection:** `GetIt`
- **Local Storage:** `shared_preferences`
- **Collaboration:** `Git`, `GitHub`, `Figma`

---

### **🏗️ 아키텍처 (Architecture)**

본 프로젝트는 **클린 아키텍처(Clean Architecture)**를 기반으로 MVVM(Model-View-ViewModel) 패턴을 구현합니다. 이는 UI, 비즈니스 로직, 데이터 계층을 명확하게 분리하여 유지보수성, 확장성, 그리고 테스트 용이성을 극대화합니다.

- **Presentation Layer (UI):** 화면 렌더링 및 사용자 입력 처리 (`/presentation`)
- **Domain Layer (Business Logic):** 모든 비즈니스 로직을 포함하는 순수한 Dart 코드 (`/domain`)
- **Data Layer (Data Source):** API 통신, 로컬 데이터베이스 접근 등 외부 데이터 관련 로직 처리 (`/data`)

---

## 🌿 Branch 전략

본 프로젝트는 Gitflow 브랜치 전략을 따릅니다.

<img width="600" height="800" alt="git" src="https://github.com/user-attachments/assets/6754c9a1-072e-4b74-b10d-a885f6887de4" />

- `main`: 배포 가능한 단위의 브랜치
- `release`: 배포 전 테스트용 브랜치
- `develop`: 개발 중인 브랜치
- `feature/#issue_number`: 개발 단위별 브랜치
- `hotfix`: `master` 브랜치의 긴급 버그 수정 브랜치

### 개발 흐름
1. 개발할 기능에 대한 이슈 등록 후 번호 발급  
2. `develop` 브랜치에서 분기 → `feature/#issue_number` 브랜치 생성 및 작업  
3. 작업 완료 후 Pull Request 작성 → 리뷰 후 병합  

---

### **📝 Commit 규칙**

| 헤더 | 설명 |
|---|---|
| feat | 새로운 기능 추가 |
| fix | 버그 수정 |
| build | 빌드 환경, 외부 모듈(pubspec.yaml) 관련 수정 |
| chore | 기타 자잘한 수정, 의존성 관리 |
| ci | CI 관련 설정 수정 |
| docs | 문서 수정 |
| style | 코드 스타일 및 포맷 수정 |
| refactor | 코드 리팩토링 |
| test | 테스트 코드 수정 |
| perf | 성능 개선 |

---

### **📌 Issue & 🔀 Pull Request**

- **Issue:** 기능 또는 버그 수정 단위로 이슈를 등록하고, 템플릿에 따라 상세 내용을 작성합니다.
- **Pull Request:** PR은 등록된 템플릿을 사용하여 작성하며, 코드 리뷰 후 병합합니다.

---

### **🎯 Convention**

#### **네이밍 규칙 (Naming Convention)**

- **Dart 파일 이름:** `snake_case` (`my_cool_feature.dart`)
- **폴더 이름:** 소문자 `snake_case`
- **클래스 이름:** `PascalCase`
- **함수 및 변수:** `camelCase`
- **상수:** `SNAKE_CASE` (const, static final)
- **콜백 함수:** `on` 접두사 사용 (예: `onButtonClicked`)
- **상태 변수:** `is`, `has` 접두사 사용 (예: `isLoading`)
- 한국어 발음 표기는 사용하지 않습니다.

---

### **🚀 시작하기 (Getting Started)**

```bash
# 1. 저장소 복제
git clone [https://github.com/9oormthon-univ/2025_SEASONTHON_TEAM_83_FE.git](https://github.com/9oormthon-univ/2025_SEASONTHON_TEAM_83_FE.git)

# 2. 폴더 이동
cd 2025_SEASONTHON_TEAM_83_FE

# 3. 의존성 설치
flutter pub get

# 4. 개발 서버 실행
flutter run
