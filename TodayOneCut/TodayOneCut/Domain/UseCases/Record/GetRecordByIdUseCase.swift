//
//  GetRecordByIdUseCase.swift
//  TodayOneCut
//
//  Created by 신준우 on 2/13/26.
//

import Foundation

/// ID로 기록 조회 Use Case
class GetRecordByIdUseCase {
    private let recordRepository: RecordRepository
    
    init(recordRepository: RecordRepository) {
        self.recordRepository = recordRepository
    }
    
    /// ID로 기록 조회
    /// - Parameter id: 기록 ID
    /// - Returns: 기록 또는 nil
    /// - Throws: RecordNotFoundError 기록이 존재하지 않는 경우
    func execute(id: Int64) async throws -> Record {
        guard let record = try await recordRepository.getRecordById(id) else {
            throw TodayOneCutError.recordNotFound()
        }
        return record
    }
}

