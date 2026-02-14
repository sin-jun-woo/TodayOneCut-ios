//
//  Color.swift
//  TodayOneCut
//
//  Created by 신준우 on 2/13/26.
//

import SwiftUI

extension Color {
    /// 앱 전용 색상 팔레트
    struct AppColor {
        // Primary Colors
        static let primary = Color("PrimaryColor", bundle: nil)
        static let primaryVariant = Color("PrimaryVariantColor", bundle: nil)
        
        // Secondary Colors
        static let secondary = Color("SecondaryColor", bundle: nil)
        static let secondaryVariant = Color("SecondaryVariantColor", bundle: nil)
        
        // Background Colors
        static let background = Color("BackgroundColor", bundle: nil)
        static let surface = Color("SurfaceColor", bundle: nil)
        
        // Text Colors
        static let onPrimary = Color("OnPrimaryColor", bundle: nil)
        static let onSecondary = Color("OnSecondaryColor", bundle: nil)
        static let onBackground = Color("OnBackgroundColor", bundle: nil)
        static let onSurface = Color("OnSurfaceColor", bundle: nil)
        
        // Error Colors
        static let error = Color("ErrorColor", bundle: nil)
        static let onError = Color("OnErrorColor", bundle: nil)
        
        // Accent Colors
        static let accent = Color.accentColor
    }
}

// 기본 색상 정의 (Assets.xcassets에 추가 필요)
// 또는 직접 색상 값 사용
extension Color {
    /// 조용한 색감의 Primary 색상
    static let appPrimary = Color(red: 0.2, green: 0.4, blue: 0.6)
    
    /// 조용한 색감의 Secondary 색상
    static let appSecondary = Color(red: 0.4, green: 0.5, blue: 0.6)
}

