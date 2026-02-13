# API 명세서 (Repository & UseCase Interfaces)

> 이 앱은 완전 오프라인 로컬 앱이므로, 네트워크 API가 아닌 **Repository 인터페이스**와 **Use Case 인터페이스**를 정의합니다.

---

## 📚 개요

### 레이어 구조
```
ViewModel
    ↓
Use Case (비즈니스 로직)
    ↓
Repository Interface (추상화)
    ↓
Repository Implementation (구현)
    ↓
Core Data / File System (데이터 접근)
```

---

## 🗂️ Repository Interfaces

### 1. RecordRepository

기록 데이터 관리를 위한 저장소 인터페이스

```swift
protocol RecordRepository {
    
    /// 새로운 기록 생성
    /// - Parameter record: 생성할 기록 객체
    /// - Returns: 생성된 기록 (ID 포함) 또는 에러
    /// - Throws: DailyLimitExceededError 같은 날짜에 이미 기록이 존재하는 경우
    func createRecord(_ record: Record) async throws -> Record
    
    /// 특정 날짜의 기록 조회
    /// - Parameter date: 조회할 날짜
    /// - Returns: 기록이 존재하면 반환, 없으면 nil
    func getRecordByDate(_ date: Date) async throws -> Record?
    
    /// ID로 기록 조회
    /// - Parameter id: 기록 ID
    /// - Returns: 기록이 존재하면 반환, 없으면 nil
    func getRecordById(_ id: Int64) async throws -> Record?
    
    /// 모든 기록 조회 (시간 역순)
    /// - Returns: 실시간 업데이트되는 기록 목록 (Publisher)
    func getAllRecords() -> AnyPublisher<[Record], Never>
    
    /// 페이지네이션된 기록 조회
    /// - Parameters:
    ///   - page: 페이지 번호 (0부터 시작)
    ///   - pageSize: 페이지당 항목 수
    /// - Returns: 해당 페이지의 기록 목록
    func getRecordsPaged(page: Int, pageSize: Int) async throws -> [Record]
    
    /// 특정 월의 모든 기록 조회 (달력용)
    /// - Parameter yearMonth: 조회할 년월 (예: 2025-12)
    /// - Returns: 해당 월의 기록 목록
    func getRecordsByMonth(_ yearMonth: YearMonth) async throws -> [Record]
    
    /// 특정 날짜에 기록이 존재하는지 확인
    /// - Parameter date: 확인할 날짜
    /// - Returns: 기록 존재 여부
    func recordExistsForDate(_ date: Date) async throws -> Bool
    
    /// 기록 수정
    /// - Parameter record: 수정할 기록 (ID 포함)
    /// - Returns: 수정된 기록 또는 에러
    /// - Throws: UpdateLimitExceededError 수정 횟수 초과
    /// - Throws: InvalidDateError 당일 기록이 아닌 경우
    func updateRecord(_ record: Record) async throws -> Record
    
    /// 기록 삭제
    /// - Parameter id: 삭제할 기록 ID
    /// - Throws: RecordNotFoundError 기록이 존재하지 않는 경우
    func deleteRecord(id: Int64) async throws
    
    /// 전체 기록 개수
    /// - Returns: 실시간 업데이트되는 총 기록 수 (Publisher)
    func getTotalRecordCount() -> AnyPublisher<Int, Never>
    
    /// 텍스트 검색
    /// - Parameter keyword: 검색 키워드
    /// - Returns: 검색 결과 목록
    func searchRecords(keyword: String) async throws -> [Record]
    
    /// 기록이 있는 날짜 목록 조회 (달력 표시용)
    /// - Parameter yearMonth: 조회할 년월
    /// - Returns: 기록이 있는 날짜 집합
    func getRecordDatesForMonth(_ yearMonth: YearMonth) async throws -> Set<Date>
}
```

---

### 2. SettingsRepository

앱 설정 관리를 위한 저장소 인터페이스

