//
//  RecordRepositoryImplTests.swift
//  TodayOneCutTests
//
//  Created by 신준우 on 2/13/26.
//

import XCTest
import CoreData
import Combine
@testable import TodayOneCut

/// RecordRepositoryImpl 통합 테스트
@MainActor
final class RecordRepositoryImplTests: XCTestCase {
    var repository: RecordRepositoryImpl!
    var testCoreDataStack: TestCoreDataStack!
    var recordMapper: RecordMapper!
    
    override func setUp() {
        super.setUp()
        testCoreDataStack = TestCoreDataStack()
        recordMapper = RecordMapper()
        repository = RecordRepositoryImpl(
            coreDataStack: testCoreDataStack,
            recordMapper: recordMapper
        )
        testCoreDataStack.reset()
    }
    
    override func tearDown() {
        repository = nil
        recordMapper = nil
        testCoreDataStack = nil
        super.tearDown()
    }
    
    /// 기록 생성 성공
    func testCreateRecord_ShouldSucceed() async throws {
        // Given
        let today = Date()
        let record = Record(
            date: today,
            type: .text,
            contentText: "테스트 기록",
            photoPath: nil,
            location: nil,
            createdAt: today
        )
        
        // When
        let createdRecord = try await repository.createRecord(record)
        
        // Then
        XCTAssertNotNil(createdRecord.id)
        XCTAssertEqual(createdRecord.contentText, "테스트 기록")
        XCTAssertEqual(createdRecord.type, .text)
    }
    
    /// 하루 1개 기록 제한 테스트
    func testCreateRecord_WhenRecordExists_ShouldThrowDailyLimitExceeded() async {
        // Given
        let today = Date()
        let firstRecord = Record(
            date: today,
            type: .text,
            contentText: "첫 번째 기록",
            photoPath: nil,
            location: nil,
            createdAt: today
        )
        _ = try? await repository.createRecord(firstRecord)
        
        let secondRecord = Record(
            date: today,
            type: .text,
            contentText: "두 번째 기록",
            photoPath: nil,
            location: nil,
            createdAt: today
        )
        
        // When & Then
        do {
            _ = try await repository.createRecord(secondRecord)
            XCTFail("하루 1개 기록 제한이 적용되어야 합니다.")
        } catch let error as TodayOneCutError {
            if case .dailyLimitExceeded = error {
                // 성공
            } else {
                XCTFail("DailyLimitExceeded 에러가 아닙니다. 에러: \(error)")
            }
        } catch {
            XCTFail("예상하지 못한 에러: \(error)")
        }
    }
    
    /// 날짜별 기록 조회
    func testGetRecordByDate_WhenRecordExists_ShouldReturnRecord() async throws {
        // Given
        let today = Date()
        let record = Record(
            date: today,
            type: .text,
            contentText: "테스트 기록",
            photoPath: nil,
            location: nil,
            createdAt: today
        )
        let createdRecord = try await repository.createRecord(record)
        
        // When
        let fetchedRecord = try await repository.getRecordByDate(today)
        
        // Then
        XCTAssertNotNil(fetchedRecord)
        XCTAssertEqual(fetchedRecord?.id, createdRecord.id)
        XCTAssertEqual(fetchedRecord?.contentText, "테스트 기록")
    }
    
    /// 기록 존재 여부 확인
    func testRecordExistsForDate_WhenRecordExists_ShouldReturnTrue() async throws {
        // Given
        let today = Date()
        let record = Record(
            date: today,
            type: .text,
            contentText: "테스트 기록",
            photoPath: nil,
            location: nil,
            createdAt: today
        )
        _ = try await repository.createRecord(record)
        
        // When
        let exists = try await repository.recordExistsForDate(today)
        
        // Then
        XCTAssertTrue(exists)
    }
    
    /// 기록 삭제
    func testDeleteRecord_ShouldSucceed() async throws {
        // Given
        let today = Date()
        let record = Record(
            date: today,
            type: .text,
            contentText: "테스트 기록",
            photoPath: nil,
            location: nil,
            createdAt: today
        )
        let createdRecord = try await repository.createRecord(record)
        
        // When
        try await repository.deleteRecord(id: createdRecord.id!)
        
        // Then
        let fetchedRecord = try await repository.getRecordByDate(today)
        XCTAssertNil(fetchedRecord)
    }
    
    /// 모든 기록 조회
    func testGetAllRecords_ShouldReturnAllRecords() async throws {
        // Given
        let today = Date()
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: today)!
        
        let record1 = Record(
            date: today,
            type: .text,
            contentText: "오늘 기록",
            photoPath: nil,
            location: nil,
            createdAt: today
        )
        let record2 = Record(
            date: yesterday,
            type: .text,
            contentText: "어제 기록",
            photoPath: nil,
            location: nil,
            createdAt: yesterday
        )
        
        _ = try await repository.createRecord(record1)
        _ = try await repository.createRecord(record2)
        
        // When
        let expectation = expectation(description: "Get all records")
        var allRecords: [Record] = []
        
        repository.getAllRecords()
            .sink { records in
                allRecords = records
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        await fulfillment(of: [expectation], timeout: 1.0)
        
        // Then
        XCTAssertEqual(allRecords.count, 2)
        // 최신순 정렬 확인 (오늘이 먼저)
        XCTAssertEqual(allRecords.first?.contentText, "오늘 기록")
    }
    
    private var cancellables = Set<AnyCancellable>()
}

