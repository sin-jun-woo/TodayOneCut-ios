//
//  DeleteRecordUseCase.swift
//  TodayOneCut
//
//  Created by 신준우 on 2/13/26.
//

import Foundation

/// 기록 삭제 Use Case
class DeleteRecordUseCase {
    private let recordRepository: RecordRepository
    private let fileRepository: FileRepository
    
    init(
        recordRepository: RecordRepository,
        fileRepository: FileRepository
    ) {
        self.recordRepository = recordRepository
        self.fileRepository = fileRepository
    }
    
    /// 기록 삭제
    /// - Parameter id: 삭제할 기록 ID
    /// - Throws: RecordNotFoundError 기록이 존재하지 않는 경우
    func execute(id: Int64) async throws {
        // 기록 조회
        guard let record = try await recordRepository.getRecordById(id) else {
            throw TodayOneCutError.recordNotFound()
        }
        
        // 사진 삭제
        if let photoPath = record.photoPath {
            try? await fileRepository.deletePhoto(path: photoPath)
        }
        
        // 기록 삭제
        try await recordRepository.deleteRecord(id: id)
    }
}

