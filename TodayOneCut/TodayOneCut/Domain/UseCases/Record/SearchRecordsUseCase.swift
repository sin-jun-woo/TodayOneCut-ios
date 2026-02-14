//
//  SearchRecordsUseCase.swift
//  TodayOneCut
//
//  Created by 신준우 on 2/13/26.
//

import Foundation

/// 기록 검색 Use Case
class SearchRecordsUseCase {
    private let recordRepository: RecordRepository
    
    init(recordRepository: RecordRepository) {
        self.recordRepository = recordRepository
    }
    
    /// 기록 검색
    /// - Parameter keyword: 검색 키워드
    /// - Returns: 검색 결과 목록
    func execute(keyword: String) async throws -> [Record] {
        guard !keyword.trimmingCharacters(in: .whitespaces).isEmpty else {
            return []
        }
        
        return try await recordRepository.searchRecords(keyword: keyword)
    }
}

