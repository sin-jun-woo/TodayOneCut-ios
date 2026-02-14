# 오늘의 한 컷 (TodayOneCut iOS) - 프로젝트 개발 계획서

## 📋 문서 정보

| 항목            | 내용                 |
| --------------- | -------------------- |
| 작성일          | 2025-01-XX           |
| 프로젝트 시작일 | 2025-01-XX           |
| 목표 완료일     | 2025-04-XX (약 11주) |
| 일일 작업 시간  | 최소 1시간           |
| 문서 버전       | 1.0.0                |

---

## 🎯 프로젝트 개요

### 프로젝트 소개

"오늘의 한 컷"은 하루에 딱 하나의 장면만 기록할 수 있는 iOS 네이티브 앱입니다. 많은 기록을 강요하지 않고, 오늘 가장 기억나는 한 장면만 남기는 것이 핵심 철학입니다.

### 핵심 제약사항

- **하루 1개 기록 제한**: 이것이 앱의 정체성
- **당일 수정 1회만**: 과거 기록은 수정 불가
- **완전 오프라인**: 네트워크 불필요, 로컬 저장
- **간결한 UX**: 불필요한 기능 일체 배제

### 기술 스택

- **Language**: Swift 5.9+
- **UI**: SwiftUI
- **Architecture**: MVVM + Clean Architecture
- **Database**: Core Data (SQLite)
- **DI**: Swinject 또는 Factory
- **Async**: async/await + Combine

---

## 📊 전체 일정 요약

### Phase 별 기간

| Phase   | 내용               | 시작일     | 종료일     | 기간 |
| ------- | ------------------ | ---------- | ---------- | ---- |
| Phase 0 | 프로젝트 초기 설정 | 2025-01-XX | 2025-01-XX | 1주  |
| Phase 1 | Data Layer 구현    | 2025-01-XX | 2025-01-XX | 2주  |
| Phase 2 | Domain Layer 구현  | 2025-01-XX | 2025-01-XX | 1주  |
| Phase 3 | Core UI 구현       | 2025-01-XX | 2025-02-XX | 2주  |
| Phase 4 | Extended UI 구현   | 2025-02-XX | 2025-02-XX | 2주  |
| Phase 5 | 통합 및 테스트     | 2025-02-XX | 2025-03-XX | 10일 |
| Phase 6 | 최적화 및 마무리   | 2025-03-XX | 2025-03-XX | 8일  |

**총 개발 기간**: 74일 (약 11주)  
**예상 총 작업 시간**: 최소 74시간 (1일 1시간 기준)

---

## 🗓️ Phase 0: 프로젝트 초기 설정 (1주)

### 목표

- Xcode 프로젝트 생성 및 기본 설정 완료
- 필요한 라이브러리 의존성 추가
- 프로젝트 구조 및 폴더 생성
- Git 리포지토리 설정

### 상세 작업 계획

#### Day 1: 프로젝트 생성

**작업 시간**: 1시간  
**작업 내용**:

- [x] Xcode에서 새 프로젝트 생성
  - Product Name: TodayOneCut
  - Organization Identifier: com.todayonecut
  - Interface: SwiftUI
  - Language: Swift
  - Storage: Core Data ✅
  - Include Tests: ✅
- [x] Git 초기화 및 .gitignore 설정
- [x] README.md 기본 작성 및 업데이트
- [x] 빌드 테스트 성공 확인

**산출물**: 기본 iOS 프로젝트 ✅

---

#### Day 2: 프로젝트 구조 생성

**작업 시간**: 1시간  
**작업 내용**:

- [x] 프로젝트 폴더 구조 생성
  - App/
  - Presentation/ (Views, Components, Navigation, Theme)
  - Domain/ (Models, Repositories, UseCases)
  - Data/ (Repositories, Database, Local)
  - DI/
  - Utils/
- [x] 각 폴더에 .gitkeep 파일 생성
- [x] 빌드 테스트 성공 확인

**산출물**: 프로젝트 구조 완성 ✅

---

#### Day 3: Core Data 모델 설정

**작업 시간**: 1시간  
**작업 내용**:

- [x] Core Data 모델 파일 설정
  - RecordEntity 정의
  - AppSettingsEntity 정의
- [x] Info.plist 권한 설정
  - 위치 권한
  - 사진 라이브러리 권한
  - 카메라 권한
- [x] 빌드 테스트 성공 확인

**산출물**: Core Data 모델 및 권한 설정 완료 ✅

---

#### Day 4: DI 설정

**작업 시간**: 1시간  
**작업 내용**:

- [x] Swinject 또는 Factory 의존성 추가
  - Swift Package Manager 사용
  - Swinject 추가 가이드 작성 (SWINJECT_SETUP.md)
- [x] AppContainer 기본 구조 생성
  - 전체 의존성 등록 구조 작성 (Phase 1, 2에서 구현 예정)
- [ ] 빌드 테스트 성공 확인 (Swinject 추가 후)

**산출물**: DI 기본 설정 완료 ✅
**참고**: Swinject는 Xcode에서 수동으로 추가 필요 (SWINJECT_SETUP.md 참고)

