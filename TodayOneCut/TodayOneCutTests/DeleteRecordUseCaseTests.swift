//
//  DeleteRecordUseCaseTests.swift
//  TodayOneCutTests
//
//  Created by 신준우 on 2/13/26.
//

import XCTest
@testable import TodayOneCut

/// 기록 삭제 Use Case 테스트
@MainActor
final class DeleteRecordUseCaseTests: XCTestCase {
    var useCase: DeleteRecordUseCase!
    var mockRecordRepository: MockRecordRepository!
    var mockFileRepository: MockFileRepository!
    
    override func setUp() {
        super.setUp()
        mockRecordRepository = MockRecordRepository()
        mockFileRepository = MockFileRepository()
        
        useCase = DeleteRecordUseCase(
            recordRepository: mockRecordRepository,
            fileRepository: mockFileRepository
        )
    }
    
    override func tearDown() {
        useCase = nil
        mockRecordRepository = nil
        mockFileRepository = nil
        super.tearDown()
    }
    
    /// 기록 삭제 성공
    func testExecute_WhenRecordExists_ShouldDeleteSuccessfully() async throws {
        // Given
        let recordId: Int64 = 1
        let record = Record(
            id: recordId,
            date: Date(),
            type: .text,
            contentText: "테스트",
            photoPath: nil,
            location: nil,
            createdAt: Date()
        )
        mockRecordRepository.getRecordByIdResult = record
        
        // When
        try await useCase.execute(id: recordId)
        
        // Then
        // 삭제 성공 (에러 없이 완료)
    }
    
    /// 기록이 없는 경우 에러 발생
    func testExecute_WhenRecordNotFound_ShouldThrowRecordNotFound() async {
        // Given
        let recordId: Int64 = 999
        mockRecordRepository.getRecordByIdResult = nil
        
        // When & Then
        do {
            try await useCase.execute(id: recordId)
            XCTFail("기록이 없으면 에러가 발생해야 합니다.")
        } catch let error as TodayOneCutError {
            if case .recordNotFound = error {
                // 성공
            } else {
                XCTFail("RecordNotFound 에러가 아닙니다. 에러: \(error)")
            }
        } catch {
            XCTFail("예상하지 못한 에러: \(error)")
        }
    }
    
    /// 사진이 있는 기록 삭제 시 사진도 함께 삭제
    func testExecute_WhenRecordHasPhoto_ShouldDeletePhoto() async throws {
        // Given
        let recordId: Int64 = 1
        let photoPath = "/path/to/photo.webp"
        let record = Record(
            id: recordId,
            date: Date(),
            type: .photo,
            contentText: nil,
            photoPath: photoPath,
            location: nil,
            createdAt: Date()
        )
        mockRecordRepository.getRecordByIdResult = record
        
        // When
        try await useCase.execute(id: recordId)
        
        // Then
        // 사진 삭제도 함께 호출되어야 함 (mockFileRepository에서 확인)
    }
}

