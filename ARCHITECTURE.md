# 아키텍처 설계

## 🏛️ 전체 아키텍처 개요

**Clean Architecture + MVVM 패턴**을 기반으로 한 계층 구조

```
┌─────────────────────────────────────────┐
│         Presentation Layer              │
│   (UI / SwiftUI Views / ViewModels)     │
└─────────────┬───────────────────────────┘
              │
┌─────────────▼───────────────────────────┐
│         Domain Layer                    │
│   (Use Cases / Domain Models)           │
└─────────────┬───────────────────────────┘
              │
┌─────────────▼───────────────────────────┐
│         Data Layer                      │
│   (Repository / Data Sources)           │
└─────────────────────────────────────────┘
```

---

## 📦 프로젝트 구조

```
TodayOneCut/
│
├── App/                           # 앱 진입점
│   └── TodayOneCutApp.swift      # @main
│
├── Presentation/                  # Presentation Layer
│   ├── Views/
│   │   ├── Home/
│   │   │   ├── HomeView.swift
│   │   │   ├── HomeViewModel.swift
│   │   │   └── HomeUiState.swift
│   │   ├── Create/
│   │   │   ├── CreateRecordView.swift
│   │   │   ├── CreateRecordViewModel.swift
│   │   │   └── CreateRecordUiState.swift
│   │   ├── Edit/
│   │   ├── List/
│   │   ├── Detail/
│   │   ├── Calendar/
│   │   ├── Settings/
│   │   └── Onboarding/
│   ├── Components/                # Reusable Components
│   │   ├── RecordCard.swift
│   │   ├── EmptyState.swift
│   │   └── LoadingView.swift
│   ├── Navigation/
│   │   └── AppNavigation.swift
│   └── Theme/
│       ├── Color.swift
│       └── Theme.swift
│
├── Domain/                        # Domain Layer
│   ├── Models/
│   │   ├── Record.swift
│   │   ├── RecordType.swift
│   │   ├── AppSettings.swift
│   │   └── Location.swift
│   ├── Repositories/              # Repository Protocols
│   │   ├── RecordRepository.swift
│   │   ├── SettingsRepository.swift
│   │   └── FileRepository.swift
│   └── UseCases/
│       ├── Record/
│       │   ├── CreateRecordUseCase.swift
│       │   ├── GetTodayRecordUseCase.swift
│       │   ├── GetAllRecordsUseCase.swift
│       │   ├── UpdateRecordUseCase.swift
│       │   ├── DeleteRecordUseCase.swift
│       │   └── SearchRecordsUseCase.swift
│       ├── Validation/
│       │   ├── ValidateDailyLimitUseCase.swift
│       │   ├── ValidateUpdateLimitUseCase.swift
│       │   └── ValidateDateUseCase.swift
│       └── Settings/
│           ├── GetSettingsUseCase.swift
│           └── UpdateSettingsUseCase.swift
│
├── Data/                          # Data Layer
│   ├── Repositories/
│   │   ├── RecordRepositoryImpl.swift
│   │   ├── SettingsRepositoryImpl.swift
│   │   └── FileRepositoryImpl.swift
│   ├── Database/
│   │   ├── CoreDataStack.swift
│   │   ├── Entities/
│   │   │   ├── RecordEntity+CoreDataClass.swift
│   │   │   └── AppSettingsEntity+CoreDataClass.swift
│   │   └── Mappers/
│   │       ├── RecordMapper.swift
│   │       └── SettingsMapper.swift
│   └── Local/
│       └── FileManager.swift
│
├── DI/                            # Dependency Injection
│   └── AppContainer.swift
│
└── Utils/                         # Global Utilities
    ├── Result.swift               # Result type
    ├── Constants.swift
    └── Extensions.swift
```

---

## 🎯 각 레이어의 역할

### 1. Presentation Layer (UI)

**책임**
- 사용자 인터페이스 렌더링
- 사용자 입력 처리
- ViewModel을 통한 비즈니스 로직 호출
- UI 상태 관찰 및 표시

