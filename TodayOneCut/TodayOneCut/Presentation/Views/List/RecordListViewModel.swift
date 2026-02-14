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
    @Published var searchText: String = ""
    @Published var isSearching: Bool = false
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    private let getAllRecordsUseCase: GetAllRecordsUseCase
    private let searchRecordsUseCase: SearchRecordsUseCase
    private var cancellables = Set<AnyCancellable>()
    
    init(
        getAllRecordsUseCase: GetAllRecordsUseCase,
        searchRecordsUseCase: SearchRecordsUseCase
    ) {
        self.getAllRecordsUseCase = getAllRecordsUseCase
        self.searchRecordsUseCase = searchRecordsUseCase
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
    
    /// 검색 실행
    func performSearch() {
        guard !searchText.trimmingCharacters(in: .whitespaces).isEmpty else {
            loadRecords()
            return
        }
        
        isSearching = true
        isLoading = true
        
        Task {
            do {
                records = try await searchRecordsUseCase.execute(keyword: searchText)
                isLoading = false
                isSearching = false
            } catch {
                errorMessage = (error as? TodayOneCutError)?.userMessage ?? "검색에 실패했습니다"
                isLoading = false
                isSearching = false
            }
        }
    }
    
    /// 검색 취소
    func cancelSearch() {
        searchText = ""
        isSearching = false
        loadRecords()
    }
}

