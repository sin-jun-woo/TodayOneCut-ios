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