```swift
protocol SettingsRepository {
    
    /// 앱 설정 조회 (Publisher)
    /// - Returns: 실시간 업데이트되는 설정
    func getSettings() -> AnyPublisher<AppSettings, Never>
    
    /// 앱 설정 조회 (단건)
    /// - Returns: 현재 설정
    func getSettingsOnce() async throws -> AppSettings
    
    /// 위치 정보 저장 설정 업데이트
    /// - Parameter enabled: 위치 저장 활성화 여부
    func updateLocationEnabled(_ enabled: Bool) async throws
    
    /// 테마 모드 변경
    /// - Parameter mode: 테마 모드 (LIGHT, DARK, SYSTEM)
    func updateThemeMode(_ mode: ThemeMode) async throws
    
    /// 최초 실행 완료 표시
    func markFirstLaunchComplete() async throws
    
    /// 전체 설정 업데이트
    /// - Parameter settings: 새로운 설정
    func updateSettings(_ settings: AppSettings) async throws
    
    /// 총 기록 개수 업데이트 (캐시)
    /// - Parameter count: 총 기록 수
    func updateTotalRecords(_ count: Int) async throws
}
```

---

### 3. FileRepository

파일 시스템 관리를 위한 저장소 인터페이스

```swift
protocol FileRepository {
    
    /// 사진 저장
    /// - Parameters:
    ///   - imageData: 이미지 데이터
    ///   - date: 기록 날짜 (파일명으로 사용)
    /// - Returns: 저장된 파일 경로 또는 에러
    func savePhoto(_ imageData: Data, date: Date) async throws -> String
    
    /// 사진 삭제
    /// - Parameter path: 파일 경로
    /// - Throws: FileNotFoundError 파일이 존재하지 않는 경우
    func deletePhoto(path: String) async throws
    
    /// 사진 파일 존재 확인
    /// - Parameter path: 파일 경로
    /// - Returns: 파일 존재 여부
    func photoExists(path: String) async throws -> Bool
    
    /// 사진 압축 및 리사이징
    /// - Parameters:
    ///   - imageData: 원본 이미지 데이터
    ///   - maxSize: 최대 크기 (px)
    ///   - quality: 압축 품질 (0.0-1.0)
    /// - Returns: 압축된 이미지 데이터
    func compressPhoto(
        _ imageData: Data,
        maxSize: Int = 1920,
        quality: CGFloat = 0.85
    ) async throws -> Data
    
    /// 전체 데이터 백업 (JSON)
    /// - Parameter destinationURL: 백업 파일 저장 위치
    /// - Throws: FileSaveError 저장 실패
    func exportData(to destinationURL: URL) async throws
    
    /// 데이터 복원
    /// - Parameter sourceURL: 백업 파일 위치
    /// - Returns: 복원된 기록 개수
    /// - Throws: FileNotFoundError, InvalidDataError
    func importData(from sourceURL: URL) async throws -> Int
    
    /// 사진 저장소 전체 용량 계산
    /// - Returns: 총 용량 (bytes)
    func getTotalPhotoSize() async throws -> Int64
}
```

---

## 🎯 Use Cases

### Record Use Cases

#### 1. CreateRecordUseCase

```swift
/// 새로운 기록 생성
/// 
/// 비즈니스 규칙:
/// - 오늘 날짜만 허용
/// - 하루에 하나만 생성 가능
/// - 사진 또는 텍스트 필수
class CreateRecordUseCase {
    private let recordRepository: RecordRepository
    private let fileRepository: FileRepository
    private let validateDailyLimit: ValidateDailyLimitUseCase
    private let validateDate: ValidateDateUseCase
    
    /// - Parameters:
    ///   - type: 기록 타입 (PHOTO or TEXT)
    ///   - contentText: 텍스트 내용 (선택)
    ///   - photoData: 사진 데이터 (PHOTO 타입인 경우 필수)
    ///   - location: 위치 정보 (선택)
    /// - Returns: 생성된 기록 또는 에러
    func execute(
        type: RecordType,
        contentText: String?,
        photoData: Data?,
        location: Location?
    ) async throws -> Record
}
```

#### 2. GetTodayRecordUseCase

