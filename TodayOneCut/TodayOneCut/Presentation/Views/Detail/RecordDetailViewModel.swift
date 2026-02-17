//
//  RecordDetailViewModel.swift
//  TodayOneCut
//
//  Created by 신준우 on 2/13/26.
//

import Foundation
import Combine

/// 기록 상세 화면 ViewModel
@MainActor
class RecordDetailViewModel: ObservableObject {
    @Published var record: Record?
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var toastMessage: String?
    
    private let getRecordByIdUseCase: GetRecordByIdUseCase
    private let deleteRecordUseCase: DeleteRecordUseCase
    private let recordId: Int64
    private var loadTask: Task<Void, Never>?
    
    init(
        recordId: Int64,
        getRecordByIdUseCase: GetRecordByIdUseCase,
        deleteRecordUseCase: DeleteRecordUseCase
    ) {
        self.recordId = recordId
        self.getRecordByIdUseCase = getRecordByIdUseCase
        self.deleteRecordUseCase = deleteRecordUseCase
    }
    
    /// 기록 로드
    func loadRecord() {
        loadTask?.cancel()
        
        loadTask = Task {
            isLoading = true
            errorMessage = nil
            
            do {
                record = try await getRecordByIdUseCase.execute(id: recordId)
                try Task.checkCancellation()
            } catch {
                if !Task.isCancelled {
                    let message = (error as? TodayOneCutError)?.userMessage ?? "기록을 불러올 수 없습니다"
                    errorMessage = message
                    toastMessage = message
                }
            }
            
            if !Task.isCancelled {
                isLoading = false
            }
        }
    }
    
    deinit {
        loadTask?.cancel()
    }
    
    /// 기록 삭제
    func deleteRecord() async -> Bool {
        isLoading = true
        errorMessage = nil
        
        do {
            try await deleteRecordUseCase.execute(id: recordId)
            isLoading = false
            return true
        } catch {
            isLoading = false
            let message = (error as? TodayOneCutError)?.userMessage ?? "기록 삭제에 실패했습니다"
            errorMessage = message
            toastMessage = message
            return false
        }
    }
}

