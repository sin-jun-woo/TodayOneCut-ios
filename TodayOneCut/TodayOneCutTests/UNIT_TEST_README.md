# Unit Test 가이드

## 📋 테스트 파일 구조

```
TodayOneCutTests/
├── ValidateDailyLimitUseCaseTests.swift      # 일일 기록 제한 검증 테스트
├── ValidateUpdateLimitUseCaseTests.swift     # 수정 횟수 제한 검증 테스트
├── ValidateRecordContentUseCaseTests.swift   # 기록 내용 검증 테스트
└── UNIT_TEST_README.md                       # 이 파일
```

## 🧪 테스트 실행 방법

### Xcode에서 실행
1. `⌘U` (Command + U) 또는 **Product > Test**
2. 특정 테스트만 실행: 테스트 메서드 옆의 재생 버튼 클릭
3. 특정 클래스만 실행: 테스트 클래스 옆의 재생 버튼 클릭

### 터미널에서 실행
```bash
# 모든 테스트 실행
xcodebuild test -project TodayOneCut.xcodeproj -scheme TodayOneCut -destination 'platform=iOS Simulator,name=iPhone 15 Pro'

# 특정 테스트만 실행
xcodebuild test -project TodayOneCut.xcodeproj -scheme TodayOneCut -destination 'platform=iOS Simulator,name=iPhone 15 Pro' -only-testing:TodayOneCutTests/ValidateDailyLimitUseCaseTests
```

## 📝 작성된 테스트

### 1. ValidateDailyLimitUseCaseTests
- ✅ 기록이 없는 날짜는 통과
- ✅ 기록이 있는 날짜는 에러 발생

### 2. ValidateUpdateLimitUseCaseTests
- ✅ 당일 기록이고 수정 횟수가 0이면 통과
- ✅ 수정 횟수가 최대치에 도달하면 에러 발생
- ✅ 과거 기록은 수정 불가

### 3. ValidateRecordContentUseCaseTests
- ✅ 텍스트만 있는 경우 통과
- ✅ 사진만 있는 경우 통과
- ✅ 텍스트와 사진이 모두 있는 경우 통과
- ✅ 텍스트와 사진이 모두 없는 경우 에러 발생
- ✅ 빈 문자열 텍스트와 사진이 없는 경우 에러 발생
- ✅ 텍스트 길이 제한 초과 시 에러 발생
- ✅ PHOTO 타입인데 사진이 없으면 에러 발생

## 🔄 추가 작성 예정 테스트

### Use Case 테스트
- [ ] CreateRecordUseCaseTests
- [ ] UpdateRecordUseCaseTests
- [ ] DeleteRecordUseCaseTests
- [ ] GetTodayRecordUseCaseTests
- [ ] SearchRecordsUseCaseTests

### ViewModel 테스트
- [ ] HomeViewModelTests
- [ ] CreateRecordViewModelTests
- [ ] RecordListViewModelTests
- [ ] RecordDetailViewModelTests
- [ ] SettingsViewModelTests

### Repository 테스트
- [ ] RecordRepositoryImplTests
- [ ] SettingsRepositoryImplTests
- [ ] FileRepositoryImplTests

## 📊 테스트 커버리지 목표

- **핵심 비즈니스 로직**: 80% 이상
- **Use Cases**: 70% 이상
- **ViewModels**: 60% 이상
- **Repositories**: 70% 이상

---

**작성일**: 2025-01-XX  
**버전**: 1.0.0

