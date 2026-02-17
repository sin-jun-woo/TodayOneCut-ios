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
    private var searchTask: Task<Void, Never>?
    
    init(
        getAllRecordsUseCase: GetAllRecordsUseCase,
        searchRecordsUseCase: SearchRecordsUseCase
    ) {
        self.getAllRecordsUseCase = getAllRecordsUseCase
        self.searchRecordsUseCase = searchRecordsUseCase
    }
    
    /// 기록 목록 로드
    func loadRecords() {
        // 검색 중이면 전체 목록을 로드하지 않음
        guard !isSearching else {
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        getAllRecordsUseCase.execute()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] records in
                guard let self = self, !self.isSearching else { return }
                self.records = records
                self.isLoading = false
            }
            .store(in: &cancellables)
    }
    
    /// 검색 실행
    func performSearch() {
        let trimmedKeyword = searchText.trimmingCharacters(in: .whitespaces)
        
        guard !trimmedKeyword.isEmpty else {
            isSearching = false
            loadRecords()
            return
        }
        
        // 이전 검색 Task 취소
        searchTask?.cancel()
        
        // 검색 모드로 전환하고 즉시 빈 배열로 초기화
        isSearching = true
        isLoading = true
        errorMessage = nil
        records = [] // 검색 시작 전에 즉시 빈 배열로 설정
        
        searchTask = Task {
            do {
                let searchResults = try await searchRecordsUseCase.execute(keyword: trimmedKeyword)
                try Task.checkCancellation()
                await MainActor.run {
                    // 검색어가 여전히 같고 검색 중인지 확인
                    if self.searchText.trimmingCharacters(in: .whitespaces) == trimmedKeyword && self.isSearching {
                        // 검색 결과를 명확하게 할당 (0개여도 빈 배열로 표시)
                        self.records = searchResults
                        self.isLoading = false
                    }
                }
            } catch {
                if !Task.isCancelled {
                    await MainActor.run {
                        // 검색어가 여전히 같고 검색 중인지 확인
                        if self.searchText.trimmingCharacters(in: .whitespaces) == trimmedKeyword && self.isSearching {
                            self.errorMessage = (error as? TodayOneCutError)?.userMessage ?? "검색에 실패했습니다"
                            self.isLoading = false
                            self.isSearching = false
                            // 에러 발생 시에도 빈 배열로 표시
                            self.records = []
                        }
                    }
                }
            }
        }
    }
    
    deinit {
        searchTask?.cancel()
        cancellables.removeAll()
    }
    
    /// 검색 취소
    func cancelSearch() {
        searchText = ""
        isSearching = false
        loadRecords()
    }
}

