//
//  ValidateUpdateLimitUseCase.swift
//  TodayOneCut
//
//  Created by 신준우 on 2/13/26.
//

import Foundation

/// 수정 횟수 제한 검증 Use Case
class ValidateUpdateLimitUseCase {
    
    /// 기록의 수정 가능 여부 검증
    /// - Parameter record: 검증할 기록
    /// - Throws: UpdateLimitExceededError 수정 횟수 초과
    /// - Throws: InvalidDateError 당일 기록이 아님
    func execute(record: Record) throws {
        // 수정 횟수 체크
        if record.updateCount >= Constants.Record.maxUpdateCount {
            throw TodayOneCutError.updateLimitExceeded()
        }
        
        // 당일 기록인지 체크
        if !record.date.isToday {
            throw TodayOneCutError.invalidDate(message: "당일 기록만 수정할 수 있습니다")
        }
    }
}

