//
//  CreateRecordUseCaseTests.swift
//  TodayOneCutTests
//
//  Created by 신준우 on 2/13/26.
//

import XCTest
import Combine
@testable import TodayOneCut

/// 기록 생성 Use Case 테스트
@MainActor
final class CreateRecordUseCaseTests: XCTestCase {
    var useCase: CreateRecordUseCase!
    var mockRecordRepository: MockRecordRepository!
    var mockFileRepository: MockFileRepository!
    var validateDailyLimit: ValidateDailyLimitUseCase!
    var validateDate: ValidateDateUseCase!
    var validateContent: ValidateRecordContentUseCase!
    
    override func setUp() {
        super.setUp()
        mockRecordRepository = MockRecordRepository()
        mockFileRepository = MockFileRepository()
        validateDailyLimit = ValidateDailyLimitUseCase(recordRepository: mockRecordRepository)
        validateDate = ValidateDateUseCase()
        validateContent = ValidateRecordContentUseCase()
        
        useCase = CreateRecordUseCase(
            recordRepository: mockRecordRepository,
            fileRepository: mockFileRepository,
            validateDailyLimit: validateDailyLimit,
            validateDate: validateDate,
            validateContent: validateContent
        )
    }
    
    override func tearDown() {
        useCase = nil
        mockRecordRepository = nil
        mockFileRepository = nil
        validateDailyLimit = nil
        validateDate = nil
        validateContent = nil
        super.tearDown()
    }
    
    /// 텍스트 기록 생성 성공
    func testExecute_WhenTextRecord_ShouldCreateSuccessfully() async throws {
        // Given
        mockRecordRepository.recordExistsResult = false
        let text = "테스트 텍스트"
        
        // When
        let record = try await useCase.execute(
            type: .text,
            contentText: text,
            photoData: nil,
            location: nil
        )
        
        // Then
        XCTAssertEqual(record.type, .text)
        XCTAssertEqual(record.contentText, text)
        XCTAssertNil(record.photoPath)
    }
    
    /// 사진 기록 생성 성공
    func testExecute_WhenPhotoRecord_ShouldCreateSuccessfully() async throws {
        // Given
        mockRecordRepository.recordExistsResult = false
        let photoData = Data("fake image data".utf8)
        mockFileRepository.compressPhotoResult = photoData
        mockFileRepository.savePhotoResult = "/path/to/photo.webp"
        
        // When
        let record = try await useCase.execute(
            type: .photo,
            contentText: nil,
            photoData: photoData,
            location: nil
        )
        
        // Then
        XCTAssertEqual(record.type, .photo)
        XCTAssertNotNil(record.photoPath)
    }
    
    /// 하루 1개 기록 제한 테스트
    func testExecute_WhenRecordExists_ShouldThrowDailyLimitExceeded() async {
        // Given
        mockRecordRepository.recordExistsResult = true
        let text = "두 번째 기록"
        
        // When & Then
        do {
            _ = try await useCase.execute(
                type: .text,
                contentText: text,
                photoData: nil,
                location: nil
            )
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
    
    /// 내용이 없는 경우 에러 발생
    func testExecute_WhenNoContent_ShouldThrowInvalidContent() async {
        // Given
        mockRecordRepository.recordExistsResult = false
        
        // When & Then
        do {
            _ = try await useCase.execute(
                type: .text,
                contentText: nil,
                photoData: nil,
                location: nil
            )
            XCTFail("내용이 없으면 에러가 발생해야 합니다.")
        } catch let error as TodayOneCutError {
            if case .invalidContent = error {
                // 성공
            } else {
                XCTFail("InvalidContent 에러가 아닙니다. 에러: \(error)")
            }
        } catch {
            XCTFail("예상하지 못한 에러: \(error)")
        }
    }
}