**구성요소**
- **View (SwiftUI)**: UI 렌더링
- **ViewModel**: UI 상태 관리 및 Use Case 호출
- **UiState**: 화면 상태를 나타내는 구조체

**예시**
```swift
// HomeUiState.swift
struct HomeUiState {
    var todayRecord: Record? = nil
    var canCreateToday: Bool = true
    var isLoading: Bool = false
    var error: String? = nil
}

// HomeViewModel.swift
@MainActor
class HomeViewModel: ObservableObject {
    @Published var uiState = HomeUiState()
    
    private let getTodayRecordUseCase: GetTodayRecordUseCase
    private let checkTodayRecordExistsUseCase: CheckTodayRecordExistsUseCase
    
    init(
        getTodayRecordUseCase: GetTodayRecordUseCase,
        checkTodayRecordExistsUseCase: CheckTodayRecordExistsUseCase
    ) {
        self.getTodayRecordUseCase = getTodayRecordUseCase
        self.checkTodayRecordExistsUseCase = checkTodayRecordExistsUseCase
        loadTodayRecord()
    }
    
    private func loadTodayRecord() {
        Task {
            uiState.isLoading = true
            
            let today = Date()
            let exists = try? await checkTodayRecordExistsUseCase.execute(date: today)
            let record = exists == true ? try? await getTodayRecordUseCase.execute() : nil
            
            uiState.todayRecord = record
            uiState.canCreateToday = !(exists ?? false)
            uiState.isLoading = false
        }
    }
}
```

---

### 2. Domain Layer (비즈니스 로직)

**책임**
- 핵심 비즈니스 규칙 정의
- Use Case를 통한 기능 단위 캡슐화
- 플랫폼 독립적인 순수 Swift 코드

**구성요소**
- **Model**: 도메인 모델 (엔티티와 독립적)
- **Repository Protocol**: 데이터 접근 추상화
- **Use Case**: 단일 비즈니스 기능

**예시**
```swift
// Domain Model
struct Record: Identifiable {
    let id: Int64
    let date: Date
    let type: RecordType
    var contentText: String?
    var photoPath: String?
    var location: Location?
    let createdAt: Date
    var updatedAt: Date?
    var updateCount: Int = 0
    
    var canUpdate: Bool {
        updateCount < 1 && Calendar.current.isDateInToday(date)
    }
}

// Use Case
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
        
        // 비즈니스 규칙 검증
        try validateDate.execute(date: today)
        try await validateDailyLimit.execute(date: today)
        
        // 사진 저장
        var photoPath: String? = nil
        if let photoData = photoData {
            photoPath = try await fileRepository.savePhoto(photoData, date: today)
        }
        
        // 레코드 생성
        let record = Record(
            id: 0, // DB에서 생성
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

### 3. Data Layer (데이터 관리)

**책임**
- 데이터 저장/조회
- Core Data 및 파일 시스템 관리
- 도메인 모델 ↔ 엔티티 변환

**구성요소**
- **Repository Implementation**: Repository 프로토콜 구현
- **Core Data Stack**: Core Data 관리
- **Entity**: Core Data 엔티티
- **Mapper**: Entity ↔ Domain Model 변환

**예시**
```swift
// Repository Implementation
class RecordRepositoryImpl: RecordRepository {
    private let coreDataStack: CoreDataStack
    private let recordMapper: RecordMapper
    
    func createRecord(_ record: Record) async throws -> Record {
        let context = coreDataStack.viewContext
        
        // 중복 체크
        let exists = try await recordExistsForDate(record.date)
        if exists {
            throw TodayOneCutError.dailyLimitExceeded()
        }
        
        let entity = recordMapper.toEntity(record, context: context)
        
        try context.save()
        
        return recordMapper.toDomain(entity)
    }
    
    func getAllRecords() -> AnyPublisher<[Record], Never> {
        // Core Data NotificationCenter를 Combine으로 변환
        // ...
    }
}

