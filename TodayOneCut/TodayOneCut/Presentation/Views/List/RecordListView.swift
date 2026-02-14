//
//  RecordListView.swift
//  TodayOneCut
//
//  Created by 신준우 on 2/13/26.
//

import SwiftUI

/// 기록 목록 화면
struct RecordListView: View {
    @StateObject private var viewModel: RecordListViewModel
    
    init(viewModel: RecordListViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        Group {
            if viewModel.isLoading {
                LoadingView()
            } else if viewModel.records.isEmpty {
                EmptyStateView(
                    message: "아직 기록이 없어요",
                    actionText: nil,
                    action: nil
                )
            } else {
                List {
                    ForEach(viewModel.records) { record in
                        NavigationLink(value: AppRoute.detail(recordId: record.id)) {
                            RecordCard(record: record)
                                .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                        }
                    }
                }
                .listStyle(.plain)
            }
        }
        .navigationTitle("기록 목록")
        .navigationBarTitleDisplayMode(.large)
        .onAppear {
            viewModel.loadRecords()
        }
        .refreshable {
            viewModel.loadRecords()
        }
    }
}

#Preview {
    NavigationStack {
        RecordListView(
            viewModel: RecordListViewModel(
                getAllRecordsUseCase: GetAllRecordsUseCase(
                    recordRepository: RecordRepositoryImpl(
                        coreDataStack: CoreDataStack.shared,
                        recordMapper: RecordMapper()
                    )
                )
            )
        )
    }
}

