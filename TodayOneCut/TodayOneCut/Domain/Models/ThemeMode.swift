//
//  ThemeMode.swift
//  TodayOneCut
//
//  Created by 신준우 on 2/13/26.
//

import Foundation
import SwiftUI

/// 테마 모드
enum ThemeMode: String, Codable, CaseIterable {
    case light = "LIGHT"    // 라이트 모드
    case dark = "DARK"      // 다크 모드
    case system = "SYSTEM"  // 시스템 설정 따름
    
    var displayName: String {
        switch self {
        case .light:
            return "라이트"
        case .dark:
            return "다크"
        case .system:
            return "시스템 설정"
        }
    }
    
    var colorScheme: ColorScheme? {
        switch self {
        case .light:
            return .light
        case .dark:
            return .dark
        case .system:
            return nil // 시스템 설정 따름
        }
    }
}

