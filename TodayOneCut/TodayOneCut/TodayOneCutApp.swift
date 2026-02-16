//
//  TodayOneCutApp.swift
//  TodayOneCut
//
//  Created by 신준우 on 2/13/26.
//

import SwiftUI

@main
struct TodayOneCutApp: App {
    init() {
        // NotificationManager 초기화 (delegate 설정)
        _ = NotificationManager.shared
    }
    
    var body: some Scene {
        WindowGroup {
            AppNavigation()
                .appTheme()
        }
    }
}
