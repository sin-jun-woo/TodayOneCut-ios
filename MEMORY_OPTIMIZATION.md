# 메모리 최적화 가이드

## 🔍 메모리 누수 검사 방법

### 1. Instruments Leaks 사용

1. Xcode에서 **Product > Profile** (`⌘I`)
2. **Leaks** 템플릿 선택
3. 앱 실행 및 주요 기능 사용
4. 메모리 누수 확인

### 2. 확인 항목

#### ViewModel 취소 처리
```swift
// ✅ 올바른 예
class HomeViewModel: ObservableObject {
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        repository.getAllRecords()
            .sink { ... }
            .store(in: &cancellables) // ✅ 저장
    }
}

// ❌ 잘못된 예
class HomeViewModel: ObservableObject {
    init() {
        repository.getAllRecords()
            .sink { ... }
            // ❌ 저장하지 않음 - 메모리 누수!
    }
}
```

#### Task 취소 처리
```swift
// ✅ 올바른 예
class CreateRecordViewModel: ObservableObject {
    private var currentTask: Task<Void, Never>?
    
    func loadData() {
        currentTask?.cancel() // 이전 작업 취소
        currentTask = Task {
            // 작업 수행
        }
    }
    
    deinit {
        currentTask?.cancel()
    }
}
```

#### 이미지 메모리 해제
```swift
// ✅ 이미지 사용 후 해제
struct RecordCard: View {
    let photoPath: String?
    
    var body: some View {
        if let photoPath = photoPath {
            AsyncImage(url: URL(fileURLWithPath: photoPath)) { ... }
        }
    }
}
```

## 📊 메모리 사용량 목표

- **앱 시작 시**: 50MB 이내
- **기록 목록 화면**: 100MB 이내
- **이미지 뷰어**: 150MB 이내
- **최대 메모리**: 200MB 이내

## 🛠️ 메모리 최적화 체크리스트

- [ ] ViewModel의 cancellables 정리 확인
- [ ] Task 취소 처리 확인
- [ ] 이미지 메모리 해제 확인
- [ ] Instruments Leaks로 누수 검사
- [ ] Instruments Allocations로 사용량 확인
- [ ] 반복 작업 시 메모리 증가 없음 확인

---

**작성일**: 2025-01-XX  
**버전**: 1.0.0

