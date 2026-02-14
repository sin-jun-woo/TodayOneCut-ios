//
//  ValidateDateUseCase.swift
//  TodayOneCut
//
//  Created by 신준우 on 2/13/26.
//

import Foundation

/// 날짜 유효성 검증 Use Case
class ValidateDateUseCase {
    
    /// 날짜가 오늘인지 검증
    /// - Parameter date: 검증할 날짜
    /// - Throws: InvalidDateError 과거/미래 날짜인 경우
    func execute(date: Date) throws {
        let today = Date()
        let calendar = Calendar.current
        
        if calendar.compare(date, to: today, toGranularity: .day) == .orderedDescending {
            throw TodayOneCutError.invalidDate(message: "미래 날짜는 기록할 수 없습니다")
        }
        
        if calendar.compare(date, to: today, toGranularity: .day) == .orderedAscending {
            throw TodayOneCutError.invalidDate(message: "과거 날짜는 기록할 수 없습니다")
        }
    }
}

