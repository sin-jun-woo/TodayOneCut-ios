# 에러 처리 가이드

## 🎯 에러 처리 철학

### 핵심 원칙
1. **사용자 친화적**: 기술 용어 없이 쉬운 말로
2. **명확한 안내**: 무엇이 문제이고 어떻게 해결하는지
3. **조용한 실패**: 치명적이지 않으면 조용히 처리
4. **복구 가능성**: 가능한 한 복구 방법 제시

### 에러 레벨

| 레벨 | 설명 | 처리 방식 |
|------|------|----------|
| **Critical** | 앱 동작 불가 | 에러 화면 + 재시작 유도 |
| **Major** | 주요 기능 실패 | 에러 메시지 + 재시도 버튼 |
| **Minor** | 부가 기능 실패 | Alert 또는 Toast |
| **Silent** | 사용자 영향 없음 | 로그만 기록 |

---

## 📋 예외 계층 구조

```swift
/// 앱 전용 예외 기본 프로토콜
protocol TodayOneCutError: LocalizedError {
    /// 사용자에게 표시할 메시지
    var userMessage: String { get }
    
    /// 에러 레벨
    var level: ErrorLevel { get }
    
    /// 복구 가능 여부
    var isRecoverable: Bool { get }
}

enum ErrorLevel {
    case critical  // 앱 동작 불가
    case major     // 주요 기능 실패
    case minor     // 부가 기능 실패
    case silent    // 로그만
}
```

---

## ❌ 커스텀 예외 정의

### 1. 비즈니스 규칙 위반

```swift
/// 하루 기록 제한 초과
/// 
/// 발생 상황: 같은 날짜에 두 번째 기록 시도
/// 레벨: MAJOR
enum DailyLimitExceededError: TodayOneCutError {
    case exceeded(message: String = "하루에 하나만 기록할 수 있습니다")
    
    var errorDescription: String? {
        switch self {
        case .exceeded(let message):
            return message
        }
    }
    
    var userMessage: String {
        return "오늘은 이미 기록을 남겼어요"
    }
    
    var level: ErrorLevel {
        return .major
    }
    
    var isRecoverable: Bool {
        return false
    }
}
```

```swift
/// 수정 횟수 제한 초과
/// 
/// 발생 상황: 이미 1회 수정한 기록을 다시 수정 시도
/// 레벨: MAJOR
enum UpdateLimitExceededError: TodayOneCutError {
    case exceeded(message: String = "수정은 1회만 가능합니다")
    
    var errorDescription: String? {
        switch self {
        case .exceeded(let message):
            return message
        }
    }
    
    var userMessage: String {
        return "이미 수정한 기록은 다시 수정할 수 없어요"
    }
    
    var level: ErrorLevel {
        return .major
    }
    
    var isRecoverable: Bool {
        return false
    }
}
```

```swift
/// 잘못된 날짜
/// 
/// 발생 상황: 과거 또는 미래 날짜로 기록 시도
/// 레벨: MAJOR
enum InvalidDateError: TodayOneCutError {
    case past(message: String = "과거 날짜는 기록할 수 없습니다")
    case future(message: String = "미래 날짜는 기록할 수 없습니다")
    
    var errorDescription: String? {
        switch self {
        case .past(let message), .future(let message):
            return message
        }
    }
    
    var userMessage: String {
        switch self {
        case .past:
            return "과거 날짜는 기록할 수 없어요"
        case .future:
            return "미래 날짜는 기록할 수 없어요"
        }
    }
    
    var level: ErrorLevel {
        return .major
    }
    
    var isRecoverable: Bool {
        return false
    }
}
```

```swift
/// 잘못된 내용
/// 
/// 발생 상황: 사진도 텍스트도 없이 저장 시도
/// 레벨: MAJOR
enum InvalidContentError: TodayOneCutError {
    case empty(message: String = "사진 또는 텍스트가 필요합니다")
    
    var errorDescription: String? {
        switch self {
        case .empty(let message):
            return message
        }
    }
    
    var userMessage: String {
        return "사진이나 텍스트 중 하나는 있어야 해요"
    }
    
    var level: ErrorLevel {
        return .major
    }
    
    var isRecoverable: Bool {
        return true
    }
}
```

