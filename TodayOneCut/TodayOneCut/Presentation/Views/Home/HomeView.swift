//
//  HomeView.swift
//  TodayOneCut
//
//  Created by 신준우 on 2/13/26.
//

import SwiftUI

/// 홈 화면
struct HomeView: View {
    @StateObject private var viewModel: HomeViewModel
    @Environment(\.dismiss) private var dismiss
    
    init(viewModel: HomeViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                if viewModel.uiState.isLoading {
                    LoadingView()
                        .frame(height: 200)
                } else if let record = viewModel.uiState.todayRecord {
                    NavigationLink(value: AppRoute.detail(recordId: record.id)) {
                        RecordCard(record: record)
                    }
                    .padding(.horizontal)
                } else {
                    NavigationLink(value: AppRoute.create) {
                        EmptyStateView(
                            message: "아직 오늘의 장면을 남기지 않았어요",
                            actionText: "오늘의 장면 남기기",
                            action: nil
                        )
                    }
                    .padding(.horizontal)
                }
                
                // 에러 메시지
                if let errorMessage = viewModel.uiState.errorMessage {
                    Text(errorMessage)
                        .font(.caption)
                        .foregroundColor(.red)
                        .padding()
                }
            }
            .padding(.vertical)
        }
        .navigationTitle("오늘의 한 컷")
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink(value: AppRoute.create) {
                    Image(systemName: "plus.circle.fill")
                        .font(.title2)
                }
            }
        }
        .onAppear {
            viewModel.loadTodayRecord()
        }
        .refreshable {
            viewModel.refresh()
        }
    }
}

#Preview {
    NavigationStack {
        HomeView(
            viewModel: HomeViewModel(
                getTodayRecordUseCase: GetTodayRecordUseCase(
                    recordRepository: RecordRepositoryImpl(
                        coreDataStack: CoreDataStack.shared,
                        recordMapper: RecordMapper()
                    )
                ),
                checkTodayRecordExistsUseCase: CheckTodayRecordExistsUseCase(
                    recordRepository: RecordRepositoryImpl(
                        coreDataStack: CoreDataStack.shared,
                        recordMapper: RecordMapper()
                    )
                )
            )
        )
    }
}

