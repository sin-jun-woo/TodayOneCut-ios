//
//  CalculateStreakUseCase.swift
//  TodayOneCut
//
//  Created by 신준우 on 2/13/26.
//

import Foundation
import Combine

/// 연속 기록 일수 계산 Use Case
class CalculateStreakUseCase {
    private let recordRepository: RecordRepository
    
    init(recordRepository: RecordRepository) {
        self.recordRepository = recordRepository
    }
    
    /// 현재 연속 기록 일수 계산
    /// - Returns: 연속 기록 일수 (오늘부터 역순으로 계산)
    func execute() async throws -> Int {
        let allRecords = try await getAllRecordsSorted()
        
        guard !allRecords.isEmpty else {
            return 0
        }
        
        var calendar = Calendar.current
        calendar.timeZone = DateTimeUtils.koreaTimeZone
        var streak = 0
        var expectedDate = DateTimeUtils.todayInKorea()
        
        // 오늘 기록이 있으면 streak 시작
        if let firstRecord = allRecords.first,
           calendar.isDate(firstRecord.date, inSameDayAs: expectedDate) {
            streak = 1
            expectedDate = calendar.date(byAdding: .day, value: -1, to: expectedDate) ?? expectedDate
        } else {
            // 오늘 기록이 없으면 streak = 0
            return 0
        }
        
        // 어제부터 역순으로 연속 기록 확인
        for record in allRecords.dropFirst() {
            let recordDate = record.date.startOfDay
            
            // 예상 날짜와 일치하면 streak 증가
            if calendar.isDate(recordDate, inSameDayAs: expectedDate) {
                streak += 1
                expectedDate = calendar.date(byAdding: .day, value: -1, to: expectedDate) ?? expectedDate
            } else if recordDate < expectedDate {
                // 기록 날짜가 예상 날짜보다 이전이면 중단
                break
            }
            // 기록 날짜가 예상 날짜보다 이후면 계속 찾기 (skip)
        }
        
        return streak
    }
    
    /// 모든 기록을 날짜 역순으로 정렬하여 조회
    private func getAllRecordsSorted() async throws -> [Record] {
        // Publisher를 사용하여 첫 번째 값을 가져오기
        let allRecordsPublisher = recordRepository.getAllRecords()
        
        return try await withCheckedThrowingContinuation { continuation in
            var cancellable: AnyCancellable?
            cancellable = allRecordsPublisher
                .first()
                .sink(
                    receiveCompletion: { completion in
                        if case .failure(let error) = completion {
                            continuation.resume(throwing: error)
                        }
                        cancellable?.cancel()
                    },
                    receiveValue: { records in
                        continuation.resume(returning: records)
                        cancellable?.cancel()
                    }
                )
        }
    }
}

