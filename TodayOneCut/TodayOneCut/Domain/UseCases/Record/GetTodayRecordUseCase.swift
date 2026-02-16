//
//  GetTodayRecordUseCase.swift
//  TodayOneCut
//
//  Created by 신준우 on 2/13/26.
//

import Foundation

/// 오늘의 기록 조회 Use Case
class GetTodayRecordUseCase {
    private let recordRepository: RecordRepository
    
    init(recordRepository: RecordRepository) {
        self.recordRepository = recordRepository
    }
    
    /// 오늘의 기록 조회
    /// - Returns: 오늘의 기록 또는 nil
    func execute() async throws -> Record? {
        let today = DateTimeUtils.todayInKorea()
        return try await recordRepository.getRecordByDate(today)
    }
}

