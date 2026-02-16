//
//  NotificationManager.swift
//  TodayOneCut
//
//  Created by 신준우 on 2/13/26.
//

import Foundation
import UserNotifications

/// 알림 관리자
class NotificationManager {
    static let shared = NotificationManager()
    
    private let notificationCenter = UNUserNotificationCenter.current()
    private let scheduler = NotificationScheduler.shared
    
    private init() {}
    
    /// 알림 권한 요청
    func requestAuthorization() async -> Bool {
        do {
            let granted = try await notificationCenter.requestAuthorization(options: [.alert, .sound, .badge])
            return granted
        } catch {
            print("알림 권한 요청 실패: \(error)")
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
            print("알림 권한이 없어 축하 알림을 표시할 수 없습니다")
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
            print("연속 기록 축하 알림 표시: \(days)일")
        } catch {
            print("연속 기록 축하 알림 표시 실패: \(error)")
        }
    }
    
    /// 오늘 기록이 없을 때 일일 리마인더 표시 (테스트용)
    func showDailyReminderNow() async {
        let status = await authorizationStatus()
        guard status == .authorized else {
            print("알림 권한이 없어 알림을 표시할 수 없습니다")
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
            print("일일 리마인더 알림 표시 (테스트)")
        } catch {
            print("일일 리마인더 알림 표시 실패: \(error)")
        }
    }
}

