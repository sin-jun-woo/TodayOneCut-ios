//
//  GetRecordDatesUseCase.swift
//  TodayOneCut
//
//  Created by 신준우 on 2/13/26.
//

import Foundation

/// 기록이 있는 날짜 목록 조회 Use Case (달력 표시용)
class GetRecordDatesUseCase {
    private let recordRepository: RecordRepository
    
    init(recordRepository: RecordRepository) {
        self.recordRepository = recordRepository
    }
    
    /// 특정 월에 기록이 있는 날짜 목록 조회
    /// - Parameter date: 해당 월의 아무 날짜
    /// - Returns: 기록이 있는 날짜 집합
    func execute(date: Date) async throws -> Set<Date> {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM"
        formatter.locale = Locale(identifier: "ko_KR")
        let yearMonth = formatter.string(from: date)
        
        return try await recordRepository.getRecordDatesForMonth(yearMonth)
    }
}

