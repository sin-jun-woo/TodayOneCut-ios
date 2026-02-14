//
//  SettingsViewModel.swift
//  TodayOneCut
//
//  Created by 신준우 on 2/13/26.
//

import Foundation
import Combine

/// 설정 화면 ViewModel
@MainActor
class SettingsViewModel: ObservableObject {
    @Published var settings: AppSettings?
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    private let getSettingsUseCase: GetSettingsUseCase
    private let updateLocationSettingUseCase: UpdateLocationSettingUseCase
    private let updateThemeUseCase: UpdateThemeUseCase
    private var cancellables = Set<AnyCancellable>()
    
    init(
        getSettingsUseCase: GetSettingsUseCase,
        updateLocationSettingUseCase: UpdateLocationSettingUseCase,
        updateThemeUseCase: UpdateThemeUseCase
    ) {
        self.getSettingsUseCase = getSettingsUseCase
        self.updateLocationSettingUseCase = updateLocationSettingUseCase
        self.updateThemeUseCase = updateThemeUseCase
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
}

