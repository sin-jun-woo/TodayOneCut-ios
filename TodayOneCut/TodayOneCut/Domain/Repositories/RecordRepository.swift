//
//  RecordRepository.swift
//  TodayOneCut
//
//  Created by 신준우 on 2/13/26.
//

import Foundation
import Combine

/// 기록 데이터 관리를 위한 저장소 프로토콜
protocol RecordRepository {
    
    /// 새로운 기록 생성
    /// - Parameter record: 생성할 기록 객체
    /// - Returns: 생성된 기록 (ID 포함)
    /// - Throws: DailyLimitExceededError 같은 날짜에 이미 기록이 존재하는 경우
    func createRecord(_ record: Record) async throws -> Record
    
    /// 특정 날짜의 기록 조회
    /// - Parameter date: 조회할 날짜
    /// - Returns: 기록이 존재하면 반환, 없으면 nil
    func getRecordByDate(_ date: Date) async throws -> Record?
    
    /// ID로 기록 조회
    /// - Parameter id: 기록 ID
    /// - Returns: 기록이 존재하면 반환, 없으면 nil
    func getRecordById(_ id: Int64) async throws -> Record?
    
    /// 모든 기록 조회 (시간 역순)
    /// - Returns: 실시간 업데이트되는 기록 목록 (Publisher)
    func getAllRecords() -> AnyPublisher<[Record], Never>
    
    /// 페이지네이션된 기록 조회
    /// - Parameters:
    ///   - page: 페이지 번호 (0부터 시작)
    ///   - pageSize: 페이지당 항목 수
    /// - Returns: 해당 페이지의 기록 목록
    func getRecordsPaged(page: Int, pageSize: Int) async throws -> [Record]
    
    /// 특정 월의 모든 기록 조회 (달력용)
    /// - Parameter yearMonth: 조회할 년월 문자열 (yyyy-MM)
    /// - Returns: 해당 월의 기록 목록
    func getRecordsByMonth(_ yearMonth: String) async throws -> [Record]
    
    /// 특정 날짜에 기록이 존재하는지 확인
    /// - Parameter date: 확인할 날짜
    /// - Returns: 기록 존재 여부
    func recordExistsForDate(_ date: Date) async throws -> Bool
    
    /// 기록 수정
    /// - Parameter record: 수정할 기록 (ID 포함)
    /// - Returns: 수정된 기록
    /// - Throws: UpdateLimitExceededError 수정 횟수 초과
    /// - Throws: InvalidDateError 당일 기록이 아닌 경우
    func updateRecord(_ record: Record) async throws -> Record
    
    /// 기록 삭제
    /// - Parameter id: 삭제할 기록 ID
    /// - Throws: RecordNotFoundError 기록이 존재하지 않는 경우
    func deleteRecord(id: Int64) async throws
    
    /// 전체 기록 개수
    /// - Returns: 실시간 업데이트되는 총 기록 수 (Publisher)
    func getTotalRecordCount() -> AnyPublisher<Int, Never>
    
    /// 텍스트 검색
    /// - Parameter keyword: 검색 키워드
    /// - Returns: 검색 결과 목록
    func searchRecords(keyword: String) async throws -> [Record]
    
    /// 기록이 있는 날짜 목록 조회 (달력 표시용)
    /// - Parameter yearMonth: 조회할 년월 문자열 (yyyy-MM)
    /// - Returns: 기록이 있는 날짜 집합
    func getRecordDatesForMonth(_ yearMonth: String) async throws -> Set<Date>
    
    /// 모든 기록 삭제
    /// - Throws: 데이터베이스 오류
    func deleteAllRecords() async throws
}

