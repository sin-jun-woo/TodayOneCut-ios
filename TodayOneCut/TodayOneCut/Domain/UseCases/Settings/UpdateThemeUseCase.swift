//
//  UpdateThemeUseCase.swift
//  TodayOneCut
//
//  Created by 신준우 on 2/13/26.
//

import Foundation

/// 테마 모드 변경 Use Case
class UpdateThemeUseCase {
    private let settingsRepository: SettingsRepository
    
    init(settingsRepository: SettingsRepository) {
        self.settingsRepository = settingsRepository
    }
    
    /// 테마 모드 변경
    /// - Parameter mode: 테마 모드
    func execute(mode: ThemeMode) async throws {
        try await settingsRepository.updateThemeMode(mode)
    }
}

