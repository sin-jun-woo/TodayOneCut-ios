//
//  MockRecordRepository.swift
//  TodayOneCutTests
//
//  Created by 신준우 on 2/13/26.
//

import Foundation
import Combine
@testable import TodayOneCut

/// Mock RecordRepository
class MockRecordRepository: RecordRepository {
    var recordExistsResult: Bool = false
    var createRecordResult: Record?
    var getAllRecordsResult: [Record] = []
    var getRecordByIdResult: Record?
    var updateRecordResult: Record?
    var searchRecordsResult: [Record] = []
    var getRecordByDateResult: Record?
    
    func recordExistsForDate(_ date: Date) async throws -> Bool {
        return recordExistsResult
    }
    
    func createRecord(_ record: Record) async throws -> Record {
        if let result = createRecordResult {
            return result
        }
        // ID 자동 생성
        var newRecord = record
        if newRecord.id == 0 {
            newRecord = Record(
                id: Int64.random(in: 1...1000),
                date: record.date,
                type: record.type,
                contentText: record.contentText,
                photoPath: record.photoPath,
                location: record.location,
                createdAt: record.createdAt
            )
        }
        return newRecord
    }
    
    func getAllRecords() -> AnyPublisher<[Record], Never> {
        return Just(getAllRecordsResult).eraseToAnyPublisher()
    }
    
    func getRecordByDate(_ date: Date) async throws -> Record? {
        return getRecordByDateResult
    }
    
    func getRecordById(_ id: Int64) async throws -> Record? {
        return getRecordByIdResult
    }
    
    func updateRecord(_ record: Record) async throws -> Record {
        if let result = updateRecordResult {
            return result
        }
        return record
    }
    
    func deleteRecord(id: Int64) async throws {
        // Mock: 삭제 성공
    }
    
    func getRecordsPaged(page: Int, pageSize: Int) async throws -> [Record] {
        return []
    }
    
    func getRecordsByMonth(_ yearMonth: String) async throws -> [Record] {
        return []
    }
    
    func searchRecords(keyword: String) async throws -> [Record] {
        return searchRecordsResult
    }
    
    func getRecordDatesForMonth(_ yearMonth: String) async throws -> Set<Date> {
        return []
    }
    
    func getTotalRecordCount() -> AnyPublisher<Int, Never> {
        return Just(getAllRecordsResult.count).eraseToAnyPublisher()
    }
    
    func deleteAllRecords() async throws {
        getAllRecordsResult = []
    }
}

