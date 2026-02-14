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
    var themeMode: ThemeMode
    var firstLaunch: Bool
    var totalRecords: Int
    let createdAt: Date
    var updatedAt: Date?
    
    init(
        id: Int32 = 1,
        enableLocation: Bool = false,
        themeMode: ThemeMode = .system,
        firstLaunch: Bool = true,
        totalRecords: Int = 0,
        createdAt: Date = Date(),
        updatedAt: Date? = nil
    ) {
        self.id = id
        self.enableLocation = enableLocation
        self.themeMode = themeMode
        self.firstLaunch = firstLaunch
        self.totalRecords = totalRecords
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}

