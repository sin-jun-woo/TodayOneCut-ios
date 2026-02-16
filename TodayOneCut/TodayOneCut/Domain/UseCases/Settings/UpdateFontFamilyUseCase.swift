//
//  UpdateFontFamilyUseCase.swift
//  TodayOneCut
//
//  Created by 신준우 on 2/13/26.
//

import Foundation

/// 폰트 패밀리 업데이트 Use Case
class UpdateFontFamilyUseCase {
    private let settingsRepository: SettingsRepository
    
    init(settingsRepository: SettingsRepository) {
        self.settingsRepository = settingsRepository
    }
    
    func execute(_ font: AppFont) async throws {
        try await settingsRepository.updateFontFamily(font)
    }
}