```swift
/// 오늘 기록 조회
class GetTodayRecordUseCase {
    private let recordRepository: RecordRepository
    
    /// - Returns: 오늘 기록이 있으면 반환, 없으면 nil
    func execute() async throws -> Record?
}
```

#### 3. GetAllRecordsUseCase

```swift
/// 모든 기록 조회
class GetAllRecordsUseCase {
    private let recordRepository: RecordRepository
    
    /// - Returns: 실시간 기록 목록 (Publisher)
    func execute() -> AnyPublisher<[Record], Never>
}
```

#### 4. GetRecordByIdUseCase

```swift
/// ID로 기록 조회
class GetRecordByIdUseCase {
    private let recordRepository: RecordRepository
    
    /// - Parameter id: 기록 ID
    /// - Returns: 기록 또는 nil
    func execute(id: Int64) async throws -> Record?
}
```

#### 5. UpdateRecordUseCase

```swift
/// 기록 수정
/// 
/// 비즈니스 규칙:
/// - 당일 기록만 수정 가능
/// - 수정은 1회만 허용
class UpdateRecordUseCase {
    private let recordRepository: RecordRepository
    private let fileRepository: FileRepository
    private let validateUpdateLimit: ValidateUpdateLimitUseCase
    
    /// - Parameters:
    ///   - record: 수정할 기록
    ///   - newPhotoData: 새 사진 데이터 (변경 시)
    /// - Returns: 수정된 기록 또는 에러
    func execute(
        record: Record,
        newPhotoData: Data? = nil
    ) async throws -> Record
}
```

#### 6. DeleteRecordUseCase

```swift
/// 기록 삭제
class DeleteRecordUseCase {
    private let recordRepository: RecordRepository
    private let fileRepository: FileRepository
    
    /// - Parameter id: 삭제할 기록 ID
    /// - Throws: RecordNotFoundError
    func execute(id: Int64) async throws
}
```

#### 7. SearchRecordsUseCase

```swift
/// 기록 검색
class SearchRecordsUseCase {
    private let recordRepository: RecordRepository
    
    /// - Parameter keyword: 검색 키워드
    /// - Returns: 검색 결과
    func execute(keyword: String) async throws -> [Record]
}
```

---

### Validation Use Cases

#### 1. ValidateDailyLimitUseCase

```swift
/// 일일 기록 제한 검증
class ValidateDailyLimitUseCase {
    private let recordRepository: RecordRepository
    
    /// - Parameter date: 확인할 날짜
    /// - Throws: DailyLimitExceededError 이미 기록이 존재하는 경우
    func execute(date: Date) async throws
}
```

#### 2. ValidateUpdateLimitUseCase

```swift
/// 수정 횟수 제한 검증
class ValidateUpdateLimitUseCase {
    /// - Parameter record: 검증할 기록
    /// - Throws: UpdateLimitExceededError 수정 횟수 초과
    /// - Throws: InvalidDateError 당일 기록이 아님
    func execute(record: Record) throws
}
```

#### 3. ValidateDateUseCase

```swift
/// 날짜 유효성 검증
class ValidateDateUseCase {
    /// - Parameter date: 검증할 날짜
    /// - Throws: InvalidDateError 과거/미래 날짜인 경우
    func execute(date: Date) throws
}
```

#### 4. ValidateRecordContentUseCase

```swift
/// 기록 내용 유효성 검증
class ValidateRecordContentUseCase {
    /// - Parameters:
    ///   - type: 기록 타입
    ///   - contentText: 텍스트 내용
    ///   - photoData: 사진 데이터
    /// - Throws: InvalidContentError 내용이 비어있거나 유효하지 않음
    func execute(
        type: RecordType,
        contentText: String?,
        photoData: Data?
    ) throws
}
```

---

### Calendar Use Cases

#### 1. GetMonthRecordsUseCase

```swift
/// 특정 월의 기록 조회 (달력용)
class GetMonthRecordsUseCase {
    private let recordRepository: RecordRepository
    
    /// - Parameter yearMonth: 조회할 년월
    /// - Returns: 해당 월의 기록 목록
    func execute(_ yearMonth: YearMonth) async throws -> [Record]
}
```

