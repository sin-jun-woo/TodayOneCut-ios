//
//  GetAllRecordsUseCase.swift
//  TodayOneCut
//
//  Created by 신준우 on 2/13/26.
//

import Foundation
import Combine

/// 모든 기록 조회 Use Case
class GetAllRecordsUseCase {
    private let recordRepository: RecordRepository
    
    init(recordRepository: RecordRepository) {
        self.recordRepository = recordRepository
    }
    
    /// 모든 기록 조회 (실시간 업데이트)
    /// - Returns: 기록 목록 Publisher
    func execute() -> AnyPublisher<[Record], Never> {
        return recordRepository.getAllRecords()
    }
}

