//
//  ValidateRecordContentUseCaseTests.swift
//  TodayOneCutTests
//
//  Created by 신준우 on 2/13/26.
//

import XCTest
@testable import TodayOneCut

/// 기록 내용 검증 Use Case 테스트
@MainActor
final class ValidateRecordContentUseCaseTests: XCTestCase {
    var useCase: ValidateRecordContentUseCase!
    
    override func setUp() {
        super.setUp()
        useCase = ValidateRecordContentUseCase()
    }
    
    override func tearDown() {
        useCase = nil
        super.tearDown()
    }
    
    /// 텍스트만 있는 경우 통과해야 함
    func testExecute_WhenTextOnly_ShouldNotThrow() throws {
        // Given
        let text = "테스트 텍스트"
        let photoData: Data? = nil
        
        // When & Then
        XCTAssertNoThrow(try useCase.execute(type: .text, contentText: text, photoData: photoData))
    }
    
    /// 사진만 있는 경우 통과해야 함
    func testExecute_WhenPhotoOnly_ShouldNotThrow() throws {
        // Given
        let text: String? = nil
        let photoData = Data("fake image data".utf8)
        
        // When & Then
        XCTAssertNoThrow(try useCase.execute(type: .photo, contentText: text, photoData: photoData))
    }
    
    /// 텍스트와 사진이 모두 있는 경우 통과해야 함
    func testExecute_WhenTextAndPhoto_ShouldNotThrow() throws {
        // Given
        let text = "테스트 텍스트"
        let photoData = Data("fake image data".utf8)
        
        // When & Then
        XCTAssertNoThrow(try useCase.execute(type: .photo, contentText: text, photoData: photoData))
    }
    
    /// 텍스트와 사진이 모두 없는 경우 에러를 던져야 함
    func testExecute_WhenNoTextAndNoPhoto_ShouldThrowInvalidContent() {
        // Given
        let text: String? = nil
        let photoData: Data? = nil
        
        // When & Then
        XCTAssertThrowsError(try useCase.execute(type: .text, contentText: text, photoData: photoData)) { error in
            if case .invalidContent = error as? TodayOneCutError {
                // 성공
            } else {
                XCTFail("InvalidContent 에러가 아닙니다.")
            }
        }
    }
    
    /// 빈 문자열 텍스트와 사진이 없는 경우 에러를 던져야 함
    func testExecute_WhenEmptyTextAndNoPhoto_ShouldThrowInvalidContent() {
        // Given
        let text = ""
        let photoData: Data? = nil
        
        // When & Then
        XCTAssertThrowsError(try useCase.execute(type: .text, contentText: text, photoData: photoData)) { error in
            if case .invalidContent = error as? TodayOneCutError {
                // 성공
            } else {
                XCTFail("InvalidContent 에러가 아닙니다.")
            }
        }
    }
}

