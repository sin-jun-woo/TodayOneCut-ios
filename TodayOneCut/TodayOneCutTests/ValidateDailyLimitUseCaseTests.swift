//
//  ValidateDailyLimitUseCaseTests.swift
//  TodayOneCutTests
//
//  Created by 신준우 on 2/13/26.
//

import XCTest
import Combine
@testable import TodayOneCut

/// 일일 기록 제한 검증 Use Case 테스트
@MainActor
final class ValidateDailyLimitUseCaseTests: XCTestCase {
    var useCase: ValidateDailyLimitUseCase!
    var mockRepository: MockRecordRepository!
    
    override func setUp() {
        super.setUp()
        mockRepository = MockRecordRepository()
        useCase = ValidateDailyLimitUseCase(recordRepository: mockRepository)
    }
    
    override func tearDown() {
        useCase = nil
        mockRepository = nil
        super.tearDown()
    }
    
    /// 기록이 없는 날짜는 통과해야 함
    func testExecute_WhenNoRecordExists_ShouldNotThrow() async {
        // Given
        let date = Date()
        mockRepository.recordExistsResult = false
        
        // When & Then
        do {
            try await useCase.execute(date: date)
            // 통과
        } catch {
            XCTFail("기록이 없을 때는 에러가 발생하면 안 됩니다. 에러: \(error)")
        }
    }
    
    /// 기록이 있는 날짜는 에러를 던져야 함
    func testExecute_WhenRecordExists_ShouldThrowDailyLimitExceeded() async {
        // Given
        let date = Date()
        mockRepository.recordExistsResult = true
        
        // When & Then
        do {
            try await useCase.execute(date: date)
            XCTFail("기록이 있을 때는 에러가 발생해야 합니다.")
        } catch let error as TodayOneCutError {
            // DailyLimitExceeded 에러인지 확인
            if case .dailyLimitExceeded = error {
                // 성공
            } else {
                XCTFail("DailyLimitExceeded 에러가 아닙니다. 에러: \(error)")
            }
        } catch {
            XCTFail("예상하지 못한 에러: \(error)")
        }
    }
}

/// Mock RecordRepository
class MockRecordRepository: RecordRepository {
    var recordExistsResult: Bool = false
    var createRecordResult: Record?
    var getAllRecordsResult: [Record] = []
    
    func recordExistsForDate(_ date: Date) async throws -> Bool {
        return recordExistsResult
    }
    
    func createRecord(_ record: Record) async throws -> Record {
        if let result = createRecordResult {
            return result
        }
        return record
    }
    
    func getAllRecords() -> AnyPublisher<[Record], Never> {
        return Just(getAllRecordsResult).eraseToAnyPublisher()
    }
    
    // 나머지 메서드는 기본 구현 (필요시 추가)
    func getRecordByDate(_ date: Date) async throws -> Record? { return nil }
    func getRecordById(_ id: Int64) async throws -> Record? { return nil }
    func updateRecord(_ record: Record) async throws -> Record { return record }
    func deleteRecord(id: Int64) async throws {}
    func getRecordsPaged(page: Int, pageSize: Int) async throws -> [Record] { return [] }
    func getRecordsByMonth(_ yearMonth: String) async throws -> [Record] { return [] }
    func searchRecords(keyword: String) async throws -> [Record] { return [] }
    func getRecordDatesForMonth(_ yearMonth: String) async throws -> Set<Date> { return [] }
    func getTotalRecordCount() -> AnyPublisher<Int, Never> { return Just(0).eraseToAnyPublisher() }
    func deleteAllRecords() async throws {}
}

