# Release 빌드 가이드

## 📦 Release 빌드 생성하기

### 1. Xcode에서 Release 빌드 설정 확인

1. Xcode에서 프로젝트 열기
2. 프로젝트 네비게이터에서 프로젝트 선택
3. **Targets** > **TodayOneCut** 선택
4. **Build Settings** 탭 선택
5. 다음 설정 확인:

#### 필수 설정 확인

- **Code Signing**
  - `DEVELOPMENT_TEAM`: 개발자 팀 선택
  - `CODE_SIGN_STYLE`: Automatic 또는 Manual
  - `PROVISIONING_PROFILE_SPECIFIER`: (필요한 경우)

- **Versioning**
  - `MARKETING_VERSION`: 1.0 (또는 현재 버전)
  - `CURRENT_PROJECT_VERSION`: 1 (또는 빌드 번호)

- **Optimization**
  - `SWIFT_OPTIMIZATION_LEVEL`: `-O` (Release 모드)
  - `GCC_OPTIMIZATION_LEVEL`: `-Os` (Release 모드)

### 2. Release 빌드 생성

#### 방법 1: Xcode에서 직접 빌드

1. 상단 툴바에서 **Scheme** 선택
   - `TodayOneCut` 선택
2. **Product** > **Scheme** > **Edit Scheme...**
3. **Run** 선택 > **Info** 탭
4. **Build Configuration**: `Release` 선택
5. **Close** 클릭
6. **Product** > **Build** (`⌘B`)
7. 빌드 성공 확인

#### 방법 2: Archive 생성 (App Store 배포용)

1. **Product** > **Scheme** > **Edit Scheme...**
2. **Archive** 선택 > **Build Configuration**: `Release` 선택
3. **Close** 클릭
4. **Product** > **Archive** (`⌘⇧B`)
5. Archive 완료 후 **Organizer** 창이 열림
6. Archive 검증:
   - **Distribute App** 클릭
   - **Validate App** 선택 (선택사항)
   - 검증 완료 확인

### 3. Release 빌드 테스트

#### 시뮬레이터에서 테스트

1. **Product** > **Scheme** > **Edit Scheme...**
2. **Run** 선택 > **Info** 탭
3. **Build Configuration**: `Release` 선택
4. **Close** 클릭
5. **Product** > **Run** (`⌘R`)
6. 시뮬레이터에서 앱 실행
7. 모든 기능 테스트 (TESTING_GUIDE.md 참고)

#### 실제 기기에서 테스트

1. iOS 기기를 Mac에 연결
2. Xcode에서 기기 선택
3. **Product** > **Run** (`⌘R`)
4. 기기에서 앱 실행
5. 모든 기능 테스트

### 4. Release 빌드 체크리스트

#### 빌드 설정
- [ ] Release 빌드 성공
- [ ] Archive 생성 성공 (선택사항)
- [ ] 빌드 경고 없음 (또는 허용 가능한 경고만)
- [ ] 빌드 에러 없음

#### 기능 테스트
- [ ] 모든 화면 정상 동작
- [ ] 기록 작성/수정/삭제 정상 동작
- [ ] 하루 1개 기록 제한 정상 동작
- [ ] 당일 기록 1회 수정 제한 정상 동작
- [ ] 검색 기능 정상 동작
- [ ] 달력 기능 정상 동작
- [ ] 설정 변경 정상 동작
- [ ] 권한 처리 정상 동작

#### 성능 확인
- [ ] 앱 시작 시간 적정 (3초 이내)
- [ ] 화면 전환 부드러움
- [ ] 이미지 로딩 속도 적정
- [ ] 메모리 사용량 적정

#### 크래시 확인
- [ ] 크래시 없음
- [ ] 메모리 경고 없음
- [ ] 예외 처리 정상 동작

### 5. 빌드 정보 확인

#### 앱 버전 확인
1. 앱 실행
2. 설정 화면으로 이동
3. "버전" 항목에서 버전 확인
   - 예: `1.0 (1)`

#### 빌드 크기 확인
1. **Product** > **Archive**
2. **Organizer** 창에서 Archive 선택
3. **Distribute App** > **App Store Connect** 선택
4. 빌드 크기 확인 (일반적으로 50MB 이하 권장)

### 6. 문제 해결

#### 빌드 실패 시
1. **Product** > **Clean Build Folder** (`⌘⇧K`)
2. 다시 빌드 시도
3. 에러 메시지 확인 및 수정

#### 서명 오류 시
1. **Targets** > **TodayOneCut** > **Signing & Capabilities**
2. **Automatically manage signing** 체크
3. **Team** 선택
4. 다시 빌드 시도

#### Archive 실패 시
1. **Product** > **Clean Build Folder**
2. **Product** > **Archive** 다시 시도
3. 에러 로그 확인

---

## 📊 Release 빌드 체크리스트

### 빌드 전 확인
- [ ] 모든 기능 구현 완료
- [ ] Debug 빌드에서 모든 기능 테스트 완료
- [ ] 린트 오류 없음
- [ ] 경고 최소화

### 빌드 중 확인
- [ ] Release 빌드 성공
- [ ] Archive 생성 성공 (선택사항)
- [ ] 빌드 경고 확인 및 검토

### 빌드 후 확인
- [ ] Release 빌드에서 기능 테스트 완료
- [ ] 성능 확인 완료
- [ ] 크래시 없음 확인
- [ ] 앱 크기 확인

---

## 🚀 다음 단계

Release 빌드 확인 완료 후:
1. 테스트 코드 작성
2. 최종 점검
3. App Store 배포 준비 (선택사항)

---

**작성일**: 2025-01-XX  
**버전**: 1.0.0

