# 데이터베이스 스키마

## 📊 개요

- **DB 엔진**: Core Data (SQLite 기반)
- **파일 위치**: 앱 샌드박스 내부
- **버전**: 1
- **마이그레이션**: 추후 버전업 시 정의

## 🗂️ 엔티티 구조

### 1. RecordEntity (기록 엔티티)

하루 하나의 기록을 저장하는 메인 엔티티

| 속성명 | 타입 | Optional | Default | 설명 |
|--------|------|----------|---------|------|
| id | Integer 64 | NO | - | 기본키 (자동 증가) |
| recordDate | String | NO | - | 기록 날짜 (yyyy-MM-dd 형식) |
| recordType | String | NO | - | 기록 타입 ('PHOTO' or 'TEXT') |
| contentText | String | YES | NULL | 텍스트 내용 (최대 500자) |
| photoPath | String | YES | NULL | 사진 파일 경로 (로컬) |
| latitude | Double | YES | NULL | 위도 (위치 권한 허용 시) |
| longitude | Double | YES | NULL | 경도 (위치 권한 허용 시) |
| locationName | String | YES | NULL | 위치 이름 (예: "서울특별시 강남구") |
| createdAt | Date | NO | - | 생성 시각 |
| updatedAt | Date | YES | NULL | 수정 시각 |
| updateCount | Integer 32 | NO | 0 | 수정 횟수 (최대 1회) |

#### 제약조건
- `recordDate`는 UNIQUE (하루에 하나만 기록 가능)
- `recordType`은 'PHOTO' 또는 'TEXT'만 허용
- `updateCount`는 최대 1

#### 인덱스
- `recordDate` (DESC)
- `createdAt` (DESC)

---

### 2. AppSettingsEntity (앱 설정 엔티티)

사용자 설정 및 앱 상태를 저장

| 속성명 | 타입 | Optional | Default | 설명 |
|--------|------|----------|---------|------|
| id | Integer 32 | NO | 1 | 기본키 (항상 1개 row만 존재) |
| enableLocation | Boolean | NO | NO | 위치 정보 저장 여부 |
| themeMode | String | NO | 'SYSTEM' | 테마 모드 ('LIGHT', 'DARK', 'SYSTEM') |
| firstLaunch | Boolean | NO | YES | 최초 실행 여부 |
| totalRecords | Integer 32 | NO | 0 | 총 기록 개수 (캐시용) |
| createdAt | Date | NO | - | 앱 최초 설치 시각 |
| updatedAt | Date | YES | NULL | 마지막 설정 변경 시각 |

#### 제약조건
- `id`는 항상 1 (단일 row만 허용)
- `themeMode`는 'LIGHT', 'DARK', 'SYSTEM'만 허용

---

## 🎯 Core Data Entity 정의 (Swift)

### Record Entity

```swift
import CoreData

@objc(RecordEntity)
public class RecordEntity: NSManagedObject {
    
}

extension RecordEntity {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<RecordEntity> {
        return NSFetchRequest<RecordEntity>(entityName: "RecordEntity")
    }
    
    @NSManaged public var id: Int64
    @NSManaged public var recordDate: String
    @NSManaged public var recordType: String
    @NSManaged public var contentText: String?
    @NSManaged public var photoPath: String?
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var locationName: String?
    @NSManaged public var createdAt: Date
    @NSManaged public var updatedAt: Date?
    @NSManaged public var updateCount: Int32
}

extension RecordEntity : Identifiable {
    
}
```

### AppSettings Entity

```swift
import CoreData

@objc(AppSettingsEntity)
public class AppSettingsEntity: NSManagedObject {
    
}

extension AppSettingsEntity {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<AppSettingsEntity> {
        return NSFetchRequest<AppSettingsEntity>(entityName: "AppSettingsEntity")
    }
    
    @NSManaged public var id: Int32
    @NSManaged public var enableLocation: Bool
    @NSManaged public var themeMode: String
    @NSManaged public var firstLaunch: Bool
    @NSManaged public var totalRecords: Int32
    @NSManaged public var createdAt: Date
    @NSManaged public var updatedAt: Date?
}

extension AppSettingsEntity : Identifiable {
    
}
```

---

## 🔧 Core Data Stack

```swift
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
    
    func saveContext() {
        let context = viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}
```

---

## 📁 파일 저장 구조

### 사진 파일 경로
```
Documents/photos/
    └── yyyy-MM-dd.jpg  (예: 2025-12-31.jpg)
```

### 규칙
- 파일명: `{record_date}.jpg`
- 하루에 하나의 사진만 저장
- 같은 날짜 덮어쓰기 시 기존 파일 삭제 후 저장
- 기록 삭제 시 해당 사진 파일도 함께 삭제

### 구현 예시

```swift
class FileRepositoryImpl: FileRepository {
    private let fileManager = FileManager.default
    
    func savePhoto(_ imageData: Data, date: Date) async throws -> String {
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
        
        try imageData.write(to: fileURL)
        return fileURL.path
    }
}
```

---

## 🚀 초기화 쿼리

### 최초 실행 시

```swift
func initializeDatabase(context: NSManagedObjectContext) throws {
    let fetchRequest: NSFetchRequest<AppSettingsEntity> = AppSettingsEntity.fetchRequest()
    fetchRequest.predicate = NSPredicate(format: "id == 1")
    
    let existingSettings = try context.fetch(fetchRequest).first
    
    if existingSettings == nil {
        let defaultSettings = AppSettingsEntity(context: context)
        defaultSettings.id = 1
        defaultSettings.enableLocation = false
        defaultSettings.themeMode = "SYSTEM"
        defaultSettings.firstLaunch = true
        defaultSettings.totalRecords = 0
        defaultSettings.createdAt = Date()
        
        try context.save()
    }
}
```

---

## 📊 데이터 정리 정책

### 자동 정리 (추후 검토)
- 기본적으로 모든 기록 영구 보관
- 사용자가 직접 삭제한 경우만 제거
- 사진 파일 용량 관리 (압축 등)

### 백업/복원
- JSON 형식으로 export
- 사진은 별도 폴더에 함께 저장
- import 시 날짜 중복 체크

---

## 📈 성능 최적화

### 인덱싱
- `recordDate`: 날짜 기반 조회 (가장 빈번)
- `createdAt`: 시간순 정렬

### 페이징
- 목록 조회 시 페이징 적용
- 한 페이지당 30개 기록

### 캐싱
- Combine을 통한 실시간 데이터 관찰
- 변경 시에만 UI 업데이트

---

## 🧪 테스트 데이터

### 개발용 샘플 데이터 삽입

```swift
func insertSampleData(context: NSManagedObjectContext) throws {
    let samples: [(date: Date, type: RecordType, content: String?)] = [
        (Date().addingTimeInterval(-86400), .text, "어제 기록"),
        (Date(), .photo, "오늘 기록")
    ]
    
    for sample in samples {
        let entity = RecordEntity(context: context)
        entity.id = Int64.random(in: 1...1000)
        entity.recordDate = sample.date.toLocalDateString()
        entity.recordType = sample.type.rawValue
        entity.contentText = sample.content
        entity.createdAt = sample.date
        entity.updateCount = 0
    }
    
    try context.save()
}
```

---

## 🔐 보안 고려사항

### 데이터 암호화
- **Phase 1 (MVP)**: 기본 Core Data (암호화 X)
- **Phase 2**: Core Data 암호화 옵션 검토

### 파일 보안
- 앱 전용 샌드박스 사용
- 다른 앱에서 접근 불가
- 백업 시에만 외부 저장소 사용 (권한 필요)

