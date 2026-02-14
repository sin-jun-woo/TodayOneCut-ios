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
            HomeView()
                .navigationDestination(for: AppRoute.self) { route in
                    switch route {
                    case .home:
                        HomeView()
                    case .create:
                        CreateRecordView()
                    case .list:
                        RecordListView()
                    case .detail(let id):
                        RecordDetailView(recordId: id)
                    case .calendar:
                        CalendarView()
                    case .settings:
                        SettingsView()
                    case .onboarding:
                        OnboardingView()
                    }
                }
        }
    }
}