// Mapper
class RecordMapper {
    func toDomain(_ entity: RecordEntity) -> Record {
        return Record(
            id: entity.id,
            date: entity.recordDate.toDate() ?? Date(),
            type: RecordType(rawValue: entity.recordType ?? "TEXT") ?? .text,
            contentText: entity.contentText,
            photoPath: entity.photoPath,
            location: entity.latitude.map { lat in
                entity.longitude.map { lon in
                    Location(
                        latitude: lat,
                        longitude: lon,
                        name: entity.locationName
                    )
                }
            } ?? nil,
            createdAt: entity.createdAt ?? Date(),
            updatedAt: entity.updatedAt,
            updateCount: Int(entity.updateCount)
        )
    }
    
    func toEntity(_ record: Record, context: NSManagedObjectContext) -> RecordEntity {
        let entity = RecordEntity(context: context)
        entity.id = record.id
        entity.recordDate = record.date.toLocalDateString()
        entity.recordType = record.type.rawValue
        entity.contentText = record.contentText
        entity.photoPath = record.photoPath
        entity.latitude = record.location?.latitude ?? 0
        entity.longitude = record.location?.longitude ?? 0
        entity.locationName = record.location?.name
        entity.createdAt = record.createdAt
        entity.updatedAt = record.updatedAt
        entity.updateCount = Int32(record.updateCount)
        return entity
    }
}
```

---

## 🔄 데이터 흐름

### 기록 생성 플로우

```
[CreateRecordView]
    ↓ 사용자 입력
[CreateRecordViewModel]
    ↓ execute
[CreateRecordUseCase]
    ↓ validation + business logic
[RecordRepository]
    ↓ toEntity
[Core Data]
    ↓ NotificationCenter
[RecordRepository]
    ↓ toDomain
[ViewModel]
    ↓ @Published
[UI 자동 업데이트]
```

---

## 🧩 의존성 주입 (Swinject)

### 컨테이너 구성

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
        // Core Data Stack
        container.register(CoreDataStack.self) { _ in
            CoreDataStack.shared
        }.inObjectScope(.container)
        
        // Mappers
        container.register(RecordMapper.self) { _ in
            RecordMapper()
        }
        
        container.register(SettingsMapper.self) { _ in
            SettingsMapper()
        }
        
        // Repositories
        container.register(RecordRepository.self) { r in
            RecordRepositoryImpl(
                coreDataStack: r.resolve(CoreDataStack.self)!,
                recordMapper: r.resolve(RecordMapper.self)!
            )
        }.inObjectScope(.container)
        
        container.register(SettingsRepository.self) { r in
            SettingsRepositoryImpl(
                coreDataStack: r.resolve(CoreDataStack.self)!,
                settingsMapper: r.resolve(SettingsMapper.self)!
            )
        }.inObjectScope(.container)
        
        container.register(FileRepository.self) { _ in
            FileRepositoryImpl()
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
                getTodayRecordUseCase: r.resolve(GetTodayRecordUseCase.self)!,
                checkTodayRecordExistsUseCase: r.resolve(CheckTodayRecordExistsUseCase.self)!
            )
        }
    }
}
```

---

## 🔒 핵심 비즈니스 규칙 구현

### 1. 하루 1개 제한

```swift
class ValidateDailyLimitUseCase {
    private let recordRepository: RecordRepository
    
    func execute(date: Date) async throws {
        let exists = try await recordRepository.recordExistsForDate(date)
        if exists {
            throw TodayOneCutError.dailyLimitExceeded()
        }
    }
}
```

### 2. 수정 1회 제한

```swift
class ValidateUpdateLimitUseCase {
    func execute(record: Record) throws {
        if record.updateCount >= 1 {
            throw TodayOneCutError.updateLimitExceeded()
        }
        
        if !Calendar.current.isDateInToday(record.date) {
            throw TodayOneCutError.invalidDate(message: "당일 기록만 수정할 수 있습니다")
        }
    }
}
```

### 3. 날짜 검증

```swift
class ValidateDateUseCase {
    func execute(date: Date) throws {
        let today = Date()
        let calendar = Calendar.current
        
        if calendar.compare(date, to: today, toGranularity: .day) == .orderedDescending {
            throw TodayOneCutError.invalidDate(message: "미래 날짜는 기록할 수 없습니다")
        }
        
        if calendar.compare(date, to: today, toGranularity: .day) == .orderedAscending {
            throw TodayOneCutError.invalidDate(message: "과거 날짜는 기록할 수 없습니다")
        }
    }
}
```

