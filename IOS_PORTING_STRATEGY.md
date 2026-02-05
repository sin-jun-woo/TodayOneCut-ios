# iOS 포팅 전략서

## 📋 개요

안드로이드 네이티브 앱을 iOS 네이티브 앱으로 포팅하는 전략 문서입니다.

**원본 앱**: TodayOneCut (Android)
- Kotlin + Jetpack Compose
- Clean Architecture + MVVM
- Room (SQLite)
- Hilt (DI)

**목표**: 동일한 기능의 iOS 네이티브 앱 제작

---

## 🎯 포팅 전략

### 옵션 1: SwiftUI 네이티브 (추천) ⭐

**장점**:
- 네이티브 성능
- iOS 네이티브 UX
- App Store 배포 용이
- 장기 유지보수 용이

**단점**:
- 코드베이스 완전 분리 (안드로이드와 공유 불가)
- 개발 시간 소요

**기술 스택**:
- **언어**: Swift 5.9+
- **UI**: SwiftUI
- **아키텍처**: Clean Architecture + MVVM (동일)
- **데이터베이스**: Core Data 또는 SQLite.swift
- **DI**: Swinject 또는 Factory
- **비동기**: async/await + Combine
- **이미지**: SwiftUI AsyncImage + Kingfisher (선택)
- **위치**: Core Location

### 옵션 2: 크로스 플랫폼 (비추천)

**React Native / Flutter**:
- 기존 안드로이드 코드 재사용 불가 (Kotlin 네이티브)
- 완전히 새로 작성해야 함
- 네이티브 느낌 떨어짐

---

## 🏗️ 아키텍처 매핑

### 레이어 구조 (동일하게 유지)

```
┌─────────────────────────────────┐
│   Presentation Layer             │
│   (SwiftUI Views + ViewModels)   │
└─────────────┬─────────────────────┘
              │
┌─────────────▼─────────────────────┐
│   Domain Layer                    │
│   (Use Cases + Domain Models)     │
└─────────────┬─────────────────────┘
              │
┌─────────────▼─────────────────────┐
│   Data Layer                      │
│   (Repository + Data Sources)     │
└───────────────────────────────────┘
```

### 기술 스택 매핑

| 안드로이드 | iOS | 비고 |
|-----------|-----|------|
| Kotlin | Swift | 언어 |
| Jetpack Compose | SwiftUI | UI 프레임워크 |
| Room | Core Data / SQLite.swift | 로컬 DB |
| Hilt | Swinject / Factory | DI |
| Coroutines + Flow | async/await + Combine | 비동기 |
| Coil | AsyncImage / Kingfisher | 이미지 로딩 |
| Navigation Compose | NavigationStack (iOS 16+) | 네비게이션 |
| DataStore | UserDefaults / AppStorage | 설정 저장 |
| WorkManager | BackgroundTasks | 백그라운드 작업 |
| Google Play Services Location | Core Location | 위치 서비스 |

---

## 📦 프로젝트 구조

