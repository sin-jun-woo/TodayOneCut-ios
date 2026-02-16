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


