# Swinject 설정 가이드

## 📦 Swinject 추가 방법

### 1단계: Xcode에서 Package 추가

1. Xcode에서 프로젝트 열기
2. `File > Add Package Dependencies...` 선택
3. 검색창에 다음 URL 입력:
   ```
   https://github.com/Swinject/Swinject.git
   ```
4. `Add Package` 클릭
5. 버전 선택: `Up to Next Major Version` (기본값)
6. `Add Package` 클릭
7. `TodayOneCut` 타겟에 추가 확인 후 `Add Package` 클릭

### 2단계: AppContainer 활성화

1. `TodayOneCut/DI/AppContainer.swift` 파일 열기
2. 다음 줄의 주석 해제:
   ```swift
   // import Swinject  ← 이 줄 주석 해제
   ```
3. 다음 줄의 주석 해제:
   ```swift
   // private let container = Container()  ← 이 줄 주석 해제
   ```
4. `resolve` 메서드 주석 해제:
   ```swift
   // func resolve<T>(_ type: T.Type) -> T? {
   //     return container.resolve(type)
   // }
   ```
   ↓
   ```swift
   func resolve<T>(_ type: T.Type) -> T? {
       return container.resolve(type)
   }
   ```

### 3단계: 빌드 확인

1. `Product > Clean Build Folder` (⇧⌘K)
2. `Product > Build` (⌘B)
3. 빌드 성공 확인

---

## ✅ 확인 사항

- [ ] Swinject 패키지가 프로젝트 네비게이터에 표시됨
- [ ] `AppContainer.swift`에서 `import Swinject` 오류 없음
- [ ] `Container()` 초기화 오류 없음
- [ ] 빌드 성공

---

## 📝 참고

- Swinject는 Phase 1, 2에서 실제 의존성 등록 시 사용됩니다.
- 현재는 기본 구조만 준비되어 있으며, 실제 구현은 Domain Layer와 Data Layer가 완성된 후 진행합니다.