```
TodayOneCut-iOS/
├── TodayOneCut/
│   ├── App/
│   │   ├── TodayOneCutApp.swift          # @main 앱 진입점
│   │   └── AppDelegate.swift             # 필요시
│   │
│   ├── Presentation/                     # Presentation Layer
│   │   ├── Views/
│   │   │   ├── Home/
│   │   │   │   ├── HomeView.swift
│   │   │   │   └── HomeViewModel.swift
│   │   │   ├── Create/
│   │   │   │   ├── CreateRecordView.swift
│   │   │   │   └── CreateRecordViewModel.swift
│   │   │   ├── List/
│   │   │   ├── Detail/
│   │   │   ├── Calendar/
│   │   │   ├── Settings/
│   │   │   └── Onboarding/
│   │   ├── Components/
│   │   │   ├── RecordCard.swift
│   │   │   ├── EmptyState.swift
│   │   │   └── LoadingView.swift
│   │   ├── Navigation/
│   │   │   └── AppNavigation.swift
│   │   └── Theme/
│   │       ├── Color.swift
│   │       ├── Typography.swift
│   │       └── Theme.swift
│   │
│   ├── Domain/                           # Domain Layer
│   │   ├── Models/
│   │   │   ├── Record.swift
│   │   │   ├── RecordType.swift
│   │   │   ├── Location.swift
│   │   │   └── AppSettings.swift
│   │   ├── Repositories/
│   │   │   ├── RecordRepository.swift    # Protocol
│   │   │   ├── SettingsRepository.swift
│   │   │   └── FileRepository.swift
│   │   └── UseCases/
│   │       ├── Record/
│   │       │   ├── CreateRecordUseCase.swift
│   │       │   ├── GetTodayRecordUseCase.swift
│   │       │   ├── GetAllRecordsUseCase.swift
│   │       │   ├── UpdateRecordUseCase.swift
│   │       │   └── DeleteRecordUseCase.swift
│   │       ├── Validation/
│   │       │   ├── ValidateDailyLimitUseCase.swift
│   │       │   ├── ValidateUpdateLimitUseCase.swift
│   │       │   └── ValidateDateUseCase.swift
│   │       └── Settings/
│   │           ├── GetSettingsUseCase.swift
│   │           └── UpdateSettingsUseCase.swift
│   │
│   ├── Data/                              # Data Layer
│   │   ├── Repositories/
│   │   │   ├── RecordRepositoryImpl.swift
│   │   │   ├── SettingsRepositoryImpl.swift
│   │   │   └── FileRepositoryImpl.swift
│   │   ├── Database/
│   │   │   ├── CoreDataStack.swift        # 또는 SQLiteStack
│   │   │   ├── Entities/
│   │   │   │   ├── RecordEntity.swift
│   │   │   │   └── AppSettingsEntity.swift
│   │   │   └── Mappers/
│   │   │       ├── RecordMapper.swift
│   │   │       └── SettingsMapper.swift
│   │   └── Local/
│   │       └── FileManager.swift
│   │
│   ├── DI/                                # Dependency Injection
│   │   └── AppContainer.swift
│   │
│   └── Utils/
│       ├── Result.swift
│       ├── Extensions.swift
│       └── Constants.swift
│
├── TodayOneCutTests/                      # Unit Tests
├── TodayOneCutUITests/                     # UI Tests
└── TodayOneCut.xcodeproj/
```

---

## 🔄 주요 포팅 작업

### 1. 데이터베이스 포팅

#### 옵션 A: Core Data (추천)

**장점**:
- iOS 네이티브
- Xcode 통합 도구
- 자동 마이그레이션

**단점**:
- Room과 다른 API
- 학습 곡선

**구현**:
```swift
// CoreDataStack.swift
import CoreData

class CoreDataStack {
    static let shared = CoreDataStack()
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "TodayOneCut")
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Core Data error: \(error)")
            }
        }
        return container
    }()
    
    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
}
```

#### 옵션 B: SQLite.swift

**장점**:
- Room과 유사한 API
- 타입 안전성
- Swift 네이티브

**단점**:
- 서드파티 라이브러리
- 마이그레이션 직접 구현

**구현**:
```swift
import SQLite

class SQLiteStack {
    static let shared = SQLiteStack()
    private var db: Connection?
    
    init() {
        let path = NSSearchPathForDirectoriesInDomains(
            .documentDirectory, .userDomainMask, true
        ).first!
        db = try? Connection("\(path)/todayonecut.db")
    }
}
```

**결정**: Core Data 추천 (iOS 네이티브, 장기 유지보수 용이)

---

### 2. UI 포팅 (SwiftUI)

#### 화면별 포팅

**홈 화면**:
```swift
struct HomeView: View {
    @StateObject private var viewModel: HomeViewModel
    
    var body: some View {
        NavigationStack {
            VStack {
                if let record = viewModel.todayRecord {
                    TodayRecordCard(record: record)
                } else {
                    EmptyStateView(
                        message: "아직 오늘의 장면을 남기지 않았어요",
                        actionText: "오늘의 장면 남기기",
                        action: { viewModel.navigateToCreate() }
                    )
                }
                
                Spacer()
                
                Button("기록 목록 보기") {
                    viewModel.navigateToList()
                }
            }
            .navigationTitle("오늘의 한 컷")
        }
    }
}
```

**기록 작성 화면**:
```swift
struct CreateRecordView: View {
    @StateObject private var viewModel: CreateRecordViewModel
    @State private var showImagePicker = false
    
    var body: some View {
        Form {
            Section {
                if let image = viewModel.selectedImage {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                } else {
                    Button("사진 추가") {
                        showImagePicker = true
                    }
                }
            }
            
            Section("메모") {
                TextField("텍스트 입력", text: $viewModel.contentText, axis: .vertical)
                    .lineLimit(5...10)
            }
            
            Section {
                Toggle("위치 정보 자동 저장", isOn: $viewModel.enableLocation)
            }
        }
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(image: $viewModel.selectedImage)
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("저장") {
                    viewModel.saveRecord()
                }
            }
        }
    }
}
```

---

### 3. 비즈니스 로직 포팅

#### Use Case 예시

