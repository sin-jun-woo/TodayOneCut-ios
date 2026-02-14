//
//  UpdateLocationSettingUseCase.swift
//  TodayOneCut
//
//  Created by 신준우 on 2/13/26.
//

import Foundation

/// 위치 정보 저장 설정 업데이트 Use Case
class UpdateLocationSettingUseCase {
    private let settingsRepository: SettingsRepository
    
    init(settingsRepository: SettingsRepository) {
        self.settingsRepository = settingsRepository
    }
    
    /// 위치 정보 저장 설정 업데이트
    /// - Parameter enabled: 위치 저장 활성화 여부
    func execute(enabled: Bool) async throws {
        try await settingsRepository.updateLocationEnabled(enabled)
    }
}