---

## 🎨 UI 상태 관리

### UiState 패턴

```swift
enum UiState<T> {
    case loading
    case success(T)
    case error(String)
}

// 사용 예시
struct RecordListView: View {
    @StateObject private var viewModel: RecordListViewModel
    
    var body: some View {
        switch viewModel.uiState {
        case .loading:
            LoadingView()
        case .success(let records):
            RecordList(records: records)
        case .error(let message):
            ErrorView(message: message)
        }
    }
}
```

---

## 🛡️ 에러 처리

### Result 타입 사용

```swift
enum Result<Success, Failure: Error> {
    case success(Success)
    case failure(Failure)
    
    func onSuccess(_ action: (Success) -> Void) -> Result<Success, Failure> {
        if case .success(let value) = self {
            action(value)
        }
        return self
    }
    
    func onFailure(_ action: (Failure) -> Void) -> Result<Success, Failure> {
        if case .failure(let error) = self {
            action(error)
        }
        return self
    }
}

// 커스텀 예외
enum TodayOneCutError: LocalizedError {
    case dailyLimitExceeded(message: String = "하루에 하나만 기록할 수 있습니다")
    case updateLimitExceeded(message: String = "수정은 1회만 가능합니다")
    case invalidDate(message: String)
}
```

---

## 🧪 테스트 가능성

### 각 레이어 테스트

```swift
// Domain Layer Test (Unit Test)
class CreateRecordUseCaseTests: XCTestCase {
    var recordRepository: MockRecordRepository!
    var useCase: CreateRecordUseCase!
    
    func test하루에두번기록시도시실패() async throws {
        // Given
        let today = Date()
        recordRepository.addRecord(createTestRecord(date: today))
        
        // When
        do {
            _ = try await useCase.execute(
                type: .text,
                contentText: "두 번째 기록",
                photoData: nil,
                location: nil
            )
            XCTFail("Should throw error")
        } catch let error as TodayOneCutError {
            // Then
            if case .dailyLimitExceeded = error {
                // Success
            } else {
                XCTFail("Wrong error type")
            }
        }
    }
}

// Presentation Layer Test (UI Test)
func test오늘기록이있으면생성버튼비활성화() {
    let app = XCUIApplication()
    app.launch()
    
    // Given: 오늘 기록이 있는 상태
    // ...
    
    // Then
    XCTAssertFalse(app.buttons["create_button"].isEnabled)
}
```

---

## 📊 성능 최적화

### 1. Combine을 통한 반응형 데이터

```swift
// DB 변경 시 자동으로 UI 업데이트
func getAllRecords() -> AnyPublisher<[Record], Never> {
    NotificationCenter.default.publisher(
        for: .NSManagedObjectContextDidSave,
        object: coreDataStack.viewContext
    )
    .map { _ in
        // Fetch records
    }
    .eraseToAnyPublisher()
}
```

### 2. 이미지 최적화

```swift
class ImageCompressor {
    func compressImage(_ imageData: Data, maxSize: Int = 1920) async throws -> Data {
        guard let image = UIImage(data: imageData) else {
            throw TodayOneCutError.fileSaveError()
        }
        
        // 최대 크기 제한
        let resizedImage = image.resized(to: CGSize(width: maxSize, height: maxSize))
        
        // 압축 저장
        return try resizedImage.jpegData(compressionQuality: 0.85) ?? imageData
    }
}
```

---

## 🔄 네비게이션 구조

```swift
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

## 📱 앱 초기화

```swift
@main
struct TodayOneCutApp: App {
    @StateObject private var appContainer = AppContainer.shared
    
    init() {
        // 앱 초기화 로직
        initializeApp()
    }
    
    var body: some Scene {
        WindowGroup {
            AppNavigation()
                .environment(\.managedObjectContext, CoreDataStack.shared.viewContext)
        }
    }
    
    private func initializeApp() {
        // 로깅 초기화 (필요 시)
        #if DEBUG
        // Debug logging
        #endif
    }
}
```