---

#### Day 5: Theme 및 상수 정의

**작업 시간**: 1시간  
**작업 내용**:

- [x] Material 3 Theme 기본 설정
  - Color.swift: 색상 팔레트 정의
  - Theme.swift: 라이트/다크 테마 설정
- [x] Constants.swift 파일 생성 및 기본 상수 정의
- [x] Extensions.swift 파일 생성 (Date 확장 함수)
- [x] 빌드 테스트 성공 확인

**산출물**: UI Theme 및 상수 정의 완료 ✅

---

#### Day 6-7: Phase 0 점검

**작업 시간**: 1시간  
**작업 내용**:

- [x] Phase 0 최종 점검 및 빌드 테스트
- [x] 첫 주 작업 내용 문서화

**산출물**: 프로젝트 초기 설정 완전 완료 ✅

---

### Phase 0 완료 체크리스트

- [x] Xcode 프로젝트 생성 완료
- [x] 프로젝트 폴더 구조 생성
- [x] Core Data 모델 설정 완료
- [x] Info.plist 권한 설정 완료
- [x] Git 리포지토리 초기화
- [x] 프로젝트 빌드 성공

---

## 🗓️ Phase 1: Data Layer 구현 (2주)

### 목표

- Core Data 스키마 및 Entity 정의
- Repository 구현
- Mapper 클래스 작성

### 상세 작업 계획

#### Week 1: Core Data 및 Entity

- [x] RecordType enum 정의 ✅
- [x] ThemeMode enum 정의 ✅
- [x] RecordEntity 클래스 작성 ✅ (Core Data 모델에 정의됨)
- [x] AppSettingsEntity 클래스 작성 ✅ (Core Data 모델에 정의됨)
- [x] CoreDataStack 구현 ✅

#### Week 2: Repository 및 Mapper

- [x] Domain Model 작성 (Record, Location, AppSettings)
- [x] RecordMapper 클래스 작성
- [x] SettingsMapper 클래스 작성
- [x] Repository Interface 정의
- [x] RecordRepositoryImpl 구현
- [x] SettingsRepositoryImpl 구현
- [x] FileRepositoryImpl 구현
- [x] DI 모듈 설정

---

## 🗓️ Phase 2: Domain Layer 구현 (1주)

### 목표

- 비즈니스 로직을 담은 Use Case 작성
- 유효성 검증 로직 구현
- 커스텀 예외 정의
- Result 타입 활용

### 상세 작업 계획

- [x] Result.swift 작성
- [x] 커스텀 예외 클래스 정의
- [x] Validation Use Cases 작성
- [x] Record Use Cases 작성
- [x] Calendar Use Cases 작성
- [x] Settings Use Cases 작성
- [x] Location Use Cases 작성

---

## 🗓️ Phase 3: Core UI 구현 (2주)

### 목표

- 홈 화면 구현
- 기록 작성 화면 구현
- 기록 목록 화면 구현
- 기록 상세 화면 구현
- 네비게이션 설정

### 상세 작업 계획

#### Week 1: 네비게이션 및 홈 화면

- [x] 네비게이션 구조 설정 (NavigationStack)
- [x] 공통 UI 컴포넌트 작성
- [x] HomeUiState 정의
- [x] HomeViewModel 작성
- [x] HomeView 구현

#### Week 2: 기록 작성/목록/상세 화면

- [x] CreateRecordViewModel 작성
- [x] CreateRecordView 구현
- [x] 카메라 및 갤러리 연동
- [x] RecordListViewModel 작성
- [x] RecordListView 구현
- [x] RecordDetailViewModel 작성
- [x] RecordDetailView 구현

---

## 🗓️ Phase 4: Extended UI 구현 (2주)

### 목표

- 달력 화면 구현
- 설정 화면 구현
- 수정 기능 구현
- 검색 기능 추가
- UI/UX 개선

### 상세 작업 계획

- [x] 기록 수정 화면 구현
- [x] 기록 삭제 기능 구현
- [x] CalendarViewModel 작성
- [x] CalendarView 구현
- [x] SettingsViewModel 작성
- [x] SettingsView 구현
- [x] 검색 기능 구현
- [x] 위치 정보 기능 구현
- [x] UI/UX 개선

---

## 🗓️ Phase 5: 통합 및 테스트 (10일)

### 목표

- 핵심 비즈니스 로직 테스트
- UI 테스트 작성
- 버그 수정
- 안정성 개선
- 에러 처리 강화

### 상세 작업 계획

- [x] 테스트 환경 설정
- [x] Use Case 테스트 작성
- [x] ViewModel 테스트 작성
- [x] Repository 통합 테스트 작성
- [x] UI 테스트 작성
- [x] 엣지 케이스 테스트 작성
- [x] 발견된 버그 수정
- [x] 전체 테스트 실행 및 검증

---

## 🗓️ Phase 6: 최적화 및 마무리 (8일)

### 목표

- 성능 최적화
- 메모리 최적화
- 이미지 압축 개선
- 사용자 가이드 추가
- 출시 준비

### 상세 작업 계획

