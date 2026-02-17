//
//  NotificationScheduler.swift
//  TodayOneCut
//
//  Created by 신준우 on 2/13/26.
//

import Foundation
import UserNotifications

/// 알림 스케줄 관리
class NotificationScheduler {
    static let shared = NotificationScheduler()
    
    private let notificationCenter = UNUserNotificationCenter.current()
    let dailyReminderIdentifier = "daily_reminder"
    
    private init() {}
    
    /// 일일 리마인더 스케줄링 (매일 오후 9시)
    func scheduleDailyReminder() async {
        // 기존 알림 제거
        await cancelDailyReminder()
        
        // 알림 권한 확인
        let settings = await notificationCenter.notificationSettings()
        guard settings.authorizationStatus == .authorized else {
            #if DEBUG
            print("알림 권한이 없어 스케줄링할 수 없습니다")
            #endif
            return
        }
        
        // 다음 오후 9시까지의 시간 계산
        let calendar = Calendar.current
        let now = Date()
        
        var components = calendar.dateComponents([.year, .month, .day], from: now)
        components.hour = 21 // 오후 9시
        components.minute = 0
        components.second = 0
        
        var targetDate = calendar.date(from: components) ?? now
        
        // 이미 오후 9시가 지났으면 내일로 설정
        if targetDate <= now {
            targetDate = calendar.date(byAdding: .day, value: 1, to: targetDate) ?? targetDate
        }
        
        // 매일 반복 트리거 생성
        let triggerDate = calendar.dateComponents([.hour, .minute], from: targetDate)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: true)
        
        // 알림 요청 생성
        let content = NotificationContent.dailyReminder()
        let request = UNNotificationRequest(
            identifier: dailyReminderIdentifier,
            content: content,
            trigger: trigger
        )
        
        do {
            try await notificationCenter.add(request)
            #if DEBUG
            print("일일 리마인더 스케줄링 완료: \(targetDate)")
            #endif
        } catch {
            #if DEBUG
            print("일일 리마인더 스케줄링 실패: \(error)")
            #endif
        }
    }
    
    /// 일일 리마인더 취소
    func cancelDailyReminder() async {
        notificationCenter.removePendingNotificationRequests(withIdentifiers: [dailyReminderIdentifier])
        notificationCenter.removeDeliveredNotifications(withIdentifiers: [dailyReminderIdentifier])
        #if DEBUG
        print("일일 리마인더 취소 완료")
        #endif
    }
    
    /// 스케줄 상태 확인
    func isDailyReminderScheduled() async -> Bool {
        let pendingRequests = await notificationCenter.pendingNotificationRequests()
        return pendingRequests.contains { $0.identifier == dailyReminderIdentifier }
    }
}

