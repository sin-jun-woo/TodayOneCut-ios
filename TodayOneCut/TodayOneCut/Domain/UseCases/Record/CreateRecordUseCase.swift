//
//  CreateRecordUseCase.swift
//  TodayOneCut
//
//  Created by 신준우 on 2/13/26.
//

import Foundation

/// 기록 생성 Use Case
class CreateRecordUseCase {
    private let recordRepository: RecordRepository
    private let fileRepository: FileRepository
    private let validateDailyLimit: ValidateDailyLimitUseCase
    private let validateDate: ValidateDateUseCase
    private let validateContent: ValidateRecordContentUseCase
    private let calculateStreak: CalculateStreakUseCase?
    private let settingsRepository: SettingsRepository?
    
    init(
        recordRepository: RecordRepository,
        fileRepository: FileRepository,
        validateDailyLimit: ValidateDailyLimitUseCase,
        validateDate: ValidateDateUseCase,
        validateContent: ValidateRecordContentUseCase,
        calculateStreak: CalculateStreakUseCase? = nil,
        settingsRepository: SettingsRepository? = nil
    ) {
        self.recordRepository = recordRepository
        self.fileRepository = fileRepository
        self.validateDailyLimit = validateDailyLimit
        self.validateDate = validateDate
        self.validateContent = validateContent
        self.calculateStreak = calculateStreak
        self.settingsRepository = settingsRepository
    }
    
    /// 기록 생성
    /// - Parameters:
    ///   - type: 기록 타입
    ///   - contentText: 텍스트 내용
    ///   - photoData: 사진 데이터
    ///   - location: 위치 정보
    /// - Returns: 생성된 기록
    func execute(
        type: RecordType,
        contentText: String?,
        photoData: Data?,
        location: Location?
    ) async throws -> Record {
        let today = Date()
        
        // 비즈니스 규칙 검증
        try validateDate.execute(date: today)
        try await validateDailyLimit.execute(date: today)
        try validateContent.execute(type: type, contentText: contentText, photoData: photoData)
        
        // 사진 저장 및 압축
        var photoPath: String? = nil
        if let photoData = photoData {
            let compressedData = try await fileRepository.compressPhoto(
                photoData,
                maxSize: Constants.Photo.maxSize,
                quality: Constants.Photo.compressionQuality
            )
            photoPath = try await fileRepository.savePhoto(compressedData, date: today)
        }
        
        // 레코드 생성
        let record = Record(
            date: today,
            type: type,
            contentText: contentText,
            photoPath: photoPath,
            location: location,
            createdAt: Date()
        )
        
        let createdRecord = try await recordRepository.createRecord(record)
        
        // 연속 기록 축하 알림 체크
        await checkAndShowStreakCelebration()
        
        return createdRecord
    }
    
    /// 연속 기록 축하 알림 체크 및 표시
    private func checkAndShowStreakCelebration() async {
        guard let calculateStreak = calculateStreak,
              let settingsRepository = settingsRepository else {
            return
        }
        
        // 알림 설정 확인
        do {
            let settings = try await settingsRepository.getSettingsOnce()
            guard settings.enableNotification else {
                return
            }
            
            // 연속 기록 일수 계산
            let streak = try await calculateStreak.execute()
            
            // 특정 일수 달성 시 축하 알림 (7일, 14일, 30일 등)
            let celebrationDays = [7, 14, 30, 50, 100]
            if celebrationDays.contains(streak) {
                await NotificationManager.shared.showStreakCelebration(days: streak)
            }
        } catch {
            // 에러는 무시 (선택적 기능)
            print("연속 기록 축하 알림 체크 실패: \(error)")
        }
    }
}

