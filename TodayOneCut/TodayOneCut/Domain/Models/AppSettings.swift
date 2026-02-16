//
//  AppSettings.swift
//  TodayOneCut
//
//  Created by 신준우 on 2/13/26.
//

import Foundation

/// 앱 설정 도메인 모델
struct AppSettings: Codable, Equatable {
    let id: Int32
    var enableLocation: Bool
    var enableNotification: Bool
    var themeMode: ThemeMode
    var appTheme: AppTheme
    var fontFamily: AppFont
    var firstLaunch: Bool
    var totalRecords: Int
    let createdAt: Date
    var updatedAt: Date?
    
    init(
        id: Int32 = 1,
        enableLocation: Bool = false,
        enableNotification: Bool = false,
        themeMode: ThemeMode = .system,
        appTheme: AppTheme = .warmCozy,
        fontFamily: AppFont = .systemSerif,
        firstLaunch: Bool = true,
        totalRecords: Int = 0,
        createdAt: Date = Date(),
        updatedAt: Date? = nil
    ) {
        self.id = id
        self.enableLocation = enableLocation
        self.enableNotification = enableNotification
        self.themeMode = themeMode
        self.appTheme = appTheme
        self.fontFamily = fontFamily
        self.firstLaunch = firstLaunch
        self.totalRecords = totalRecords
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}

