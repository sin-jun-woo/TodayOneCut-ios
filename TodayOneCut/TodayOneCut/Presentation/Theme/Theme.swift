//
//  Theme.swift
//  TodayOneCut
//
//  Created by 신준우 on 2/13/26.
//

import SwiftUI

/// AppTheme enum에 따른 색상 팔레트 반환
func getColorForAppTheme(_ appTheme: AppTheme) -> (primary: Color, surface: Color, onSurface: Color) {
    switch appTheme {
    case .warmCozy:
        return (Color.WarmCozy.primary, Color.WarmCozy.surface, Color.WarmCozy.onSurface)
    case .natureCalm:
        return (Color.NatureCalm.primary, Color.NatureCalm.surface, Color.NatureCalm.onSurface)
    case .deepEmotional:
        return (Color.DeepEmotional.primary, Color.DeepEmotional.surface, Color.DeepEmotional.onSurface)
    }
}

/// 테마 뷰 모디파이어
struct ThemeModifier: ViewModifier {
    @AppStorage("themeMode") private var themeMode: String = ThemeMode.system.rawValue
    @AppStorage("appTheme") private var appThemeString: String = AppTheme.warmCozy.rawValue
    
    func body(content: Content) -> some View {
        let mode = ThemeMode(rawValue: themeMode) ?? .system
        let appTheme = AppTheme(rawValue: appThemeString) ?? .warmCozy
        
        content
            .preferredColorScheme(mode.colorScheme)
            .tint(getColorForAppTheme(appTheme).primary)
    }
}

extension View {
    /// 앱 테마 적용
    func appTheme() -> some View {
        modifier(ThemeModifier())
    }
}