### 2. 데이터 관련 에러

```swift
/// 기록을 찾을 수 없음
/// 
/// 발생 상황: 삭제되었거나 존재하지 않는 기록 접근
/// 레벨: MAJOR
enum RecordNotFoundError: TodayOneCutError {
    case notFound(recordId: Int64?, message: String = "기록을 찾을 수 없습니다")
    
    var errorDescription: String? {
        switch self {
        case .notFound(_, let message):
            return message
        }
    }
    
    var userMessage: String {
        return "기록을 찾을 수 없어요"
    }
    
    var level: ErrorLevel {
        return .major
    }
    
    var isRecoverable: Bool {
        return false
    }
}
```

```swift
/// 데이터베이스 에러
/// 
/// 발생 상황: DB 접근 실패, 쿼리 오류 등
/// 레벨: CRITICAL
enum DatabaseError: TodayOneCutError {
    case saveFailed(message: String = "데이터 저장 중 오류가 발생했습니다")
    case fetchFailed(message: String = "데이터 조회 중 오류가 발생했습니다")
    
    var errorDescription: String? {
        switch self {
        case .saveFailed(let message), .fetchFailed(let message):
            return message
        }
    }
    
    var userMessage: String {
        return "데이터 저장에 실패했어요. 다시 시도해주세요"
    }
    
    var level: ErrorLevel {
        return .critical
    }
    
    var isRecoverable: Bool {
        return true
    }
}
```

### 3. 파일 관련 에러

```swift
/// 파일 저장 실패
/// 
/// 발생 상황: 저장 공간 부족, 권한 없음 등
/// 레벨: MAJOR
enum FileSaveError: TodayOneCutError {
    case noSpace(message: String = "저장 공간이 부족합니다")
    case permissionDenied(message: String = "파일 저장 권한이 없습니다")
    case unknown(message: String = "파일 저장에 실패했습니다")
    
    var errorDescription: String? {
        switch self {
        case .noSpace(let message), .permissionDenied(let message), .unknown(let message):
            return message
        }
    }
    
    var userMessage: String {
        switch self {
        case .noSpace:
            return "저장 공간이 부족해요"
        case .permissionDenied:
            return "파일 저장 권한이 없어요"
        case .unknown:
            return "사진 저장에 실패했어요"
        }
    }
    
    var level: ErrorLevel {
        return .major
    }
    
    var isRecoverable: Bool {
        return true
    }
}
```

```swift
/// 파일을 찾을 수 없음
/// 
/// 발생 상황: 삭제된 사진 파일 접근
/// 레벨: MINOR
enum FileNotFoundError: TodayOneCutError {
    case notFound(path: String, message: String = "파일을 찾을 수 없습니다")
    
    var errorDescription: String? {
        switch self {
        case .notFound(_, let message):
            return message
        }
    }
    
    var userMessage: String {
        return "사진 파일을 찾을 수 없어요"
    }
    
    var level: ErrorLevel {
        return .minor
    }
    
    var isRecoverable: Bool {
        return false
    }
}
```

### 4. 권한 관련 에러

```swift
/// 권한 거부
/// 
/// 발생 상황: 필요한 권한이 없을 때
/// 레벨: MAJOR
enum PermissionDeniedError: TodayOneCutError {
    case camera(message: String = "카메라 권한이 필요합니다")
    case location(message: String = "위치 권한이 필요합니다")
    case photoLibrary(message: String = "사진 라이브러리 권한이 필요합니다")
    
    var errorDescription: String? {
        switch self {
        case .camera(let message), .location(let message), .photoLibrary(let message):
            return message
        }
    }
    
    var userMessage: String {
        switch self {
        case .camera:
            return "카메라 권한이 필요해요"
        case .location:
            return "위치 권한이 필요해요"
        case .photoLibrary:
            return "사진 라이브러리 권한이 필요해요"
        }
    }
    
    var level: ErrorLevel {
        return .major
    }
    
    var isRecoverable: Bool {
        return true
    }
    
    var settingsGuide: String {
        return "설정에서 권한을 허용해주세요"
    }
}
```

