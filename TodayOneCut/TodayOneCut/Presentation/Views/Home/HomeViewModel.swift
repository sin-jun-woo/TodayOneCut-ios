//
//  HomeViewModel.swift
//  TodayOneCut
//
//  Created by 신준우 on 2/13/26.
//

import Foundation
import Combine

/// 홈 화면 ViewModel
@MainActor
class HomeViewModel: ObservableObject {
    @Published var uiState = HomeUiState()
    
    private let getTodayRecordUseCase: GetTodayRecordUseCase
    private let checkTodayRecordExistsUseCase: CheckTodayRecordExistsUseCase
    private let recordRepository: RecordRepository
    private let settingsRepository: SettingsRepository
    private var cancellables = Set<AnyCancellable>()
    
    init(
        getTodayRecordUseCase: GetTodayRecordUseCase,
        checkTodayRecordExistsUseCase: CheckTodayRecordExistsUseCase,
        recordRepository: RecordRepository,
        settingsRepository: SettingsRepository
    ) {
        self.getTodayRecordUseCase = getTodayRecordUseCase
        self.checkTodayRecordExistsUseCase = checkTodayRecordExistsUseCase
        self.recordRepository = recordRepository
        self.settingsRepository = settingsRepository
        
        observeTotalRecords()
    }
    
    /// 화면 로드
    func loadTodayRecord() {
        Task {
            uiState.isLoading = true
            uiState.errorMessage = nil
            
            do {
                let exists = try await checkTodayRecordExistsUseCase.execute()
                uiState.hasTodayRecord = exists
                
                if exists {
                    let record = try await getTodayRecordUseCase.execute()
                    uiState.todayRecord = record
                } else {
                    uiState.todayRecord = nil
                }
            } catch {
                uiState.errorMessage = (error as? TodayOneCutError)?.userMessage ?? "오류가 발생했습니다"
            }
            
            uiState.isLoading = false
        }
    }
    
    /// 총 기록 개수 관찰
    private func observeTotalRecords() {
        recordRepository.getTotalRecordCount()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] count in
                self?.uiState.totalRecords = count
                // Settings에도 업데이트 (캐시)
                Task {
                    try? await self?.settingsRepository.updateTotalRecords(count)
                }
            }
            .store(in: &cancellables)
    }
    
    /// 기록 새로고침
    func refresh() {
        loadTodayRecord()
    }
}

