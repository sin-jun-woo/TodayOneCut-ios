//
//  NotificationContent.swift
//  TodayOneCut
//
//  Created by 신준우 on 2/13/26.
//

import Foundation
import UserNotifications

/// 알림 내용 정의
struct NotificationContent {
    static let dailyReminderTitle = "오늘의 장면을 남기세요"
    static let dailyReminderBody = "오늘 제일 기억나는 한 장면을 기록해보세요"
    
    static func streakCelebrationBody(days: Int) -> String {
        return "🎉 \(days)일 연속 기록! 정말 멋져요! 계속 이어가보세요"
    }
    
    static func streakCelebrationTitle(days: Int) -> String {
        return "\(days)일 연속 기록!"
    }
    
    /// 일일 리마인더 알림 콘텐츠 생성
    static func dailyReminder() -> UNMutableNotificationContent {
        let content = UNMutableNotificationContent()
        content.title = dailyReminderTitle
        content.body = dailyReminderBody
        content.sound = .default
        content.badge = 1
        return content
    }
    
    /// 연속 기록 축하 알림 콘텐츠 생성
    static func streakCelebration(days: Int) -> UNMutableNotificationContent {
        let content = UNMutableNotificationContent()
        content.title = streakCelebrationTitle(days: days)
        content.body = streakCelebrationBody(days: days)
        content.sound = .default
        return content
    }
}

