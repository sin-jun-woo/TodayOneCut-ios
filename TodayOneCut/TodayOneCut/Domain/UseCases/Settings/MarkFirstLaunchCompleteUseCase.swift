//
//  MarkFirstLaunchCompleteUseCase.swift
//  TodayOneCut
//
//  Created by 신준우 on 2/13/26.
//

import Foundation

/// 최초 실행 완료 표시 Use Case
class MarkFirstLaunchCompleteUseCase {
    private let settingsRepository: SettingsRepository
    
    init(settingsRepository: SettingsRepository) {
        self.settingsRepository = settingsRepository
    }
    
    /// 최초 실행 완료 표시
    func execute() async throws {
        try await settingsRepository.markFirstLaunchComplete()
    }
}

