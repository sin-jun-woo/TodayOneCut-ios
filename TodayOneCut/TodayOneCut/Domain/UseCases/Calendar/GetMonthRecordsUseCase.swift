//
//  GetMonthRecordsUseCase.swift
//  TodayOneCut
//
//  Created by 신준우 on 2/13/26.
//

import Foundation

/// 특정 월의 기록 조회 Use Case
class GetMonthRecordsUseCase {
    private let recordRepository: RecordRepository
    
    init(recordRepository: RecordRepository) {
        self.recordRepository = recordRepository
    }
    
    /// 특정 월의 기록 조회
    /// - Parameter date: 해당 월의 아무 날짜
    /// - Returns: 해당 월의 기록 목록
    func execute(date: Date) async throws -> [Record] {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM"
        formatter.locale = Locale(identifier: "ko_KR")
        let yearMonth = formatter.string(from: date)
        
        return try await recordRepository.getRecordsByMonth(yearMonth)
    }
}

