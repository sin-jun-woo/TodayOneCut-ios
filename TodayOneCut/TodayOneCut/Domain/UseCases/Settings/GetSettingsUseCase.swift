//
//  GetSettingsUseCase.swift
//  TodayOneCut
//
//  Created by 신준우 on 2/13/26.
//

import Foundation
import Combine

/// 앱 설정 조회 Use Case
class GetSettingsUseCase {
    private let settingsRepository: SettingsRepository
    
    init(settingsRepository: SettingsRepository) {
        self.settingsRepository = settingsRepository
    }
    
    /// 앱 설정 조회 (실시간 업데이트)
    /// - Returns: 설정 Publisher
    func execute() -> AnyPublisher<AppSettings, Never> {
        return settingsRepository.getSettings()
    }
    
    /// 앱 설정 조회 (단건)
    /// - Returns: 현재 설정
    func executeOnce() async throws -> AppSettings {
        return try await settingsRepository.getSettingsOnce()
    }
}

