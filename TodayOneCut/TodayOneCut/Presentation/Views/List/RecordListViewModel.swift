//
//  RecordListViewModel.swift
//  TodayOneCut
//
//  Created by 신준우 on 2/13/26.
//

import Foundation
import Combine

/// 기록 목록 화면 ViewModel
@MainActor
class RecordListViewModel: ObservableObject {
    @Published var records: [Record] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    private let getAllRecordsUseCase: GetAllRecordsUseCase
    private var cancellables = Set<AnyCancellable>()
    
    init(getAllRecordsUseCase: GetAllRecordsUseCase) {
        self.getAllRecordsUseCase = getAllRecordsUseCase
    }
    
    /// 기록 목록 로드
    func loadRecords() {
        isLoading = true
        errorMessage = nil
        
        getAllRecordsUseCase.execute()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] records in
                self?.records = records
                self?.isLoading = false
            }
            .store(in: &cancellables)
    }
    
    /// 기록 삭제
    func deleteRecord(at offsets: IndexSet) {
        // TODO: DeleteRecordUseCase 사용
    }
}

