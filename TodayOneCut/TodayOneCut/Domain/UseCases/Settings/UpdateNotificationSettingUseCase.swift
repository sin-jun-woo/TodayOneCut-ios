//
//  UpdateNotificationSettingUseCase.swift
//  TodayOneCut
//
//  Created by 신준우 on 2/13/26.
//

import Foundation

/// 알림 설정 업데이트 Use Case
class UpdateNotificationSettingUseCase {
    private let settingsRepository: SettingsRepository
    
    init(settingsRepository: SettingsRepository) {
        self.settingsRepository = settingsRepository
    }
    
    func execute(_ enabled: Bool) async throws {
        try await settingsRepository.updateNotificationEnabled(enabled)
    }
}

