# 오늘의 한 컷 (Today One Cut)

<div align="center">

**하루에 딱 하나, 오늘 제일 기억나는 장면만 남기는 앱**

[![iOS](https://img.shields.io/badge/Platform-iOS-blue.svg)](https://developer.apple.com/ios/)
[![Swift](https://img.shields.io/badge/Language-Swift-orange.svg)](https://swift.org)
[![SwiftUI](https://img.shields.io/badge/UI-SwiftUI-blue.svg)](https://developer.apple.com/xcode/swiftui/)
[![License](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

</div>

---

## 📱 프로젝트 소개

**오늘의 한 컷**은 하루에 하나의 장면만 기록할 수 있는 미니멀한 기록 앱입니다.

### 왜 만들었나요?

- 일기는 부담스럽고
- 사진은 너무 많고
- 기록은 하고 싶지만 뭘 써야 할지 모를 때

**하루에 하나면 충분합니다.**

---

## ✨ 핵심 기능

### 🎯 하루에 하나만

- 같은 날짜에는 단 하나의 기록만 생성 가능
- 과거/미래 날짜 기록 불가
- 오직 오늘만 기록 가능
- 당일 수정 가능 (1회 제한)

### 📸 사진 및 텍스트

- 사진 1장 첨부
- 텍스트 기록
- 사진과 텍스트 동시 기록 가능

### 📍 위치 정보 (선택)

- 현재 위치 자동 기록
- 설정에서 ON/OFF 가능
- 위치 이름 자동 변환 (역지오코딩)

### 📅 기록 보기

- 날짜별 목록 조회
- 달력 뷰로 기록 확인
- 검색 기능 (제목, 내용 검색)
- 기록 상세 보기

### 🎨 테마 설정

- 라이트/다크 모드
- 시스템 테마 따라가기

### 🛡️ 데이터 보안

- 로컬 저장 (클라우드 동기화 없음)
- 앱 전용 내부 저장소 사용
- 모든 데이터는 기기에 안전하게 저장

---

## 🎨 주요 화면

- **홈 화면**: 오늘의 기록 확인 및 생성
- **기록 작성**: 사진 첨부 및 텍스트 입력
- **기록 목록**: 모든 기록 조회 및 검색
- **기록 상세**: 기록 상세 정보 및 수정/삭제
- **달력**: 날짜별 기록 확인
- **설정**: 테마, 위치 정보 설정
- **온보딩**: 첫 실행 시 앱 소개

---

## 🏗️ 기술 스택

### Frontend

- **Language**: Swift 5.9+
- **UI**: SwiftUI
- **Architecture**: Clean Architecture + MVVM
- **DI**: Swinject 또는 Factory
- **Min iOS**: iOS 16.0+
- **Target iOS**: iOS 17.0+

### Data

- **Local DB**: Core Data
- **Image Loading**: SwiftUI AsyncImage / Kingfisher (선택)
- **Location**: Core Location

### Libraries

- ✅ SwiftUI
- ✅ Core Data
- ✅ Core Location
- ✅ async/await
- ✅ Combine
- ✅ Swinject (DI, 선택)
- ✅ Kingfisher (이미지 로딩, 선택)

---

## 🚀 빠른 시작

### 필요 환경

- Xcode 15.0 이상
- macOS 13.0 이상
- iOS 16.0 이상 시뮬레이터 또는 디바이스

### 프로젝트 실행

```bash
# 1. 저장소 클론
git clone https://github.com/yourusername/todayonecut-ios.git

# 2. Xcode에서 프로젝트 열기
# Finder에서 TodayOneCut.xcodeproj 더블클릭
# 또는 Xcode > File > Open > TodayOneCut.xcodeproj 선택

# 3. 프로젝트 설정
# PROJECT_SETUP_GUIDE.md 파일 참고

# 4. Core Data 모델 설정
# Xcode에서 TodayOneCut.xcdatamodeld 파일 열고 엔티티 추가
# PROJECT_SETUP_GUIDE.md 참고

# 5. 앱 실행
# ⌘R 또는 Product > Run
```

### 빌드

```bash
# Xcode에서 빌드
# ⌘B 또는 Product > Build

# Archive 생성 (배포용)
# Product > Archive

# 결과물
# DerivedData 폴더 또는 Xcode Organizer에서 확인
```

---

## 📁 프로젝트 구조

```
TodayOneCut/
├── App/
│   └── TodayOneCutApp.swift              # @main 앱 진입점
├── Presentation/                          # Presentation Layer
│   ├── Views/
│   │   ├── Home/
│   │   ├── Create/
│   │   ├── Edit/
│   │   ├── Detail/
│   │   ├── List/
│   │   ├── Calendar/
│   │   ├── Settings/
│   │   └── Onboarding/
│   ├── Components/
│   │   ├── RecordCard.swift
│   │   ├── EmptyState.swift
│   │   └── LoadingView.swift
│   ├── Navigation/
│   │   └── AppNavigation.swift
│   └── Theme/
│       ├── Color.swift
│       └── Theme.swift
├── Domain/                                # Domain Layer
│   ├── Models/
│   │   ├── Record.swift
│   │   ├── RecordType.swift
│   │   ├── Location.swift
│   │   └── AppSettings.swift
│   ├── Repositories/
│   │   ├── RecordRepository.swift         # Protocol
│   │   ├── SettingsRepository.swift
│   │   └── FileRepository.swift
│   └── UseCases/
│       ├── Record/
│       ├── Validation/
│       └── Settings/
├── Data/                                  # Data Layer
│   ├── Repositories/
│   │   ├── RecordRepositoryImpl.swift
│   │   ├── SettingsRepositoryImpl.swift
│   │   └── FileRepositoryImpl.swift
│   ├── Database/
│   │   ├── CoreDataStack.swift
│   │   ├── Entities/
│   │   └── Mappers/
│   └── Local/
│       └── FileManager.swift
├── DI/                                    # Dependency Injection
│   └── AppContainer.swift
├── Utils/
│   ├── Result.swift
│   ├── Extensions.swift
│   └── Constants.swift
├── TodayOneCutTests/                      # Unit Tests
├── TodayOneCutUITests/                    # UI Tests
└── TodayOneCut.xcodeproj/
```

---

## 📖 문서

### 개발 문서

- [📋 iOS 포팅 전략](./IOS_PORTING_STRATEGY.md) - 안드로이드에서 iOS로 포팅 전략
- [🔧 프로젝트 설정 가이드](./PROJECT_SETUP_GUIDE.md) - Xcode 프로젝트 설정 및 Core Data 설정
- [📱 iOS 포팅 가이드](./IOS_PORTING.md) - 빠른 시작 가이드

---

## 📊 프로젝트 상태

**현재 상태**: 🟡 포팅 진행 중

### 완료된 작업

- ✅ 프로젝트 기본 구조
- ✅ Domain Layer (Models, Repositories, UseCases)
- ✅ Data Layer (Core Data Stack, Repository 구현)
- ✅ 기본 View 및 ViewModel

### 진행 중

- 🚧 Core Data 엔티티 정의 (Xcode에서 수동 설정 필요)
- 🚧 네비게이션 연결
- 🚧 DI 설정
- 🚧 나머지 화면 구현

### 다음 단계

1. Core Data 모델 완성
2. DI 컨테이너 설정
3. 네비게이션 구현
4. 나머지 화면 구현
5. 테스트 작성
6. App Store 배포 준비

---

## 🧪 테스트

```bash
# Xcode에서 테스트 실행
# ⌘U 또는 Product > Test

# 특정 테스트만 실행
# 테스트 파일에서 개별 테스트 실행
```

---

## 📦 배포

### App Store 배포 준비

1. **App Store Connect 설정**
   - 앱 정보 입력
   - 스크린샷 준비
   - Privacy Policy 작성

2. **Archive 생성**
   ```bash
   # Xcode에서
   # Product > Archive
   ```

3. **Upload to App Store**
   - Xcode Organizer에서 "Distribute App" 선택
   - App Store Connect로 업로드

4. **TestFlight 배포** (선택)
   - App Store Connect에서 TestFlight 설정
   - 베타 테스터 초대

### 로컬 설치 (개발용)

```bash
# Xcode에서 직접 실행
# ⌘R 또는 Product > Run

# 또는 시뮬레이터에서
# Window > Devices and Simulators에서 시뮬레이터 선택 후 실행
```

---

## 📄 라이선스

이 프로젝트는 MIT 라이선스를 따릅니다. 자세한 내용은 [LICENSE](LICENSE) 파일을 참조하세요.

---

## 👤 개발자

- **이메일**: sus3456@naver.com
- **GitHub**: [@sin-jun-woo](https://github.com/sin-jun-woo)

---

## 🙏 감사의 말

이 프로젝트는 다음 오픈소스 프로젝트들의 도움을 받았습니다:

- [SwiftUI](https://developer.apple.com/xcode/swiftui/)
- [Core Data](https://developer.apple.com/documentation/coredata)
- [Core Location](https://developer.apple.com/documentation/corelocation)
- [Swinject](https://github.com/Swinject/Swinject) (선택)
- [Kingfisher](https://github.com/onevcat/Kingfisher) (선택)

---

## 💡 영감

> "기억은 많이 남길 필요가 없다. 하나면 충분하다."

매일 하나씩, 365일이면 365개의 장면.
그것만으로도 1년을 충분히 기억할 수 있습니다.

---

## 🔄 안드로이드 버전

이 프로젝트는 안드로이드 버전을 iOS로 포팅한 버전입니다.
- **안드로이드 버전**: [TodayOneCut Android](https://github.com/yourusername/todayonecut)
- **기능**: 안드로이드 버전과 동일한 기능 제공
- **코드베이스**: 완전히 독립적인 네이티브 코드

---

<div align="center">

**Made with ❤️ and ☕ in Korea**

⭐ 이 프로젝트가 마음에 드신다면 스타를 눌러주세요!

</div>

