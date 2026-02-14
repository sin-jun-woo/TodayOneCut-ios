//
//  CalendarViewModel.swift
//  TodayOneCut
//
//  Created by 신준우 on 2/13/26.
//

import Foundation
import Combine

/// 달력 화면 ViewModel
@MainActor
class CalendarViewModel: ObservableObject {
    @Published var records: [Record] = []
    @Published var recordDates: Set<Date> = []
    @Published var selectedDate: Date = Date()
    @Published var selectedDateRecord: Record?
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    private let getMonthRecordsUseCase: GetMonthRecordsUseCase
    private let getRecordDatesUseCase: GetRecordDatesUseCase
    private let getRecordByDateUseCase: GetTodayRecordUseCase
    private let recordRepository: RecordRepository
    
    init(
        getMonthRecordsUseCase: GetMonthRecordsUseCase,
        getRecordDatesUseCase: GetRecordDatesUseCase,
        getRecordByDateUseCase: GetTodayRecordUseCase,
        recordRepository: RecordRepository
    ) {
        self.getMonthRecordsUseCase = getMonthRecordsUseCase
        self.getRecordDatesUseCase = getRecordDatesUseCase
        self.getRecordByDateUseCase = getRecordByDateUseCase
        self.recordRepository = recordRepository
    }
    
    /// 월 변경 시 기록 로드
    func loadRecordsForMonth(_ date: Date) {
        Task {
            isLoading = true
            errorMessage = nil
            
            do {
                records = try await getMonthRecordsUseCase.execute(date: date)
                recordDates = try await getRecordDatesUseCase.execute(date: date)
            } catch {
                errorMessage = (error as? TodayOneCutError)?.userMessage ?? "기록을 불러올 수 없습니다"
            }
            
            isLoading = false
        }
    }
    
    /// 날짜 선택 시 기록 로드
    func selectDate(_ date: Date) {
        selectedDate = date
        loadRecordForDate(date)
    }
    
    /// 특정 날짜의 기록 로드
    private func loadRecordForDate(_ date: Date) {
        Task {
            do {
                selectedDateRecord = try await recordRepository.getRecordByDate(date)
            } catch {
                selectedDateRecord = nil
            }
        }
    }
    
    /// 날짜에 기록이 있는지 확인
    func hasRecord(for date: Date) -> Bool {
        let dateString = date.toLocalDateString()
        return recordDates.contains { $0.toLocalDateString() == dateString }
    }
}