---

## 🎨 UI 에러 표시

### 1. 에러 상태 관리

```swift
/// UI 에러 상태
struct UiError {
    let message: String
    let level: ErrorLevel
    let action: ErrorAction?
    
    static func from(_ error: Error) -> UiError {
        if let todayOneCutError = error as? TodayOneCutError {
            return UiError(
                message: todayOneCutError.userMessage,
                level: todayOneCutError.level,
                action: todayOneCutError.isRecoverable ? .retry : nil
            )
        } else {
            return UiError(
                message: "오류가 발생했어요",
                level: .major,
                action: .retry
            )
        }
    }
}

enum ErrorAction {
    case retry
    case goToSettings
    case dismiss
}
```

### 2. 에러 메시지 표시 컴포넌트

```swift
struct ErrorMessage: View {
    let error: UiError
    let onRetry: (() -> Void)?
    let onDismiss: () -> Void
    
    var body: some View {
        switch error.level {
        case .critical:
            CriticalErrorScreen(
                message: error.message,
                onRetry: onRetry
            )
        case .major:
            Alert(
                "알림",
                isPresented: .constant(true),
                presenting: error
            ) { error in
                Button("확인") {
                    onDismiss()
                }
                if let onRetry = onRetry {
                    Button("다시 시도") {
                        onRetry()
                    }
                }
            } message: { error in
                Text(error.message)
            }
        case .minor:
            // Toast 또는 Snackbar (호출하는 쪽에서 처리)
            EmptyView()
        case .silent:
            EmptyView()
        }
    }
}

struct CriticalErrorScreen: View {
    let message: String
    let onRetry: (() -> Void)?
    
    var body: some View {
        VStack(spacing: 24) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 60))
                .foregroundColor(.red)
            
            Text(message)
                .font(.title2)
                .multilineTextAlignment(.center)
            
            if let onRetry = onRetry {
                Button("다시 시도") {
                    onRetry()
                }
                .buttonStyle(.borderedProminent)
            }
        }
        .padding()
    }
}
```

---

## 🔄 에러 처리 플로우

### ViewModel에서의 에러 처리

```swift
@MainActor
class CreateRecordViewModel: ObservableObject {
    @Published var uiState = CreateRecordUiState()
    
    private let createRecordUseCase: CreateRecordUseCase
    
    func saveRecord() {
        Task {
            uiState.isSaving = true
            uiState.error = nil
            
            do {
                let record = try await createRecordUseCase.execute(
                    type: uiState.recordType,
                    contentText: uiState.contentText,
                    photoData: uiState.selectedPhotoData,
                    location: uiState.currentLocation
                )
                
                uiState.isSaving = false
                uiState.saveSuccess = true
            } catch {
                handleError(error)
            }
        }
    }
    
    private func handleError(_ error: Error) {
        let uiError = UiError.from(error)
        
        uiState.isSaving = false
        uiState.error = uiError
        
        // 로그 기록
        logError(error)
    }
    
    private func logError(_ error: Error) {
        if let todayOneCutError = error as? TodayOneCutError {
            if todayOneCutError.level == .critical {
                // Critical 에러는 크래시 리포트
                print("Critical error: \(error.localizedDescription)")
            } else {
                print("Handled error: \(todayOneCutError.userMessage)")
            }
        } else {
            print("Unexpected error: \(error.localizedDescription)")
        }
    }
    
    func retryLastAction() {
        saveRecord()
    }
    
    func dismissError() {
        uiState.error = nil
    }
}
```

### View에서의 에러 표시

