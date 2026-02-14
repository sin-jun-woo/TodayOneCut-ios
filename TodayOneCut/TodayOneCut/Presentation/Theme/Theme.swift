//
//  Theme.swift
//  TodayOneCut
//
//  Created by 신준우 on 2/13/26.
//

import SwiftUI

/// 앱 테마 설정
struct AppTheme {
    /// 라이트 테마 색상 스킴
    static let light = ColorScheme.light
    
    /// 다크 테마 색상 스킴
    static let dark = ColorScheme.dark
}

/// 테마 모드
enum ThemeMode: String, CaseIterable {
    case light = "LIGHT"
    case dark = "DARK"
    case system = "SYSTEM"
    
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

/// 테마 뷰 모디파이어
struct ThemeModifier: ViewModifier {
    @AppStorage("themeMode") private var themeMode: String = ThemeMode.system.rawValue
    
    func body(content: Content) -> some View {
        let mode = ThemeMode(rawValue: themeMode) ?? .system
        content
            .preferredColorScheme(mode.colorScheme)
    }
}

extension View {
    /// 앱 테마 적용
    func appTheme() -> some View {
        modifier(ThemeModifier())
    }
}

