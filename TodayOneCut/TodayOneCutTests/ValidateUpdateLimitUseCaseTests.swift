//
//  ValidateUpdateLimitUseCaseTests.swift
//  TodayOneCutTests
//
//  Created by 신준우 on 2/13/26.
//

import XCTest
@testable import TodayOneCut

/// 수정 횟수 제한 검증 Use Case 테스트
@MainActor
final class ValidateUpdateLimitUseCaseTests: XCTestCase {
    var useCase: ValidateUpdateLimitUseCase!
    
    override func setUp() {
        super.setUp()
        useCase = ValidateUpdateLimitUseCase()
    }
    
    override func tearDown() {
        useCase = nil
        super.tearDown()
    }
    
    /// 당일 기록이고 수정 횟수가 0이면 통과해야 함
    func testExecute_WhenTodayRecordAndNoUpdate_ShouldNotThrow() throws {
        // Given
        let today = Date()
        let record = Record(
            id: 1,
            date: today,
            type: .text,
            contentText: "테스트",
            photoPath: nil,
            location: nil,
            createdAt: today,
            updatedAt: nil,
            updateCount: 0
        )
        
        // When & Then
        XCTAssertNoThrow(try useCase.execute(record: record))
    }
    
    /// 수정 횟수가 최대치에 도달하면 에러를 던져야 함
    func testExecute_WhenUpdateCountReachedMax_ShouldThrowUpdateLimitExceeded() {
        // Given
        let today = Date()
        let record = Record(
            id: 1,
            date: today,
            type: .text,
            contentText: "테스트",
            photoPath: nil,
            location: nil,
            createdAt: today,
            updatedAt: today,
            updateCount: Constants.Record.maxUpdateCount
        )
        
        // When & Then
        XCTAssertThrowsError(try useCase.execute(record: record)) { error in
            if case .updateLimitExceeded = error as? TodayOneCutError {
                // 성공
            } else {
                XCTFail("UpdateLimitExceeded 에러가 아닙니다.")
            }
        }
    }
    
    /// 과거 기록은 수정할 수 없어야 함
    func testExecute_WhenPastRecord_ShouldThrowInvalidDate() {
        // Given
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: Date())!
        let record = Record(
            id: 1,
            date: yesterday,
            type: .text,
            contentText: "테스트",
            photoPath: nil,
            location: nil,
            createdAt: yesterday,
            updatedAt: nil,
            updateCount: 0
        )
        
        // When & Then
        XCTAssertThrowsError(try useCase.execute(record: record)) { error in
            if case .invalidDate = error as? TodayOneCutError {
                // 성공
            } else {
                XCTFail("InvalidDate 에러가 아닙니다.")
            }
        }
    }
}

