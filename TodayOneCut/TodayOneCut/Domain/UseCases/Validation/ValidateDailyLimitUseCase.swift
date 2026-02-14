//
//  ValidateDailyLimitUseCase.swift
//  TodayOneCut
//
//  Created by 신준우 on 2/13/26.
//

import Foundation

/// 일일 기록 제한 검증 Use Case
class ValidateDailyLimitUseCase {
    private let recordRepository: RecordRepository
    
    init(recordRepository: RecordRepository) {
        self.recordRepository = recordRepository
    }
    
    /// 날짜에 대한 일일 제한 검증
    /// - Parameter date: 확인할 날짜
    /// - Throws: DailyLimitExceededError 이미 기록이 존재하는 경우
    func execute(date: Date) async throws {
        let exists = try await recordRepository.recordExistsForDate(date)
        if exists {
            throw TodayOneCutError.dailyLimitExceeded()
        }
    }
}

