//
//  EdgeCaseTests.swift
//  TodayOneCutTests
//
//  Created by 신준우 on 2/13/26.
//

import XCTest
@testable import TodayOneCut

/// 엣지 케이스 테스트
@MainActor
final class EdgeCaseTests: XCTestCase {
    var testCoreDataStack: TestCoreDataStack!
    var recordRepository: RecordRepositoryImpl!
    var recordMapper: RecordMapper!
    
    override func setUp() {
        super.setUp()
        testCoreDataStack = TestCoreDataStack()
        recordMapper = RecordMapper()
        recordRepository = RecordRepositoryImpl(
            coreDataStack: testCoreDataStack,
            recordMapper: recordMapper
        )
        testCoreDataStack.reset()
    }
    
    override func tearDown() {
        recordRepository = nil
        recordMapper = nil
        testCoreDataStack = nil
        super.tearDown()
    }
    
    /// 하루 1개 기록 제한 - 정확히 자정 경계 테스트
    func testDailyLimit_AtMidnightBoundary() async throws {
        // Given
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let tomorrow = calendar.date(byAdding: .day, value: 1, to: today)!
        
        let todayRecord = Record(
            date: today,
            type: .text,
            contentText: "오늘 기록",
            photoPath: nil,
            location: nil,
            createdAt: today
        )
        
        let tomorrowRecord = Record(
            date: tomorrow,
            type: .text,
            contentText: "내일 기록",
            photoPath: nil,
            location: nil,
            createdAt: tomorrow
        )
        
        // When
        _ = try await recordRepository.createRecord(todayRecord)
        _ = try await recordRepository.createRecord(tomorrowRecord)
        
        // Then
        let todayFetched = try await recordRepository.getRecordByDate(today)
        let tomorrowFetched = try await recordRepository.getRecordByDate(tomorrow)
        
        XCTAssertNotNil(todayFetched)
        XCTAssertNotNil(tomorrowFetched)
        XCTAssertEqual(todayFetched?.contentText, "오늘 기록")
        XCTAssertEqual(tomorrowFetched?.contentText, "내일 기록")
    }
    
    /// 수정 횟수 제한 - 정확히 1회 수정 후 실패
    func testUpdateLimit_ExactlyOneUpdate() async throws {
        // Given
        let today = Date()
        let record = Record(
            id: 1,
            date: today,
            type: .text,
            contentText: "원본",
            photoPath: nil,
            location: nil,
            createdAt: today,
            updatedAt: nil,
            updateCount: 0
        )
        
        // 첫 번째 수정 (성공해야 함)
        var updatedRecord = record
        updatedRecord = Record(
            id: record.id,
            date: record.date,
            type: record.type,
            contentText: "첫 수정",
            photoPath: record.photoPath,
            location: record.location,
            createdAt: record.createdAt,
            updatedAt: Date(),
            updateCount: 1
        )
        
        let validateUpdateLimit = ValidateUpdateLimitUseCase()
        
        // When & Then - 첫 번째 수정은 통과
        XCTAssertNoThrow(try validateUpdateLimit.execute(record: updatedRecord))
        
        // 두 번째 수정 시도 (실패해야 함)
        var secondUpdate = updatedRecord
        secondUpdate = Record(
            id: updatedRecord.id,
            date: updatedRecord.date,
            type: updatedRecord.type,
            contentText: "두 번째 수정",
            photoPath: updatedRecord.photoPath,
            location: updatedRecord.location,
            createdAt: updatedRecord.createdAt,
            updatedAt: Date(),
            updateCount: 2
        )
        
        XCTAssertThrowsError(try validateUpdateLimit.execute(record: secondUpdate)) { error in
            if case .updateLimitExceeded = error as? TodayOneCutError {
                // 성공
            } else {
                XCTFail("UpdateLimitExceeded 에러가 아닙니다.")
            }
        }
    }
    
    /// 과거 기록 수정 불가 - 어제 기록 수정 시도
    func testUpdatePastRecord_ShouldFail() async throws {
        // Given
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: Date())!
        let record = Record(
            id: 1,
            date: yesterday,
            type: .text,
            contentText: "어제 기록",
            photoPath: nil,
            location: nil,
            createdAt: yesterday,
            updatedAt: nil,
            updateCount: 0
        )
        
        let validateUpdateLimit = ValidateUpdateLimitUseCase()
        
        // When & Then
        XCTAssertThrowsError(try validateUpdateLimit.execute(record: record)) { error in
            if case .invalidDate = error as? TodayOneCutError {
                // 성공
            } else {
                XCTFail("InvalidDate 에러가 아닙니다.")
            }
        }
    }
    
    /// 빈 검색어 처리
    func testSearchRecords_WithEmptyKeyword_ShouldReturnEmpty() async throws {
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
        _ = try await recordRepository.createRecord(record)
        
        // When
        let results = try await recordRepository.searchRecords(keyword: "")
        
        // Then
        XCTAssertEqual(results.count, 0)
    }
    
    /// 공백만 있는 검색어 처리
    func testSearchRecords_WithWhitespaceOnly_ShouldReturnEmpty() async throws {
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
        _ = try await recordRepository.createRecord(record)
        
        // When
        let results = try await recordRepository.searchRecords(keyword: "   ")
        
        // Then
        XCTAssertEqual(results.count, 0)
    }
    
    /// 매우 긴 텍스트 입력 시도
    func testValidateContent_WithVeryLongText_ShouldFail() {
        // Given
        let longText = String(repeating: "a", count: Constants.Text.maxContentLength + 100)
        let validateContent = ValidateRecordContentUseCase()
        
        // When & Then
        XCTAssertThrowsError(try validateContent.execute(
            type: .text,
            contentText: longText,
            photoData: nil
        )) { error in
            if case .invalidContent = error as? TodayOneCutError {
                // 성공
            } else {
                XCTFail("InvalidContent 에러가 아닙니다.")
            }
        }
    }
    
    /// PHOTO 타입인데 사진이 없는 경우
    func testValidateContent_PhotoTypeWithoutPhoto_ShouldFail() {
        // Given
        let validateContent = ValidateRecordContentUseCase()
        
        // When & Then
        XCTAssertThrowsError(try validateContent.execute(
            type: .photo,
            contentText: nil,
            photoData: nil
        )) { error in
            if case .invalidContent = error as? TodayOneCutError {
                // 성공
            } else {
                XCTFail("InvalidContent 에러가 아닙니다.")
            }
        }
    }
    
    /// 존재하지 않는 기록 삭제 시도
    func testDeleteRecord_WhenRecordNotFound_ShouldThrowError() async {
        // Given
        let nonExistentId: Int64 = 99999
        
        // When & Then
        do {
            try await recordRepository.deleteRecord(id: nonExistentId)
            XCTFail("존재하지 않는 기록 삭제 시 에러가 발생해야 합니다.")
        } catch {
            // 에러 발생 확인
            XCTAssertNotNil(error)
        }
    }
}