#### 2. GetRecordDatesUseCase

```swift
/// 기록이 있는 날짜 목록 조회
class GetRecordDatesUseCase {
    private let recordRepository: RecordRepository
    
    /// - Parameter yearMonth: 조회할 년월
    /// - Returns: 기록이 있는 날짜 집합
    func execute(_ yearMonth: YearMonth) async throws -> Set<Date>
}
```

---

### Settings Use Cases

#### 1. GetSettingsUseCase

```swift
/// 앱 설정 조회
class GetSettingsUseCase {
    private let settingsRepository: SettingsRepository
    
    /// - Returns: 실시간 설정 (Publisher)
    func execute() -> AnyPublisher<AppSettings, Never>
}
```

#### 2. UpdateLocationSettingUseCase

```swift
/// 위치 정보 저장 설정 변경
class UpdateLocationSettingUseCase {
    private let settingsRepository: SettingsRepository
    
    /// - Parameter enabled: 활성화 여부
    func execute(enabled: Bool) async throws
}
```

#### 3. UpdateThemeUseCase

```swift
/// 테마 변경
class UpdateThemeUseCase {
    private let settingsRepository: SettingsRepository
    
    /// - Parameter mode: 테마 모드
    func execute(mode: ThemeMode) async throws
}
```

---

### Location Use Cases

#### 1. GetCurrentLocationUseCase

```swift
/// 현재 위치 가져오기
class GetCurrentLocationUseCase {
    private let locationManager: LocationManager
    
    /// - Returns: 현재 위치 또는 에러
    /// - Throws: PermissionDeniedError 위치 권한 없음
    func execute() async throws -> Location
}
```

#### 2. ReverseGeocodeUseCase

```swift
/// 좌표를 주소로 변환
class ReverseGeocodeUseCase {
    private let geocoder: CLGeocoder
    
    /// - Parameters:
    ///   - latitude: 위도
    ///   - longitude: 경도
    /// - Returns: 주소 문자열 또는 nil
    func execute(latitude: Double, longitude: Double) async throws -> String?
}
```

---

## 🎭 Result 타입 정의

### Result Enum

```swift
enum Result<Success, Failure: Error> {
    case success(Success)
    case failure(Failure)
    
    var isSuccess: Bool {
        if case .success = self { return true }
        return false
    }
    
    var isFailure: Bool {
        if case .failure = self { return true }
        return false
    }
    
    func getOrNil() -> Success? {
        if case .success(let value) = self {
            return value
        }
        return nil
    }
    
    func getOrThrow() throws -> Success {
        switch self {
        case .success(let value):
            return value
        case .failure(let error):
            throw error
        }
    }
    
    func map<NewSuccess>(_ transform: (Success) -> NewSuccess) -> Result<NewSuccess, Failure> {
        switch self {
        case .success(let value):
            return .success(transform(value))
        case .failure(let error):
            return .failure(error)
        }
    }
}
```

---

## ❌ 커스텀 예외 정의

```swift
/// 앱 전용 예외 기본 클래스
enum TodayOneCutError: LocalizedError {
    case dailyLimitExceeded(message: String = "하루에 하나만 기록할 수 있습니다")
    case updateLimitExceeded(message: String = "수정은 1회만 가능합니다")
    case invalidDate(message: String)
    case invalidContent(message: String = "사진 또는 텍스트가 필요합니다")
    case recordNotFound(message: String = "기록을 찾을 수 없습니다")
    case fileSaveError(message: String = "파일 저장에 실패했습니다")
    case permissionDenied(message: String = "필요한 권한이 없습니다")
    case databaseError(message: String = "데이터 저장 중 오류가 발생했습니다")
    
    var errorDescription: String? {
        switch self {
        case .dailyLimitExceeded(let message):
            return message
        case .updateLimitExceeded(let message):
            return message
        case .invalidDate(let message):
            return message
        case .invalidContent(let message):
            return message
        case .recordNotFound(let message):
            return message
        case .fileSaveError(let message):
            return message
        case .permissionDenied(let message):
            return message
        case .databaseError(let message):
            return message
        }
    }
    
    var userMessage: String {
        switch self {
        case .dailyLimitExceeded:
            return "오늘은 이미 기록을 남겼어요"
        case .updateLimitExceeded:
            return "이미 수정한 기록은 다시 수정할 수 없어요"
        case .invalidDate(let message):
            return message
        case .invalidContent:
            return "사진이나 텍스트 중 하나는 있어야 해요"
        case .recordNotFound:
            return "기록을 찾을 수 없어요"
        case .fileSaveError:
            return "사진 저장에 실패했어요"
        case .permissionDenied:
            return "필요한 권한이 없어요"
        case .databaseError:
            return "데이터 저장에 실패했어요. 다시 시도해주세요"
        }
    }
}
```