```swift
// CreateRecordUseCase.swift
class CreateRecordUseCase {
    private let recordRepository: RecordRepository
    private let fileRepository: FileRepository
    private let validateDailyLimit: ValidateDailyLimitUseCase
    private let validateDate: ValidateDateUseCase
    
    func execute(
        type: RecordType,
        contentText: String?,
        photoData: Data?,
        location: Location?
    ) async throws -> Record {
        let today = Date()
        
        // 검증
        try await validateDate.execute(date: today)
        try await validateDailyLimit.execute(date: today)
        
        // 사진 저장
        var photoPath: String? = nil
        if let photoData = photoData {
            photoPath = try await fileRepository.savePhoto(
                data: photoData,
                date: today
            )
        }
        
        // 기록 생성
        let record = Record(
            date: today,
            type: type,
            contentText: contentText,
            photoPath: photoPath,
            location: location,
            createdAt: Date()
        )
        
        return try await recordRepository.createRecord(record)
    }
}
```

---

### 4. 의존성 주입

#### Swinject 사용

```swift
// AppContainer.swift
import Swinject

class AppContainer {
    static let shared = AppContainer()
    let container = Container()
    
    init() {
        setupDependencies()
    }
    
    private func setupDependencies() {
        // Database
        container.register(CoreDataStack.self) { _ in
            CoreDataStack.shared
        }.inObjectScope(.container)
        
        // Repositories
        container.register(RecordRepository.self) { r in
            RecordRepositoryImpl(
                context: r.resolve(CoreDataStack.self)!.viewContext
            )
        }.inObjectScope(.container)
        
        // Use Cases
        container.register(CreateRecordUseCase.self) { r in
            CreateRecordUseCase(
                recordRepository: r.resolve(RecordRepository.self)!,
                fileRepository: r.resolve(FileRepository.self)!,
                validateDailyLimit: r.resolve(ValidateDailyLimitUseCase.self)!,
                validateDate: r.resolve(ValidateDateUseCase.self)!
            )
        }
        
        // ViewModels
        container.register(HomeViewModel.self) { r in
            HomeViewModel(
                getTodayRecord: r.resolve(GetTodayRecordUseCase.self)!,
                checkTodayExists: r.resolve(CheckTodayRecordExistsUseCase.self)!
            )
        }
    }
}
```

---

### 5. 네비게이션

#### NavigationStack (iOS 16+)

```swift
// AppNavigation.swift
enum AppRoute: Hashable {
    case home
    case create
    case list
    case detail(recordId: Int64)
    case calendar
    case settings
}

struct AppNavigation: View {
    @State private var navigationPath = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
            HomeView()
                .navigationDestination(for: AppRoute.self) { route in
                    switch route {
                    case .home:
                        HomeView()
                    case .create:
                        CreateRecordView()
                    case .list:
                        RecordListView()
                    case .detail(let id):
                        RecordDetailView(recordId: id)
                    case .calendar:
                        CalendarView()
                    case .settings:
                        SettingsView()
                    }
                }
        }
    }
}
```

---

## 🔧 주요 차이점 및 주의사항

### 1. 날짜/시간 처리

**안드로이드**: `java.time.LocalDate`, `java.time.Instant`
**iOS**: `Date`, `Calendar`, `DateFormatter`

```swift
// Date Extension
extension Date {
    var startOfDay: Date {
        Calendar.current.startOfDay(for: self)
    }
    
    var isToday: Bool {
        Calendar.current.isDateInToday(self)
    }
    
    func toLocalDateString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: self)
    }
}
```

### 2. 파일 저장

**안드로이드**: `Context.filesDir`
**iOS**: `FileManager.default.urls(for: .documentDirectory, ...)`

```swift
class FileRepositoryImpl: FileRepository {
    private let fileManager = FileManager.default
    
    func savePhoto(data: Data, date: Date) async throws -> String {
        let documentsURL = fileManager.urls(
            for: .documentDirectory,
            in: .userDomainMask
        )[0]
        
        let photosURL = documentsURL.appendingPathComponent("photos")
        try fileManager.createDirectory(
            at: photosURL,
            withIntermediateDirectories: true
        )
        
        let fileName = date.toLocalDateString() + ".jpg"
        let fileURL = photosURL.appendingPathComponent(fileName)
        
        try data.write(to: fileURL)
        return fileURL.path
    }
}
```

### 3. 위치 서비스

**안드로이드**: Google Play Services Location
**iOS**: Core Location

```swift
import CoreLocation

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    @Published var currentLocation: CLLocation?
    
    func requestLocation() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        locationManager.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = locations.first
    }
}
```

