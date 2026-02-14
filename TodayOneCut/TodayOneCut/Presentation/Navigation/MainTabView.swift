//
//  MainTabView.swift
//  TodayOneCut
//
//  Created by 신준우 on 2/13/26.
//

import SwiftUI

/// 메인 탭바 뷰
struct MainTabView: View {
    @State private var selectedTab: TabItem = .home
    
    enum TabItem: String, CaseIterable {
        case home = "홈"
        case list = "목록"
        case calendar = "달력"
        case settings = "설정"
        
        var icon: String {
            switch self {
            case .home:
                return "house.fill"
            case .list:
                return "list.bullet"
            case .calendar:
                return "calendar"
            case .settings:
                return "gearshape.fill"
            }
        }
    }
    
    var body: some View {
        TabView(selection: $selectedTab) {
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
            .tabItem {
                Label(TabItem.home.rawValue, systemImage: TabItem.home.icon)
            }
            .tag(TabItem.home)
            
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
            .tabItem {
                Label(TabItem.list.rawValue, systemImage: TabItem.list.icon)
            }
            .tag(TabItem.list)
            
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
            .tabItem {
                Label(TabItem.calendar.rawValue, systemImage: TabItem.calendar.icon)
            }
            .tag(TabItem.calendar)
            
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
            .tabItem {
                Label(TabItem.settings.rawValue, systemImage: TabItem.settings.icon)
            }
            .tag(TabItem.settings)
        }
    }
}

#Preview {
    MainTabView()
}