- [x] 이미지 최적화 및 로딩 최적화
- [x] Database 쿼리 최적화
- [x] 메모리 누수 검사
- [x] 첫 실행 경험 개선
- [x] ProGuard 설정 (iOS는 코드 난독화)
- [x] 앱 서명 설정
- [x] 릴리스 빌드 생성 및 테스트
- [x] 문서 최종 정리
- [x] 코드 정리
- [x] 최종 점검

---

## 🎯 핵심 마일스톤

| 마일스톤               | 완료 날짜  | 설명                           |
| ---------------------- | ---------- | ------------------------------ |
| M1: 프로젝트 설정 완료 | 2025-01-XX | 빌드 가능한 기본 프로젝트 ✅   |
| M2: Data Layer 완성    | 2025-01-XX | Core Data 및 Repository 동작 ✅ |
| M3: Domain Layer 완성  | 2025-01-XX | 모든 Use Case 구현 ✅          |
| M4: Core UI 완성       | 2025-02-XX | 홈/작성/목록/상세 화면 동작 ✅ |
| M5: Extended UI 완성   | 2025-02-XX | 모든 화면 구현 완료 ✅         |
| M6: 테스트 완료        | 2025-03-XX | 안정성 확보                    |
| M7: MVP 출시 준비      | 2025-03-XX | 릴리스 빌드 생성               |

---

## 📈 진행 상황 추적

### 전체 진행률 계산 방법

```
총 작업 일수: 74일
완료한 일수: X일
진행률: (X / 74) × 100%
```

**현재 진행 상황**:

- ✅ Phase 0 완료 (프로젝트 초기 설정 완전 완료)
- 🚧 Phase 1 진행 중 (Data Layer 구현)
- ⏳ Phase 2 예정 (Domain Layer 구현)
- ⏳ Phase 3 예정 (Core UI 구현)
- ⏳ Phase 4 예정 (Extended UI 구현)
- ⏳ Phase 5 예정 (통합 및 테스트)
- ⏳ Phase 6 예정 (최적화 및 마무리)

---

## 🎉 완료 기준

### MVP 1.0.0 출시 준비 완료 조건

#### 기능적 요구사항

- [ ] 사진 또는 텍스트로 기록 작성 가능
- [ ] 하루 1개 기록 제한 정상 동작
- [ ] 당일 기록 1회 수정 가능
- [ ] 기록 목록 시간 역순으로 표시
- [ ] 기록 상세 보기 가능
- [ ] 기록 삭제 가능
- [ ] 달력에서 기록 조회 가능
- [ ] 설정에서 위치/테마 변경 가능

#### 기술적 요구사항

- [ ] 모든 화면 정상 동작
- [ ] 크래시 없음
- [ ] 메모리 누수 없음
- [ ] 오프라인 완전 동작
- [ ] 데이터 영구 저장
- [ ] 권한 처리 정상
- [ ] 빌드 성공 (debug & release)

#### 품질 요구사항

- [ ] 핵심 기능 테스트 커버리지 70% 이상
- [ ] 모든 주요 시나리오 테스트 통과
- [ ] 릴리스 빌드 정상 동작
- [ ] 앱 크기 적정 수준

#### 문서 요구사항

- [ ] README.md 작성 완료
- [ ] 주요 코드에 주석 작성
- [ ] 빌드 방법 문서화
- [ ] 알려진 이슈 문서화

---

## 📝 작업 진행 시 주의사항

### 일일 작업 원칙

1. **작은 단위로 커밋**: 기능 단위로 커밋하여 롤백 용이하게
2. **테스트 우선 고려**: 가능한 경우 테스트와 함께 개발
3. **문서화 동시 진행**: 코드 작성 시 주석 및 문서 업데이트
4. **빌드 성공 유지**: 매일 작업 종료 시 빌드 가능한 상태 유지
5. **이슈 즉시 기록**: 발생한 문제는 바로 문서화

### 코드 품질 유지

- **Naming Convention**: Swift 표준 네이밍 준수
- **Clean Code**: 함수는 하나의 역할만, 구조체는 단일 책임
- **SOLID 원칙**: 특히 의존성 역전 원칙 (DI 활용)
- **DRY 원칙**: 중복 코드 제거, 재사용 컴포넌트 활용

---

## 🎊 마무리

이 계획서는 **TodayOneCut iOS** 프로젝트를 성공적으로 완료하기 위한 로드맵입니다.

### 핵심 원칙

1. **일관성**: 매일 최소 1시간씩 꾸준히
2. **점진적 발전**: 작은 단위로 완성하며 진행
3. **품질 우선**: 빠르게보다는 제대로
4. **유연성**: 상황에 따라 계획 조정 가능

**시작일**: 2025-01-XX  
**목표 완료일**: 2025-04-XX  
**총 기간**: 74일 (약 11주)

프로젝트 완성을 응원합니다! 🚀

---

**문서 버전**: 1.0.0  
**최종 수정일**: 2025-01-XX  
**작성자**: 개발팀  
**문서 위치**: `/TodayOneCut-ios/PROJECT_PLAN.md`

