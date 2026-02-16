//
//  UpdateRecordUseCaseTests.swift
//  TodayOneCutTests
//
//  Created by 신준우 on 2/13/26.
//

import XCTest
@testable import TodayOneCut

/// 기록 수정 Use Case 테스트
@MainActor
final class UpdateRecordUseCaseTests: XCTestCase {
    var useCase: UpdateRecordUseCase!
    var mockRecordRepository: MockRecordRepository!
    var mockFileRepository: MockFileRepository!
    var validateUpdateLimit: ValidateUpdateLimitUseCase!
    
    override func setUp() {
        super.setUp()
        mockRecordRepository = MockRecordRepository()
        mockFileRepository = MockFileRepository()
        validateUpdateLimit = ValidateUpdateLimitUseCase()
        
        useCase = UpdateRecordUseCase(
            recordRepository: mockRecordRepository,
            fileRepository: mockFileRepository,
            validateUpdateLimit: validateUpdateLimit
        )
    }
    
    override func tearDown() {
        useCase = nil
        mockRecordRepository = nil
        mockFileRepository = nil
        validateUpdateLimit = nil
        super.tearDown()
    }
    
    /// 당일 기록 수정 성공
    func testExecute_WhenTodayRecord_ShouldUpdateSuccessfully() async throws {
        // Given
        let today = Date()
        let record = Record(
            id: 1,
            date: today,
            type: .text,
            contentText: "원본 텍스트",
            photoPath: nil,
            location: nil,
            createdAt: today,
            updatedAt: nil,
            updateCount: 0
        )
        mockRecordRepository.updateRecordResult = record
        
        // When
        let updatedRecord = try await useCase.execute(
            record: record,
            newPhotoData: nil
        )
        
        // Then
        XCTAssertEqual(updatedRecord.id, record.id)
    }
    
    /// 수정 횟수 초과 시 에러 발생
    func testExecute_WhenUpdateCountExceeded_ShouldThrowUpdateLimitExceeded() async {
        // Given
        let today = Date()
        let record = Record(
            id: 1,
            date: today,
            type: .text,
            contentText: "원본 텍스트",
            photoPath: nil,
            location: nil,
            createdAt: today,
            updatedAt: today,
            updateCount: Constants.Record.maxUpdateCount
        )
        
        // When & Then
        do {
            _ = try await useCase.execute(record: record, newPhotoData: nil)
            XCTFail("수정 횟수 초과 시 에러가 발생해야 합니다.")
        } catch let error as TodayOneCutError {
            if case .updateLimitExceeded = error {
                // 성공
            } else {
                XCTFail("UpdateLimitExceeded 에러가 아닙니다. 에러: \(error)")
            }
        } catch {
            XCTFail("예상하지 못한 에러: \(error)")
        }
    }
    
    /// 과거 기록 수정 시 에러 발생
    func testExecute_WhenPastRecord_ShouldThrowInvalidDate() async {
        // Given
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: Date())!
        let record = Record(
            id: 1,
            date: yesterday,
            type: .text,
            contentText: "원본 텍스트",
            photoPath: nil,
            location: nil,
            createdAt: yesterday,
            updatedAt: nil,
            updateCount: 0
        )
        
        // When & Then
        do {
            _ = try await useCase.execute(record: record, newPhotoData: nil)
            XCTFail("과거 기록 수정 시 에러가 발생해야 합니다.")
        } catch let error as TodayOneCutError {
            if case .invalidDate = error {
                // 성공
            } else {
                XCTFail("InvalidDate 에러가 아닙니다. 에러: \(error)")
            }
        } catch {
            XCTFail("예상하지 못한 에러: \(error)")
        }
    }
}

