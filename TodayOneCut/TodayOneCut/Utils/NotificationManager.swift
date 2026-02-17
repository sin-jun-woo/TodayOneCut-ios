//
//  NotificationManager.swift
//  TodayOneCut
//
//  Created by 신준우 on 2/13/26.
//

import Foundation
import UserNotifications

/// 알림 관리자
class NotificationManager: NSObject, UNUserNotificationCenterDelegate {
    static let shared = NotificationManager()
    
    private let notificationCenter = UNUserNotificationCenter.current()
    private let scheduler = NotificationScheduler.shared
    
    private override init() {
        super.init()
        notificationCenter.delegate = self
    }
    
    // MARK: - UNUserNotificationCenterDelegate
    
    /// 알림이 표시되기 전에 호출됨 (앱이 포그라운드에 있을 때)
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        // 일일 리마인더인 경우 조건 체크
        if notification.request.identifier == NotificationScheduler.shared.dailyReminderIdentifier {
            Task {
                let shouldShow = await shouldShowDailyReminder()
                if shouldShow {
                    completionHandler([.banner, .sound, .badge])
                } else {
                    completionHandler([]) // 알림 표시 안 함
                }
            }
        } else {
            // 다른 알림은 그대로 표시
            completionHandler([.banner, .sound, .badge])
        }
    }
    
    /// 알림을 탭했을 때 호출됨
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        completionHandler()
    }
    
    /// 일일 리마인더를 표시해야 하는지 확인
    private func shouldShowDailyReminder() async -> Bool {
        // 알림 설정 확인
        let settingsRepository = SettingsRepositoryImpl(
            coreDataStack: CoreDataStack.shared,
            settingsMapper: SettingsMapper()
        )
        
        do {
            let settings = try await settingsRepository.getSettingsOnce()
            
            // 알림이 꺼져 있으면 표시 안 함
            guard settings.enableNotification else {
                return false
            }
            
            // 오늘 기록이 있는지 확인
            let recordRepository = RecordRepositoryImpl(
                coreDataStack: CoreDataStack.shared,
                recordMapper: RecordMapper()
            )
            
            let today = DateTimeUtils.todayInKorea()
            let hasTodayRecord = try await recordRepository.recordExistsForDate(today)
            
            // 오늘 기록이 없으면 알림 표시
            return !hasTodayRecord
        } catch {
            // 에러 발생 시 알림 표시 (안전하게)
            #if DEBUG
            print("일일 리마인더 조건 체크 실패: \(error)")
            #endif
            return true
        }
    }
    
    /// 알림 권한 요청
    func requestAuthorization() async -> Bool {
        do {
            let granted = try await notificationCenter.requestAuthorization(options: [.alert, .sound, .badge])
            return granted
        } catch {
            #if DEBUG
            print("알림 권한 요청 실패: \(error)")
            #endif
            return false
        }
    }
    
    /// 알림 권한 상태 확인
    func authorizationStatus() async -> UNAuthorizationStatus {
        let settings = await notificationCenter.notificationSettings()
        return settings.authorizationStatus
    }
    
    /// 일일 리마인더 스케줄링
    func scheduleDailyReminder() async {
        await scheduler.scheduleDailyReminder()
    }
    
    /// 일일 리마인더 취소
    func cancelDailyReminder() async {
        await scheduler.cancelDailyReminder()
    }
    
    /// 연속 기록 축하 알림 표시
    func showStreakCelebration(days: Int) async {
        let status = await authorizationStatus()
        guard status == .authorized else {
            #if DEBUG
            print("알림 권한이 없어 축하 알림을 표시할 수 없습니다")
            #endif
            return
        }
        
        let content = NotificationContent.streakCelebration(days: days)
        let request = UNNotificationRequest(
            identifier: "streak_\(days)",
            content: content,
            trigger: nil // 즉시 표시
        )
        
        do {
            try await notificationCenter.add(request)
            #if DEBUG
            print("연속 기록 축하 알림 표시: \(days)일")
            #endif
        } catch {
            #if DEBUG
            print("연속 기록 축하 알림 표시 실패: \(error)")
            #endif
        }
    }
    
    /// 오늘 기록이 없을 때 일일 리마인더 표시 (테스트용)
    func showDailyReminderNow() async {
        let status = await authorizationStatus()
        guard status == .authorized else {
            #if DEBUG
            print("알림 권한이 없어 알림을 표시할 수 없습니다")
            #endif
            return
        }
        
        let content = NotificationContent.dailyReminder()
        let request = UNNotificationRequest(
            identifier: "daily_reminder_test",
            content: content,
            trigger: nil // 즉시 표시
        )
        
        do {
            try await notificationCenter.add(request)
            #if DEBUG
            print("일일 리마인더 알림 표시 (테스트)")
            #endif
        } catch {
            #if DEBUG
            print("일일 리마인더 알림 표시 실패: \(error)")
            #endif
        }
    }
}