```swift
struct CreateRecordView: View {
    @StateObject private var viewModel: CreateRecordViewModel
    @State private var showError = false
    
    var body: some View {
        VStack {
            // 메인 컨텐츠
            CreateRecordContent(
                uiState: viewModel.uiState,
                onSave: { viewModel.saveRecord() }
            )
        }
        .alert("알림", isPresented: $showError) {
            if let error = viewModel.uiState.error,
               error.action == .retry {
                Button("다시 시도") {
                    viewModel.retryLastAction()
                }
            }
            Button("확인") {
                viewModel.dismissError()
            }
        } message: {
            if let error = viewModel.uiState.error {
                Text(error.message)
            }
        }
        .onChange(of: viewModel.uiState.error) { error in
            if error != nil {
                showError = true
            }
        }
    }
}
```

---

## 📝 에러 메시지 가이드

### 좋은 에러 메시지 작성 원칙

1. **구체적이고 명확하게**
   - ❌ "오류가 발생했습니다"
   - ✅ "사진 저장에 실패했어요"

2. **사용자 관점으로**
   - ❌ "CoreDataError"
   - ✅ "오늘은 이미 기록을 남겼어요"

3. **해결 방법 제시**
   - ❌ "권한이 없습니다"
   - ✅ "카메라 권한이 필요해요. 설정에서 허용해주세요"

4. **긍정적인 어조**
   - ❌ "실패했습니다"
   - ✅ "다시 시도해주세요"

### 에러 메시지 목록

| 상황 | 기술적 메시지 | 사용자 메시지 |
|------|--------------|--------------|
| 하루 1개 제한 | "UNIQUE constraint failed" | "오늘은 이미 기록을 남겼어요" |
| 수정 1회 제한 | "Update count exceeded" | "이미 수정한 기록은 다시 수정할 수 없어요" |
| 과거 날짜 | "Invalid date: past" | "과거 날짜는 기록할 수 없어요" |
| 미래 날짜 | "Invalid date: future" | "미래 날짜는 기록할 수 없어요" |
| 내용 없음 | "Content is empty" | "사진이나 텍스트 중 하나는 있어야 해요" |
| 저장 공간 부족 | "No space left" | "저장 공간이 부족해요" |
| 파일 없음 | "File not found" | "사진 파일을 찾을 수 없어요" |
| 카메라 권한 | "Permission denied: CAMERA" | "카메라 권한이 필요해요" |
| 위치 권한 | "Permission denied: LOCATION" | "위치 권한이 필요해요" |
| DB 에러 | "Database error" | "데이터 저장에 실패했어요. 다시 시도해주세요" |

---

## 🧪 에러 처리 테스트

### Unit Test 예시

```swift
class CreateRecordUseCaseTests: XCTestCase {
    func test하루2개기록시도시적절한에러발생() async throws {
        // Given
        let today = Date()
        let repository = MockRecordRepository()
        repository.addRecord(createTestRecord(date: today))
        
        let useCase = CreateRecordUseCase(
            recordRepository: repository,
            validateDailyLimit: ValidateDailyLimitUseCase(repository: repository),
            validateDate: ValidateDateUseCase()
        )
        
        // When
        do {
            _ = try await useCase.execute(
                type: .text,
                contentText: "두 번째 기록",
                photoData: nil,
                location: nil
            )
            XCTFail("Should throw error")
        } catch let error as DailyLimitExceededError {
            // Then
            XCTAssertEqual(error.userMessage, "오늘은 이미 기록을 남겼어요")
            XCTAssertEqual(error.level, .major)
        }
    }
}
```

---

## 💡 모범 사례

### DO ✅

```swift
// 구체적인 예외 처리
do {
    try savePhoto()
} catch let error as FileSaveError {
    showError(error.userMessage)
} catch {
    showError("알 수 없는 오류가 발생했어요")
}

// 사용자 친화적 메시지
throw InvalidContentError.empty()

// Result 타입 활용
return .success(record)
```

### DON'T ❌

```swift
// 일반적인 예외만 처리
do {
    try savePhoto()
} catch {
    showError("오류")  // 너무 모호함
}

// 기술 용어 사용
throw NSError(domain: "CoreData", code: 1)

// 예외 무시
do {
    try savePhoto()
} catch {
    // 아무것도 안 함
}
```

