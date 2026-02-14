//
//  ValidateRecordContentUseCase.swift
//  TodayOneCut
//
//  Created by 신준우 on 2/13/26.
//

import Foundation

/// 기록 내용 유효성 검증 Use Case
class ValidateRecordContentUseCase {
    
    /// 기록 내용이 유효한지 검증
    /// - Parameters:
    ///   - type: 기록 타입
    ///   - contentText: 텍스트 내용
    ///   - photoData: 사진 데이터
    /// - Throws: InvalidContentError 내용이 비어있거나 유효하지 않음
    func execute(
        type: RecordType,
        contentText: String?,
        photoData: Data?
    ) throws {
        // 사진 또는 텍스트 중 하나는 있어야 함
        let hasPhoto = photoData != nil && !photoData!.isEmpty
        let hasText = contentText != nil && !contentText!.isEmpty
        
        if !hasPhoto && !hasText {
            throw TodayOneCutError.invalidContent()
        }
        
        // 텍스트 길이 체크
        if let text = contentText, text.count > Constants.Text.maxContentLength {
            throw TodayOneCutError.invalidContent(
                message: "텍스트는 최대 \(Constants.Text.maxContentLength)자까지 입력할 수 있습니다"
            )
        }
        
        // PHOTO 타입인데 사진이 없으면 에러
        if type == .photo && !hasPhoto {
            throw TodayOneCutError.invalidContent(message: "사진 타입은 사진이 필요합니다")
        }
    }
}

