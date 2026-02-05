# TodayOneCut iOS

안드로이드 앱을 iOS로 포팅한 버전입니다.

## 🚀 빠른 시작

### 1. Xcode 프로젝트 생성

`PROJECT_SETUP_GUIDE.md` 파일을 참고하여 Xcode 프로젝트를 생성하세요.

### 2. 파일 추가

이 폴더에 있는 모든 Swift 파일들을 Xcode 프로젝트에 추가하세요.

### 3. Core Data 모델 설정

Xcode에서 `TodayOneCut.xcdatamodeld` 파일을 열고 다음 엔티티들을 추가하세요:

- **RecordEntity**: 기록 엔티티
- **AppSettingsEntity**: 앱 설정 엔티티

자세한 속성은 `PROJECT_SETUP_GUIDE.md`를 참고하세요.

### 4. 빌드 및 실행

⌘B로 빌드하고, ⌘R로 실행하세요.

## 📁 프로젝트 구조

```
TodayOneCut/
├── App/                    # 앱 진입점
├── Domain/                 # 도메인 레이어
│   ├── Models/            # 도메인 모델
│   ├── Repositories/      # Repository 프로토콜
│   └── UseCases/          # Use Cases
├── Data/                   # 데이터 레이어
│   ├── Database/          # Core Data
│   ├── Repositories/      # Repository 구현체
│   └── Local/             # 파일 관리
├── Presentation/          # 프레젠테이션 레이어
│   ├── Views/             # SwiftUI Views
│   ├── Components/        # 재사용 컴포넌트
│   └── Navigation/        # 네비게이션
└── Utils/                 # 유틸리티
```

## 📚 문서

- `IOS_PORTING_STRATEGY.md`: 포팅 전략 상세 문서
- `PROJECT_SETUP_GUIDE.md`: 프로젝트 설정 가이드

## ⚠️ 현재 상태

### 완료된 작업
- ✅ 프로젝트 기본 구조
- ✅ Domain Layer (Models, Repositories, UseCases)
- ✅ Data Layer (Core Data Stack, Repository 구현)
- ✅ 기본 View 및 ViewModel

### 진행 중
- 🚧 Core Data 엔티티 정의 (Xcode에서 수동 설정 필요)
- 🚧 네비게이션 연결
- 🚧 DI 설정

### 다음 단계
1. Core Data 모델 완성
2. DI 컨테이너 설정
3. 네비게이션 구현
4. 나머지 화면 구현

## 🔧 기술 스택

- **언어**: Swift 5.9+
- **UI**: SwiftUI
- **데이터베이스**: Core Data
- **아키텍처**: Clean Architecture + MVVM
- **비동기**: async/await

## 📝 참고

안드로이드 버전과 동일한 기능을 제공하지만, 완전히 독립적인 코드베이스입니다.

