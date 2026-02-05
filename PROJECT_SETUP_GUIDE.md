# iOS 프로젝트 설정 가이드

## 1단계: Xcode 프로젝트 생성

1. Xcode 실행
2. `File > New > Project...` 선택
3. **iOS > App** 선택
4. 다음 정보 입력:
   - **Product Name**: `TodayOneCut`
   - **Team**: 본인의 개발자 계정
   - **Organization Identifier**: `com.todayonecut` (또는 본인 도메인)
   - **Interface**: `SwiftUI`
   - **Language**: `Swift`
   - **Storage**: `Core Data` ✅ (체크!)
   - **Include Tests**: ✅ (체크!)

5. 저장 위치: `/Users/shin-junwoo/Side Project/TodayOneCut-ios/` 선택
6. `Create` 클릭

## 2단계: 프로젝트 구조 생성

Xcode에서 다음 폴더 구조를 생성하세요:

```
TodayOneCut/
├── App/
├── Presentation/
│   ├── Views/
│   ├── Components/
│   ├── Navigation/
│   └── Theme/
├── Domain/
│   ├── Models/
│   ├── Repositories/
│   └── UseCases/
├── Data/
│   ├── Repositories/
│   ├── Database/
│   └── Local/
├── DI/
└── Utils/
```

**방법**:
1. Xcode 왼쪽 프로젝트 네비게이터에서 `TodayOneCut` 그룹 우클릭
2. `New Group` 선택
3. 폴더명 입력
4. 반복

## 3단계: 파일 추가

이 가이드와 함께 제공된 모든 Swift 파일들을 Xcode 프로젝트에 추가하세요:

1. 각 파일을 해당하는 그룹으로 드래그 앤 드롭
2. `Copy items if needed` 체크 해제 (이미 올바른 위치에 있음)
3. `Add to targets: TodayOneCut` 체크

## 4단계: Core Data 모델 설정

1. `TodayOneCut.xcdatamodeld` 파일 열기
2. 아래 엔티티들 추가 (다음 섹션 참고)

## 5단계: Info.plist 설정

위치 권한을 위해 `Info.plist`에 다음 추가:

```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>오늘의 장면에 위치 정보를 저장하기 위해 위치 권한이 필요합니다.</string>
<key>NSPhotoLibraryUsageDescription</key>
<string>사진을 선택하기 위해 사진 라이브러리 접근 권한이 필요합니다.</string>
<key>NSCameraUsageDescription</key>
<string>사진을 촬영하기 위해 카메라 권한이 필요합니다.</string>
```

## 6단계: 의존성 추가 (선택)

필요시 Swift Package Manager로 추가:

1. `File > Add Package Dependencies...`
2. 다음 패키지 추가 (선택사항):
   - Swinject: `https://github.com/Swinject/Swinject.git`

## 7단계: 빌드 및 실행

1. `Product > Clean Build Folder` (⇧⌘K)
2. `Product > Build` (⌘B)
3. 시뮬레이터 선택 후 실행 (⌘R)

---

## Core Data 엔티티 정의

### RecordEntity

- **Entity Name**: `RecordEntity`
- **Attributes**:
  - `id`: Integer 64 (Optional: NO)
  - `recordDate`: String (Optional: NO)
  - `recordType`: String (Optional: NO)
  - `contentText`: String (Optional: YES)
  - `photoPath`: String (Optional: YES)
  - `latitude`: Double (Optional: YES)
  - `longitude`: Double (Optional: YES)
  - `locationName`: String (Optional: YES)
  - `createdAt`: Date (Optional: NO)
  - `updatedAt`: Date (Optional: YES)
  - `updateCount`: Integer 32 (Optional: NO, Default: 0)

### AppSettingsEntity

- **Entity Name**: `AppSettingsEntity`
- **Attributes**:
  - `id`: Integer 32 (Optional: NO, Default: 1)
  - `enableLocation`: Boolean (Optional: NO, Default: NO)
  - `themeMode`: String (Optional: NO, Default: "SYSTEM")
  - `firstLaunch`: Boolean (Optional: NO, Default: YES)
  - `totalRecords`: Integer 32 (Optional: NO, Default: 0)
  - `createdAt`: Date (Optional: NO)
  - `updatedAt`: Date (Optional: YES)

---

## 다음 단계

프로젝트가 생성되면 다음 순서로 개발:

1. ✅ Domain Models 구현
2. ✅ Core Data Stack 설정
3. ✅ Repository 구현
4. ✅ Use Cases 구현
5. ✅ ViewModels 구현
6. ✅ Views 구현
7. ✅ 네비게이션 연결

각 단계는 이미 준비된 파일들을 참고하세요!

