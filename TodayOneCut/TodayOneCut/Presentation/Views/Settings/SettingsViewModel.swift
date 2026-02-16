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
        Task {
            do {
                try await updateLocationSettingUseCase.execute(enabled: enabled)
            } catch {
                errorMessage = (error as? TodayOneCutError)?.userMessage ?? "설정 저장에 실패했습니다"
            }
        }
    }
    
    /// 테마 모드 변경
    func updateThemeMode(_ mode: ThemeMode) {
        Task {
            do {
                try await updateThemeUseCase.execute(mode: mode)
            } catch {
                errorMessage = (error as? TodayOneCutError)?.userMessage ?? "설정 저장에 실패했습니다"
            }
        }
    }
    
    /// 알림 설정 변경
    func updateNotificationEnabled(_ enabled: Bool) {
        Task {
            do {
                // 알림을 켜려고 할 때 권한 확인
                if enabled {
                    let status = await notificationManager.authorizationStatus()
                    if status != .authorized {
                        let granted = await notificationManager.requestAuthorization()
                        if !granted {
                            errorMessage = "알림 권한이 필요합니다. 설정에서 알림 권한을 허용해주세요."
                            return
                        }
                    }
                }
                
                try await updateNotificationSettingUseCase.execute(enabled)
                
                // 알림 스케줄링 또는 취소
                if enabled {
                    await notificationManager.scheduleDailyReminder()
                } else {
                    await notificationManager.cancelDailyReminder()
                }
            } catch {
                errorMessage = (error as? TodayOneCutError)?.userMessage ?? "설정 저장에 실패했습니다"
            }
        }
    }
    
    /// 앱 테마 변경
    func updateAppTheme(_ theme: AppTheme) {
        Task {
            do {
                try await updateAppThemeUseCase.execute(theme)
                // AppStorage 업데이트
                UserDefaults.standard.set(theme.rawValue, forKey: "appTheme")
            } catch {
                errorMessage = (error as? TodayOneCutError)?.userMessage ?? "설정 저장에 실패했습니다"
            }
        }
    }
    
    /// 폰트 패밀리 변경
    func updateFontFamily(_ font: AppFont) {
        Task {
            do {
                try await updateFontFamilyUseCase.execute(font)
                // AppStorage 업데이트
                UserDefaults.standard.set(font.rawValue, forKey: "fontFamily")
            } catch {
                errorMessage = (error as? TodayOneCutError)?.userMessage ?? "설정 저장에 실패했습니다"
            }
        }
    }
    
    /// 모든 데이터 삭제
    func deleteAllData() {
        Task {
            do {
                try await deleteAllDataUseCase.execute()
                // 설정 다시 로드
                loadSettings()
            } catch {
                errorMessage = (error as? TodayOneCutError)?.userMessage ?? "데이터 삭제에 실패했습니다"
            }
        }
    }
}