### 4. 이미지 처리

**안드로이드**: Coil
**iOS**: SwiftUI AsyncImage 또는 Kingfisher

```swift
// AsyncImage 사용
AsyncImage(url: URL(fileURLWithPath: record.photoPath)) { image in
    image
        .resizable()
        .aspectRatio(contentMode: .fit)
} placeholder: {
    ProgressView()
}
```

### 5. 비동기 처리

**안드로이드**: Coroutines + Flow
**iOS**: async/await + Combine

```swift
// ViewModel 예시
class HomeViewModel: ObservableObject {
    @Published var todayRecord: Record?
    @Published var isLoading = false
    
    private let getTodayRecord: GetTodayRecordUseCase
    
    func loadTodayRecord() {
        Task { @MainActor in
            isLoading = true
            defer { isLoading = false }
            
            do {
                todayRecord = try await getTodayRecord.execute()
            } catch {
                // 에러 처리
            }
        }
    }
}
```

---

## 📱 화면별 포팅 체크리스트

### ✅ Phase 1: 핵심 기능
- [ ] 프로젝트 초기 설정 (Xcode 프로젝트 생성)
- [ ] Core Data 모델 정의
- [ ] Repository 인터페이스 정의
- [ ] Use Case 구현
- [ ] 홈 화면
- [ ] 기록 작성 화면
- [ ] 기록 목록 화면
- [ ] 기록 상세 화면

### ✅ Phase 2: 추가 기능
- [ ] 달력 화면
- [ ] 검색 기능
- [ ] 설정 화면
- [ ] 온보딩 화면

### ✅ Phase 3: 최적화
- [ ] 이미지 압축
- [ ] 페이징
- [ ] 에러 처리
- [ ] 테스트 작성

---

## 🚀 개발 순서

### 1주차: 프로젝트 설정
1. Xcode 프로젝트 생성
2. Core Data 모델 설계
3. 프로젝트 구조 생성
4. DI 설정

### 2주차: Data Layer
1. Core Data Stack 구현
2. Repository 구현
3. Mapper 구현
4. FileRepository 구현

### 3주차: Domain Layer
1. Domain Models 정의
2. Use Cases 구현
3. Validation 로직 구현

### 4주차: Presentation Layer (1)
1. 홈 화면
2. 기록 작성 화면
3. 기본 네비게이션

### 5주차: Presentation Layer (2)
1. 기록 목록 화면
2. 기록 상세 화면
3. 수정/삭제 기능

### 6주차: 추가 기능
1. 달력 화면
2. 검색 기능
3. 설정 화면

### 7주차: 최적화 및 테스트
1. 이미지 최적화
2. 성능 튜닝
3. Unit Test 작성
4. UI Test 작성

### 8주차: 배포 준비
1. App Store Connect 설정
2. 아이콘, 스플래시 화면
3. Privacy Policy
4. TestFlight 배포

---

## 📚 필요한 iOS 지식

### 필수
- Swift 기본 문법
- SwiftUI 기본
- async/await
- Combine 기초
- Core Data 기초
- Core Location 기초

### 권장
- MVVM 패턴
- Clean Architecture
- 의존성 주입
- Unit Testing
- UI Testing

---

## 🔗 참고 자료

### 공식 문서
- [SwiftUI](https://developer.apple.com/xcode/swiftui/)
- [Core Data](https://developer.apple.com/documentation/coredata)
- [Core Location](https://developer.apple.com/documentation/corelocation)
- [async/await](https://docs.swift.org/swift-book/LanguageGuide/Concurrency.html)

### 라이브러리
- [Swinject](https://github.com/Swinject/Swinject) - DI
- [Kingfisher](https://github.com/onevcat/Kingfisher) - 이미지 로딩 (선택)
- [SQLite.swift](https://github.com/stephencelis/SQLite.swift) - SQLite (Core Data 대안)

---

## ⚠️ 주의사항

1. **데이터 마이그레이션**: 안드로이드와 iOS 간 데이터 공유 불가 (로컬 저장만)
2. **권한 처리**: iOS는 Info.plist에 권한 설명 필수
3. **백그라운드 작업**: iOS는 제한적 (BackgroundTasks 사용)
4. **파일 시스템**: iOS는 샌드박스 환경
5. **앱 생명주기**: iOS와 안드로이드 다름

---

## 🎯 최종 목표

- [ ] 안드로이드와 동일한 기능 구현
- [ ] iOS 네이티브 UX 제공
- [ ] App Store 출시
- [ ] 유지보수 가능한 코드베이스

---

**작성일**: 2025-01-XX
**작성자**: 개발팀

