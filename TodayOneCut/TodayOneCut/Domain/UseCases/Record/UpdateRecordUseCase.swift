//
//  UpdateRecordUseCase.swift
//  TodayOneCut
//
//  Created by 신준우 on 2/13/26.
//

import Foundation

/// 기록 수정 Use Case
class UpdateRecordUseCase {
    private let recordRepository: RecordRepository
    private let fileRepository: FileRepository
    private let validateUpdateLimit: ValidateUpdateLimitUseCase
    
    init(
        recordRepository: RecordRepository,
        fileRepository: FileRepository,
        validateUpdateLimit: ValidateUpdateLimitUseCase
    ) {
        self.recordRepository = recordRepository
        self.fileRepository = fileRepository
        self.validateUpdateLimit = validateUpdateLimit
    }
    
    /// 기록 수정
    /// - Parameters:
    ///   - record: 수정할 기록
    ///   - newPhotoData: 새 사진 데이터 (변경 시)
    /// - Returns: 수정된 기록
    func execute(
        record: Record,
        newPhotoData: Data? = nil
    ) async throws -> Record {
        // 수정 가능 여부 검증
        try validateUpdateLimit.execute(record: record)
        
        var updatedRecord = record
        var photoPath = record.photoPath
        
        // 새 사진이 있으면 저장
        if let newPhotoData = newPhotoData {
            // 기존 사진 삭제
            if let oldPath = record.photoPath {
                try? await fileRepository.deletePhoto(path: oldPath)
            }
            
            // 새 사진 압축 및 저장
            let compressedData = try await fileRepository.compressPhoto(newPhotoData)
            photoPath = try await fileRepository.savePhoto(compressedData, date: record.date)
        }
        
        // 레코드 업데이트
        updatedRecord = Record(
            id: record.id,
            date: record.date,
            type: record.type,
            contentText: record.contentText,
            photoPath: photoPath,
            location: record.location,
            createdAt: record.createdAt,
            updatedAt: Date(),
            updateCount: record.updateCount
        )
        
        return try await recordRepository.updateRecord(updatedRecord)
    }
}

