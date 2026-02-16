//
//  DeleteAllDataUseCase.swift
//  TodayOneCut
//
//  Created by 신준우 on 2/13/26.
//

import Foundation

/// 모든 데이터 삭제 Use Case
class DeleteAllDataUseCase {
    private let recordRepository: RecordRepository
    private let settingsRepository: SettingsRepository
    private let fileRepository: FileRepository
    
    init(
        recordRepository: RecordRepository,
        settingsRepository: SettingsRepository,
        fileRepository: FileRepository
    ) {
        self.recordRepository = recordRepository
        self.settingsRepository = settingsRepository
        self.fileRepository = fileRepository
    }
    
    func execute() async throws {
        // 1. 모든 기록 삭제
        try await recordRepository.deleteAllRecords()
        
        // 2. 모든 사진 파일 삭제
        try await fileRepository.deleteAllPhotos()
        
        // 3. 설정 초기화 (기본값으로 리셋)
        try await settingsRepository.resetSettings()
    }
}

