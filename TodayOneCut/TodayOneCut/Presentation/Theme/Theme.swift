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
    @AppStorage("fontFamily") private var fontFamilyString: String = AppFont.systemSerif.rawValue
    
    func body(content: Content) -> some View {
        let mode = ThemeMode(rawValue: themeMode) ?? .system
        let appTheme = AppTheme(rawValue: appThemeString) ?? .warmCozy
        let fontFamily = AppFont(rawValue: fontFamilyString) ?? .systemSerif
        
        content
            .preferredColorScheme(mode.colorScheme)
            .tint(getColorForAppTheme(appTheme).primary)
            .font(.appFont(fontFamily))
    }
}

extension View {
    /// 앱 테마 적용
    func appTheme() -> some View {
        modifier(ThemeModifier())
    }
}

/// 테마 색상 헬퍼
struct ThemeColorHelper {
    @AppStorage("appTheme") private static var appThemeString: String = AppTheme.warmCozy.rawValue
    
    /// 현재 테마의 surface 색상 반환
    static var surface: Color {
        let appTheme = AppTheme(rawValue: appThemeString) ?? .warmCozy
        return getColorForAppTheme(appTheme).surface
    }
    
    /// 현재 테마의 primary 색상 반환
    static var primary: Color {
        let appTheme = AppTheme(rawValue: appThemeString) ?? .warmCozy
        return getColorForAppTheme(appTheme).primary
    }
    
    /// 현재 테마의 primary 색상 (낮은 opacity) - 회색 박스 대체용
    static var primaryLight: Color {
        let appTheme = AppTheme(rawValue: appThemeString) ?? .warmCozy
        return getColorForAppTheme(appTheme).primary.opacity(0.1)
    }
}

