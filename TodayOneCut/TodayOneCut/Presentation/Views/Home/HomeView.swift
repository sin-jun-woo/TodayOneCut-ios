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
    @Environment(\.tabSelection) private var tabSelection
    
    init(viewModel: HomeViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // 통계 카드
                StatisticsCard(totalRecords: viewModel.uiState.totalRecords)
                    .padding(.horizontal)
                
                if viewModel.uiState.isLoading {
                    LoadingView()
                        .frame(height: 200)
                } else if let record = viewModel.uiState.todayRecord {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("오늘의 기록")
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(.primary)
                            .padding(.horizontal)
                        
                        NavigationLink(value: AppRoute.detail(recordId: record.id)) {
                            RecordCard(record: record)
                        }
                        .padding(.horizontal)
                    }
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
                
                // 전체 기록, 달력 버튼
                HStack(spacing: 12) {
                    Button {
                        tabSelection.wrappedValue = .list
                    } label: {
                        HStack {
                            Image(systemName: "list.bullet")
                            Text("전체 기록")
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(.systemGray6))
                        .foregroundColor(.primary)
                        .cornerRadius(12)
                    }
                    
                    Button {
                        tabSelection.wrappedValue = .calendar
                    } label: {
                        HStack {
                            Image(systemName: "calendar")
                            Text("달력")
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(.systemGray6))
                        .foregroundColor(.primary)
                        .cornerRadius(12)
                    }
                }
                .padding(.horizontal)
                
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
        .navigationDestination(for: AppRoute.self) { route in
            switch route {
            case .create:
                CreateRecordView(viewModel: CreateRecordViewModel(
                    createRecordUseCase: CreateRecordUseCase(
                        recordRepository: RecordRepositoryImpl(
                            coreDataStack: CoreDataStack.shared,
                            recordMapper: RecordMapper()
                        ),
                        fileRepository: FileRepositoryImpl(),
                        validateDailyLimit: ValidateDailyLimitUseCase(
                            recordRepository: RecordRepositoryImpl(
                                coreDataStack: CoreDataStack.shared,
                                recordMapper: RecordMapper()
                            )
                        ),
                        validateDate: ValidateDateUseCase(),
                        validateContent: ValidateRecordContentUseCase(),
                        calculateStreak: CalculateStreakUseCase(
                            recordRepository: RecordRepositoryImpl(
                                coreDataStack: CoreDataStack.shared,
                                recordMapper: RecordMapper()
                            )
                        ),
                        settingsRepository: SettingsRepositoryImpl(
                            coreDataStack: CoreDataStack.shared,
                            settingsMapper: SettingsMapper()
                        )
                    ),
                    getCurrentLocationUseCase: GetCurrentLocationUseCase(),
                    reverseGeocodeUseCase: ReverseGeocodeUseCase(),
                    getSettingsUseCase: GetSettingsUseCase(
                        settingsRepository: SettingsRepositoryImpl(
                            coreDataStack: CoreDataStack.shared,
                            settingsMapper: SettingsMapper()
                        )
                    )
                ))
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
                ),
                recordRepository: RecordRepositoryImpl(
                    coreDataStack: CoreDataStack.shared,
                    recordMapper: RecordMapper()
                ),
                settingsRepository: SettingsRepositoryImpl(
                    coreDataStack: CoreDataStack.shared,
                    settingsMapper: SettingsMapper()
                )
            )
        )
    }
}

