//
//  RecordRepositoryImpl.swift
//  TodayOneCut
//
//  Created by 신준우 on 2/13/26.
//

import Foundation
import CoreData
import Combine

/// RecordRepository 구현체
class RecordRepositoryImpl: RecordRepository {
    private let coreDataStack: CoreDataStack
    private let recordMapper: RecordMapper
    
    init(coreDataStack: CoreDataStack, recordMapper: RecordMapper) {
        self.coreDataStack = coreDataStack
        self.recordMapper = recordMapper
    }
    
    // MARK: - Create
    
    func createRecord(_ record: Record) async throws -> Record {
        let context = coreDataStack.viewContext
        
        // 중복 체크
        let exists = try await recordExistsForDate(record.date)
        if exists {
            throw TodayOneCutError.dailyLimitExceeded()
        }
        
        // ID 자동 생성 (가장 큰 ID + 1)
        let maxId = try await getMaxRecordId()
        let newId = maxId + 1
        
        let entity = recordMapper.toEntity(record, context: context)
        entity.id = newId
        
        try coreDataStack.saveContext()
        
        return recordMapper.toDomain(entity)
    }
    
    // MARK: - Read
    
    func getRecordByDate(_ date: Date) async throws -> Record? {
        let context = coreDataStack.viewContext
        let dateString = date.toLocalDateString()
        
        let fetchRequest: NSFetchRequest<RecordEntity> = RecordEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "recordDate == %@", dateString)
        fetchRequest.fetchLimit = 1
        