---

## 📊 사용 예시

### ViewModel에서 UseCase 사용

```swift
@MainActor
class CreateRecordViewModel: ObservableObject {
    @Published var uiState = CreateRecordUiState()
    
    private let createRecordUseCase: CreateRecordUseCase
    private let getCurrentLocationUseCase: GetCurrentLocationUseCase
    
    func saveRecord() {
        Task {
            uiState.isSaving = true
            
            // 위치 정보 가져오기 (설정이 활성화된 경우)
            let location: Location?
            if uiState.enableLocation {
                do {
                    location = try await getCurrentLocationUseCase.execute()
                } catch {
                    location = nil
                }
            } else {
                location = nil
            }
            
            // 기록 생성
            do {
                let record = try await createRecordUseCase.execute(
                    type: uiState.recordType,
                    contentText: uiState.contentText.isEmpty ? nil : uiState.contentText,
                    photoData: uiState.selectedPhotoData,
                    location: location
                )
                
                uiState.isSaving = false
                uiState.saveSuccess = true
            } catch {
                uiState.isSaving = false
                uiState.error = error.localizedDescription
            }
        }
    }
}
```

### Repository 구현 예시

```swift
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
        // Core Data NSFetchedResultsController 또는 NotificationCenter 사용
        // Combine으로 변환하여 반환
        // ...
    }
}
```

---

## 📝 API 사용 가이드

### 1. 기록 생성 플로우

```swift
// 1. 유효성 검사
try validateRecordContentUseCase.execute(
    type: type,
    contentText: contentText,
    photoData: photoData
)

// 2. 날짜 검증
try validateDateUseCase.execute(date: Date())

// 3. 일일 제한 검증
try await validateDailyLimitUseCase.execute(date: Date())

// 4. 기록 생성
let record = try await createRecordUseCase.execute(
    type: type,
    contentText: contentText,
    photoData: photoData,
    location: location
)
```

### 2. 기록 수정 플로우

```swift
// 1. 기록 조회
guard let record = try await getRecordByIdUseCase.execute(id: recordId) else {
    return
}

// 2. 수정 가능 여부 검증
try validateUpdateLimitUseCase.execute(record: record)

// 3. 수정 실행
let updatedRecord = try await updateRecordUseCase.execute(
    record: updatedRecord,
    newPhotoData: newPhotoData
)
```

### 3. 목록 조회 플로우

```swift
// Publisher를 통한 실시간 조회
getAllRecordsUseCase.execute()
    .sink { records in
        // UI 업데이트
    }
    .store(in: &cancellables)
```

---

## 🔒 권한 관리

### 필요한 권한

| 권한 | 용도 | 필수 여부 |
|------|------|----------|
| NSCameraUsageDescription | 카메라로 사진 촬영 | 선택 (갤러리 대안 가능) |
| NSPhotoLibraryUsageDescription | 갤러리 접근 | 선택 |
| NSLocationWhenInUseUsageDescription | 정확한 위치 정보 | 선택 |

### 권한 체크 UseCase

```swift
class CheckPermissionUseCase {
    func checkCameraPermission() -> Bool {
        return AVCaptureDevice.authorizationStatus(for: .video) == .authorized
    }
    
    func checkLocationPermission() -> Bool {
        return CLLocationManager.authorizationStatus() == .authorizedWhenInUse
    }
}
```

