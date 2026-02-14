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
                    message: viewModel.isSearching ? "검색 결과가 없어요" : "아직 기록이 없어요",
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
        .navigationDestination(for: AppRoute.self) { route in
            switch route {
            case .detail(let id):
                RecordDetailView(recordId: id, viewModel: RecordDetailViewModel(
                    recordId: id,
                    getRecordByIdUseCase: GetRecordByIdUseCase(
                        recordRepository: RecordRepositoryImpl(
                            coreDataStack: CoreDataStack.shared,
                            recordMapper: RecordMapper()
                        )
                    ),
                    deleteRecordUseCase: DeleteRecordUseCase(
                        recordRepository: RecordRepositoryImpl(
                            coreDataStack: CoreDataStack.shared,
                            recordMapper: RecordMapper()
                        ),
                        fileRepository: FileRepositoryImpl()
                    )
                ))
            case .edit(let id):
                EditRecordView(recordId: id, viewModel: EditRecordViewModel(
                    recordId: id,
                    getRecordByIdUseCase: GetRecordByIdUseCase(
                        recordRepository: RecordRepositoryImpl(
                            coreDataStack: CoreDataStack.shared,
                            recordMapper: RecordMapper()
                        )
                    ),
                    updateRecordUseCase: UpdateRecordUseCase(
                        recordRepository: RecordRepositoryImpl(
                            coreDataStack: CoreDataStack.shared,
                            recordMapper: RecordMapper()
                        ),
                        fileRepository: FileRepositoryImpl(),
                        validateUpdateLimit: ValidateUpdateLimitUseCase()
                    ),
                    getSettingsUseCase: GetSettingsUseCase(
                        settingsRepository: SettingsRepositoryImpl(
                            coreDataStack: CoreDataStack.shared,
                            settingsMapper: SettingsMapper()
                        )
                    )
                ))
            default:
                EmptyView()
            }
        }
        .searchable(
            text: $viewModel.searchText,
            isPresented: $viewModel.isSearching,
            prompt: "기록 검색"
        )
        .onSubmit(of: .search) {
            viewModel.performSearch()
        }
        .onChange(of: viewModel.searchText) { newValue in
            if newValue.isEmpty && !viewModel.isSearching {
                viewModel.loadRecords()
            }
        }
        .onAppear {
            viewModel.loadRecords()
        }
        .refreshable {
            if viewModel.isSearching {
                viewModel.performSearch()
            } else {
                viewModel.loadRecords()
            }
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

