//
//  CheckTodayRecordExistsUseCase.swift
//  TodayOneCut
//
//  Created by 신준우 on 2/13/26.
//

import Foundation

/// 오늘 기록 존재 여부 확인 Use Case
class CheckTodayRecordExistsUseCase {
    private let recordRepository: RecordRepository
    
    init(recordRepository: RecordRepository) {
        self.recordRepository = recordRepository
    }
    
    /// 오늘 기록 존재 여부 확인
    /// - Returns: 기록 존재 여부
    func execute() async throws -> Bool {
        let today = Date()
        return try await recordRepository.recordExistsForDate(today)
    }
}

