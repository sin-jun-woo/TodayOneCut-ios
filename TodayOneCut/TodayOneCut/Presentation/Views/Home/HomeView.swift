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
                    RecordCard(record: record) {
                        // TODO: 상세 화면으로 이동
                    }
                    .padding(.horizontal)
                } else {
                    EmptyStateView(
                        message: "아직 오늘의 장면을 남기지 않았어요",
                        actionText: "오늘의 장면 남기기",
                        action: {
                            // TODO: 작성 화면으로 이동
                        }
                    )
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
                Button {
                    // TODO: 설정 화면으로 이동
                } label: {
                    Image(systemName: "gearshape")
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

