//
//  CreateRecordUseCase.swift
//  TodayOneCut
//
//  Created by 신준우 on 2/13/26.
//

import Foundation

/// 기록 생성 Use Case
class CreateRecordUseCase {
    private let recordRepository: RecordRepository
    private let fileRepository: FileRepository
    private let validateDailyLimit: ValidateDailyLimitUseCase
    private let validateDate: ValidateDateUseCase
    private let validateContent: ValidateRecordContentUseCase
    
    init(
        recordRepository: RecordRepository,
        fileRepository: FileRepository,
        validateDailyLimit: ValidateDailyLimitUseCase,
        validateDate: ValidateDateUseCase,
        validateContent: ValidateRecordContentUseCase
    ) {
        self.recordRepository = recordRepository
        self.fileRepository = fileRepository
        self.validateDailyLimit = validateDailyLimit
        self.validateDate = validateDate
        self.validateContent = validateContent
    }
    
    /// 기록 생성
    /// - Parameters:
    ///   - type: 기록 타입
    ///   - contentText: 텍스트 내용
    ///   - photoData: 사진 데이터
    ///   - location: 위치 정보
    /// - Returns: 생성된 기록
    func execute(
        type: RecordType,
        contentText: String?,
        photoData: Data?,
        location: Location?
    ) async throws -> Record {
        let today = Date()
        
        // 비즈니스 규칙 검증
        try validateDate.execute(date: today)
        try await validateDailyLimit.execute(date: today)
        try validateContent.execute(type: type, contentText: contentText, photoData: photoData)
        
        // 사진 저장 및 압축
        var photoPath: String? = nil
        if let photoData = photoData {
            let compressedData = try await fileRepository.compressPhoto(photoData)
            photoPath = try await fileRepository.savePhoto(compressedData, date: today)
        }
        
        // 레코드 생성
        let record = Record(
            date: today,
            type: type,
            contentText: contentText,
            photoPath: photoPath,
            location: location,
            createdAt: Date()
        )
        
        return try await recordRepository.createRecord(record)
    }
}

