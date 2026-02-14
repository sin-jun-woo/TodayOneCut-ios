//
//  AppNavigation.swift
//  TodayOneCut
//
//  Created by 신준우 on 2/13/26.
//

import SwiftUI

/// 앱 네비게이션 루트
struct AppNavigation: View {
    @State private var navigationPath = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
            HomeView(viewModel: HomeViewModel(
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
            ))
                .navigationDestination(for: AppRoute.self) { route in
                    switch route {
                    case .home:
                        HomeView(viewModel: HomeViewModel(
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
                        ))
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
                                validateContent: ValidateRecordContentUseCase()
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
                    case .list:
                        RecordListView(viewModel: RecordListViewModel(
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
                    case .calendar:
                        CalendarView(viewModel: CalendarViewModel(
                            getMonthRecordsUseCase: GetMonthRecordsUseCase(
                                recordRepository: RecordRepositoryImpl(
                                    coreDataStack: CoreDataStack.shared,
                                    recordMapper: RecordMapper()
                                )
                            ),
                            getRecordDatesUseCase: GetRecordDatesUseCase(
                                recordRepository: RecordRepositoryImpl(
                                    coreDataStack: CoreDataStack.shared,
                                    recordMapper: RecordMapper()
                                )
                            ),
                            getRecordByDateUseCase: GetTodayRecordUseCase(
                                recordRepository: RecordRepositoryImpl(
                                    coreDataStack: CoreDataStack.shared,
                                    recordMapper: RecordMapper()
                                )
                            ),
                            recordRepository: RecordRepositoryImpl(
                                coreDataStack: CoreDataStack.shared,
                                recordMapper: RecordMapper()
                            )
                        ))
                    case .settings:
                        SettingsView(viewModel: SettingsViewModel(
                            getSettingsUseCase: GetSettingsUseCase(
                                settingsRepository: SettingsRepositoryImpl(
                                    coreDataStack: CoreDataStack.shared,
                                    settingsMapper: SettingsMapper()
                                )
                            ),
                            updateLocationSettingUseCase: UpdateLocationSettingUseCase(
                                settingsRepository: SettingsRepositoryImpl(
                                    coreDataStack: CoreDataStack.shared,
                                    settingsMapper: SettingsMapper()
                                )
                            ),
                            updateThemeUseCase: UpdateThemeUseCase(
                                settingsRepository: SettingsRepositoryImpl(
                                    coreDataStack: CoreDataStack.shared,
                                    settingsMapper: SettingsMapper()
                                )
                            )
                        ))
                    case .onboarding:
                        OnboardingView()
                    }
                }
        }
    }
}

