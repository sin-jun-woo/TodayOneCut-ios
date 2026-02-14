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
    
    private let getRecordByIdUseCase: GetRecordByIdUseCase
    private let deleteRecordUseCase: DeleteRecordUseCase
    private let recordId: Int64
    
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
        Task {
            isLoading = true
            errorMessage = nil
            
            do {
                record = try await getRecordByIdUseCase.execute(id: recordId)
            } catch {
                errorMessage = (error as? TodayOneCutError)?.userMessage ?? "기록을 불러올 수 없습니다"
            }
            
            isLoading = false
        }
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
            errorMessage = (error as? TodayOneCutError)?.userMessage ?? "기록 삭제에 실패했습니다"
            return false
        }
    }
}