        let entities = try context.fetch(fetchRequest)
        return entities.first.map(recordMapper.toDomain)
    }
    
    func getRecordById(_ id: Int64) async throws -> Record? {
        let context = coreDataStack.viewContext
        
        let fetchRequest: NSFetchRequest<RecordEntity> = RecordEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %lld", id)
        fetchRequest.fetchLimit = 1
        
        let entities = try context.fetch(fetchRequest)
        return entities.first.map(recordMapper.toDomain)
    }
    
    func getAllRecords() -> AnyPublisher<[Record], Never> {
        let context = coreDataStack.viewContext
        
        // NotificationCenter를 Combine으로 변환
        return NotificationCenter.default.publisher(
            for: .NSManagedObjectContextDidSave,
            object: context
        )
        .map { _ in
            // Fetch records
            let fetchRequest: NSFetchRequest<RecordEntity> = RecordEntity.fetchRequest()
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: false)]
            
            do {
                let entities = try context.fetch(fetchRequest)
                return entities.map { self.recordMapper.toDomain($0) }
            } catch {
                return []
            }
        }
        .prepend({
            // 초기 값
            let fetchRequest: NSFetchRequest<RecordEntity> = RecordEntity.fetchRequest()
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: false)]
            
            do {
                let entities = try context.fetch(fetchRequest)
                return entities.map { self.recordMapper.toDomain($0) }
            } catch {
                return []
            }
        }())
        .eraseToAnyPublisher()
    }
    
    func getRecordsPaged(page: Int, pageSize: Int) async throws -> [Record] {
        let context = coreDataStack.viewContext
        
        let fetchRequest: NSFetchRequest<RecordEntity> = RecordEntity.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: false)]
        fetchRequest.fetchLimit = pageSize
        fetchRequest.fetchOffset = page * pageSize
        
        let entities = try context.fetch(fetchRequest)
        return entities.map(recordMapper.toDomain)
    }
    
    func getRecordsByMonth(_ yearMonth: String) async throws -> [Record] {
        let context = coreDataStack.viewContext
        
        let fetchRequest: NSFetchRequest<RecordEntity> = RecordEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "recordDate BEGINSWITH %@", yearMonth)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "recordDate", ascending: true)]
        
        let entities = try context.fetch(fetchRequest)
        return entities.map(recordMapper.toDomain)
    }
    
    func recordExistsForDate(_ date: Date) async throws -> Bool {
        let dateString = date.toLocalDateString()
        let record = try await getRecordByDate(date)
        return record != nil
    }
    
    // MARK: - Update
    
    func updateRecord(_ record: Record) async throws -> Record {
        let context = coreDataStack.viewContext
        
        guard let entity = try await getEntityById(record.id, context: context) else {
            throw TodayOneCutError.recordNotFound()
        }
        
        // 수정 횟수 체크
        if entity.updateCount >= Int32(Constants.Record.maxUpdateCount) {
            throw TodayOneCutError.updateLimitExceeded()
        }
        
        // 당일 기록인지 체크
        let today = Date()
        if !Calendar.current.isDate(record.date, inSameDayAs: today) {
            throw TodayOneCutError.invalidDate(message: "당일 기록만 수정할 수 있습니다")
        }
        
        // 업데이트
        entity.recordType = record.type.rawValue
        entity.contentText = record.contentText
        entity.photoPath = record.photoPath
        entity.latitude = record.location?.latitude ?? 0
        entity.longitude = record.location?.longitude ?? 0
        entity.locationName = record.location?.name
        entity.updatedAt = Date()
        entity.updateCount += 1
        
        try coreDataStack.saveContext()
        
        return recordMapper.toDomain(entity)
    }
    
    // MARK: - Delete
    
    func deleteRecord(id: Int64) async throws {
        let context = coreDataStack.viewContext
        
        guard let entity = try await getEntityById(id, context: context) else {
            throw TodayOneCutError.recordNotFound()
        }
        
        context.delete(entity)
        try coreDataStack.saveContext()
    }
    
    // MARK: - Count
    
    func getTotalRecordCount() -> AnyPublisher<Int, Never> {
        let context = coreDataStack.viewContext
        
        return NotificationCenter.default.publisher(
            for: .NSManagedObjectContextDidSave,
            object: context
        )
        .map { _ in
            let fetchRequest: NSFetchRequest<RecordEntity> = RecordEntity.fetchRequest()
            do {
                return try context.count(for: fetchRequest)
            } catch {
                return 0
            }
        }
        .prepend({
            let fetchRequest: NSFetchRequest<RecordEntity> = RecordEntity.fetchRequest()
            do {
                return try context.count(for: fetchRequest)
            } catch {
                return 0
            }
        }())
        .eraseToAnyPublisher()
    }
    
    // MARK: - Search
    
    func searchRecords(keyword: String) async throws -> [Record] {
        let context = coreDataStack.viewContext
        
        // 검색어가 비어있으면 빈 배열 반환
        let trimmedKeyword = keyword.trimmingCharacters(in: .whitespaces)
        guard !trimmedKeyword.isEmpty else {
            return []
        }
        
        let fetchRequest: NSFetchRequest<RecordEntity> = RecordEntity.fetchRequest()
        // contentText가 nil이 아니고 빈 문자열이 아니며 검색어를 포함하는 경우만 검색
        fetchRequest.predicate = NSPredicate(format: "contentText != nil AND contentText != '' AND contentText CONTAINS[cd] %@", trimmedKeyword)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: false)]
        
        let entities = try context.fetch(fetchRequest)
        let records = entities.map(recordMapper.toDomain)
        
        // 디버깅: 검색 결과 확인
        #if DEBUG
        print("🔍 검색어: '\(trimmedKeyword)'")
        print("🔍 검색 결과 개수: \(records.count)")
        for record in records {
            print("  - ID: \(record.id), contentText: '\(record.contentText ?? "nil")'")
        }
        #endif
        
        return records
    }
    
    // MARK: - Calendar
    
    func getRecordDatesForMonth(_ yearMonth: String) async throws -> Set<Date> {
        let records = try await getRecordsByMonth(yearMonth)
        return Set(records.map { $0.date.startOfDay })
    }
    
    // MARK: - Helper Methods
    
    private func getMaxRecordId() async throws -> Int64 {
        let context = coreDataStack.viewContext
        
        let fetchRequest: NSFetchRequest<RecordEntity> = RecordEntity.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending: false)]
        fetchRequest.fetchLimit = 1
        
        let entities = try context.fetch(fetchRequest)
        return entities.first?.id ?? 0
    }
    
    private func getEntityById(_ id: Int64, context: NSManagedObjectContext) async throws -> RecordEntity? {
        let fetchRequest: NSFetchRequest<RecordEntity> = RecordEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %lld", id)
        fetchRequest.fetchLimit = 1
        
        let entities = try context.fetch(fetchRequest)
        return entities.first
    }
    
    // MARK: - Delete All
    
    func deleteAllRecords() async throws {
        let context = coreDataStack.viewContext
        
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = RecordEntity.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        try context.execute(deleteRequest)
        try coreDataStack.saveContext()
    }
}

