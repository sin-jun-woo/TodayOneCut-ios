//
//  UpdateAppThemeUseCase.swift
//  TodayOneCut
//
//  Created by 신준우 on 2/13/26.
//

import Foundation

/// 앱 테마 업데이트 Use Case
class UpdateAppThemeUseCase {
    private let settingsRepository: SettingsRepository
    
    init(settingsRepository: SettingsRepository) {
        self.settingsRepository = settingsRepository
    }
    
    func execute(_ theme: AppTheme) async throws {
        try await settingsRepository.updateAppTheme(theme)
    }
}

