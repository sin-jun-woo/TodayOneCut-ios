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
    @State private var showOnboarding = false
    
    private let getSettingsUseCase: GetSettingsUseCase
    
    init() {
        // 임시로 직접 생성 (나중에 DI로 교체)
        let coreDataStack = CoreDataStack.shared
        let settingsMapper = SettingsMapper()
        let settingsRepository = SettingsRepositoryImpl(
            coreDataStack: coreDataStack,
            settingsMapper: settingsMapper
        )
        self.getSettingsUseCase = GetSettingsUseCase(settingsRepository: settingsRepository)
    }
    
    var body: some View {
        Group {
            if showOnboarding {
                NavigationStack {
                    OnboardingView(viewModel: OnboardingViewModel(
                        markFirstLaunchCompleteUseCase: MarkFirstLaunchCompleteUseCase(
                            settingsRepository: SettingsRepositoryImpl(
                                coreDataStack: CoreDataStack.shared,
                                settingsMapper: SettingsMapper()
                            )
                        )
                    ))
                }
            } else {
                MainTabView()
            }
        }
        .onAppear {
            checkFirstLaunch()
        }
    }
    
    /// 첫 실행 체크
    func checkFirstLaunch() {
        Task {
            do {
                let settings = try await getSettingsUseCase.executeOnce()
                showOnboarding = settings.firstLaunch
            } catch {
                // 에러 발생 시 온보딩 표시하지 않음
                showOnboarding = false
            }
        }
    }
}
