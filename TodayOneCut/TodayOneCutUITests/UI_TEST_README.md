# UI Test 가이드

## 📋 테스트 파일 구조

```
TodayOneCutUITests/
├── TodayOneCutUITests.swift    # 기본 UI 테스트
└── UI_TEST_README.md           # 이 파일
```

## 🧪 UI 테스트 실행 방법

### Xcode에서 실행
1. `⌘U` (Command + U) 또는 **Product > Test**
2. UI 테스트만 실행: Scheme에서 `TodayOneCutUITests` 선택 후 실행

### 터미널에서 실행
```bash
# UI 테스트 실행
xcodebuild test -project TodayOneCut.xcodeproj -scheme TodayOneCut -destination 'platform=iOS Simulator,name=iPhone 15 Pro' -only-testing:TodayOneCutUITests
```

## 📝 작성된 테스트

### 기본 네비게이션 테스트
- ✅ 온보딩 화면 표시 확인
- ✅ 온보딩 완료 후 메인 화면 이동 확인
- ✅ 홈 화면 기록 작성 버튼 확인
- ✅ 기록 작성 화면 이동 확인
- ✅ 기록 목록 화면 이동 확인
- ✅ 달력 화면 이동 확인
- ✅ 설정 화면 이동 확인

## 🔄 추가 작성 예정 테스트

### 기능 테스트
- [ ] 기록 작성 플로우 테스트
- [ ] 기록 수정 플로우 테스트
- [ ] 기록 삭제 플로우 테스트
- [ ] 검색 기능 테스트
- [ ] 달력에서 기록 선택 테스트
- [ ] 설정 변경 테스트

### 엣지 케이스 테스트
- [ ] 하루 1개 기록 제한 테스트
- [ ] 당일 기록 1회 수정 제한 테스트
- [ ] 권한 거부 시 처리 테스트

## 💡 UI 테스트 작성 팁

### 1. 요소 식별
- `accessibilityIdentifier` 사용 권장
- 버튼 텍스트로 찾기 (한글 텍스트 사용 가능)
- 시스템 이미지 이름으로 찾기 (예: `plus.circle.fill`)

### 2. 대기 처리
- `waitForExistence(timeout:)` 사용
- 비동기 작업 완료 대기

### 3. 권한 처리
- 테스트 시작 전 권한 설정
- `addUIInterruptionMonitor` 사용

### 4. 데이터 초기화
- 각 테스트 전 데이터 초기화
- `setUp()` 메서드에서 처리

---

**작성일**: 2025-01-XX  
**버전**: 1.0.0

