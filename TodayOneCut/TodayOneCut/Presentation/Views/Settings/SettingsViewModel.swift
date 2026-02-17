//
//  SettingsViewModel.swift
//  TodayOneCut
//
//  Created by 신준우 on 2/13/26.
//

import Foundation
import Combine
import UserNotifications

/// 설정 화면 ViewModel
@MainActor
class SettingsViewModel: ObservableObject {
    @Published var settings: AppSettings?
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    private let getSettingsUseCase: GetSettingsUseCase
    private let updateLocationSettingUseCase: UpdateLocationSettingUseCase
    private let updateThemeUseCase: UpdateThemeUseCase
    private let updateNotificationSettingUseCase: UpdateNotificationSettingUseCase
    private let updateAppThemeUseCase: UpdateAppThemeUseCase
    private let updateFontFamilyUseCase: UpdateFontFamilyUseCase
    private let deleteAllDataUseCase: DeleteAllDataUseCase
    private let notificationManager = NotificationManager.shared
    private var cancellables = Set<AnyCancellable>()
    private var updateTasks: [Task<Void, Never>] = []
    
    @Published var showThemeSelector = false
    @Published var showAppThemeSelector = false
    @Published var showFontSelector = false
    @Published var showDeleteConfirmation = false
    
    init(
        getSettingsUseCase: GetSettingsUseCase,
        updateLocationSettingUseCase: UpdateLocationSettingUseCase,
        updateThemeUseCase: UpdateThemeUseCase,
        updateNotificationSettingUseCase: UpdateNotificationSettingUseCase,
        updateAppThemeUseCase: UpdateAppThemeUseCase,
        updateFontFamilyUseCase: UpdateFontFamilyUseCase,
        deleteAllDataUseCase: DeleteAllDataUseCase
    ) {
        self.getSettingsUseCase = getSettingsUseCase
        self.updateLocationSettingUseCase = updateLocationSettingUseCase
        self.updateThemeUseCase = updateThemeUseCase
        self.updateNotificationSettingUseCase = updateNotificationSettingUseCase
        self.updateAppThemeUseCase = updateAppThemeUseCase
        self.updateFontFamilyUseCase = updateFontFamilyUseCase
        self.deleteAllDataUseCase = deleteAllDataUseCase
    }
    
    /// 설정 로드
    func loadSettings() {
        isLoading = true
        errorMessage = nil
        
        getSettingsUseCase.execute()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] settings in
                self?.settings = settings
                self?.isLoading = false
            }
            .store(in: &cancellables)
    }
    
    /// 위치 정보 저장 설정 변경
    func updateLocationEnabled(_ enabled: Bool) {
        let task = Task {
            do {
                try await updateLocationSettingUseCase.execute(enabled: enabled)
            } catch {
                if !Task.isCancelled {
                    errorMessage = (error as? TodayOneCutError)?.userMessage ?? "설정 저장에 실패했습니다"
                }
            }
        }
        updateTasks.append(task)
    }
    
    /// 테마 모드 변경
    func updateThemeMode(_ mode: ThemeMode) {
        let task = Task {
            do {
                try await updateThemeUseCase.execute(mode: mode)
            } catch {
                if !Task.isCancelled {
                    errorMessage = (error as? TodayOneCutError)?.userMessage ?? "설정 저장에 실패했습니다"
                }
            }
        }
        updateTasks.append(task)
    }
    
    /// 알림 설정 변경
    func updateNotificationEnabled(_ enabled: Bool) {
        let task = Task {
            do {
                // 알림을 켜려고 할 때 권한 확인
                if enabled {
                    let status = await notificationManager.authorizationStatus()
                    try Task.checkCancellation()
                    if status != .authorized {
                        let granted = await notificationManager.requestAuthorization()
                        try Task.checkCancellation()
                        if !granted {
                            errorMessage = "알림 권한이 필요합니다. 설정에서 알림 권한을 허용해주세요."
                            return
                        }
                    }
                }
                
                try await updateNotificationSettingUseCase.execute(enabled)
                try Task.checkCancellation()
                
                // 알림 스케줄링 또는 취소
                if enabled {
                    await notificationManager.scheduleDailyReminder()
                } else {
                    await notificationManager.cancelDailyReminder()
                }
            } catch {
                if !Task.isCancelled {
                    errorMessage = (error as? TodayOneCutError)?.userMessage ?? "설정 저장에 실패했습니다"
                }
            }
        }
        updateTasks.append(task)
    }
    
    /// 앱 테마 변경
    func updateAppTheme(_ theme: AppTheme) {
        let task = Task {
            do {
                try await updateAppThemeUseCase.execute(theme)
                try Task.checkCancellation()
                // AppStorage 업데이트
                UserDefaults.standard.set(theme.rawValue, forKey: "appTheme")
            } catch {
                if !Task.isCancelled {
                    errorMessage = (error as? TodayOneCutError)?.userMessage ?? "설정 저장에 실패했습니다"
                }
            }
        }
        updateTasks.append(task)
    }
    
    /// 폰트 패밀리 변경
    func updateFontFamily(_ font: AppFont) {
        let task = Task {
            do {
                try await updateFontFamilyUseCase.execute(font)
                try Task.checkCancellation()
                // AppStorage 업데이트
                UserDefaults.standard.set(font.rawValue, forKey: "fontFamily")
            } catch {
                if !Task.isCancelled {
                    errorMessage = (error as? TodayOneCutError)?.userMessage ?? "설정 저장에 실패했습니다"
                }
            }
        }
        updateTasks.append(task)
    }
    
    /// 모든 데이터 삭제
    func deleteAllData() {
        let task = Task {
            do {
                try await deleteAllDataUseCase.execute()
                try Task.checkCancellation()
                // 설정 다시 로드
                loadSettings()
            } catch {
                if !Task.isCancelled {
                    errorMessage = (error as? TodayOneCutError)?.userMessage ?? "데이터 삭제에 실패했습니다"
                }
            }
        }
        updateTasks.append(task)
    }
    
    deinit {
        updateTasks.forEach { $0.cancel() }
        cancellables.removeAll()
    }
}

