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
        VStack(spacing: 0) {
            // 검색바 Card
            VStack(spacing: 0) {
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.secondary)
                    
                    TextField("기록 검색...", text: $viewModel.searchText)
                        .onSubmit {
                            viewModel.performSearch()
                        }
                        .onChange(of: viewModel.searchText) { newValue in
                            if newValue.isEmpty && !viewModel.isSearching {
                                viewModel.loadRecords()
                            }
                        }
                    
                    if !viewModel.searchText.isEmpty {
                        Button {
                            viewModel.searchText = ""
                            viewModel.loadRecords()
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.secondary)
                        }
                    }
                }
                .padding()
            }
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.systemBackground))
                    .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 2)
            )
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            
            // 기록 목록
            Group {
                if viewModel.isLoading {
                    LoadingView()
                } else if viewModel.records.isEmpty {
                    EmptyStateView(
                        message: viewModel.isSearching ? "찾으시는 순간이 없어요" : "아직 담은 순간이 없어요",
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
        }
        .navigationTitle("전체 기록")
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
                ),
                searchRecordsUseCase: SearchRecordsUseCase(
                    recordRepository: RecordRepositoryImpl(
                        coreDataStack: CoreDataStack.shared,
                        recordMapper: RecordMapper()
                    )
                )
            )
        )
    }
}

