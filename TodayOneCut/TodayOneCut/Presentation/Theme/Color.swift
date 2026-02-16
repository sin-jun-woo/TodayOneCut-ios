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
    
    // MARK: - AppTheme Color Palettes
    
    /// Warm & Cozy (포근한 기록)
    struct WarmCozy {
        static let primary = Color(red: 0x5D / 255.0, green: 0x6D / 255.0, blue: 0x7E / 255.0) // #5D6D7E
        static let surface = Color(red: 0xFD / 255.0, green: 0xFC / 255.0, blue: 0xF0 / 255.0) // #FDFCF0
        static let onSurface = Color(red: 0x2C / 255.0, green: 0x3E / 255.0, blue: 0x50 / 255.0) // #2C3E50
    }
    
    /// Nature & Calm (자연의 조각)
    struct NatureCalm {
        static let primary = Color(red: 0x8B / 255.0, green: 0x9A / 255.0, blue: 0x46 / 255.0) // #8B9A46
        static let surface = Color(red: 0xF9 / 255.0, green: 0xF9 / 255.0, blue: 0xF7 / 255.0) // #F9F9F7
        static let onSurface = Color(red: 0x3A / 255.0, green: 0x3F / 255.0, blue: 0x33 / 255.0) // #3A3F33
    }
    
    /// Deep & Emotional (새벽의 감성)
    struct DeepEmotional {
        static let primary = Color(red: 0xD4 / 255.0, green: 0xA3 / 255.0, blue: 0x73 / 255.0) // #D4A373
        static let surface = Color(red: 0xFA / 255.0, green: 0xFA / 255.0, blue: 0xF9 / 255.0) // #FAFAF9
        static let onSurface = Color(red: 0x1A / 255.0, green: 0x1A / 255.0, blue: 0x1A / 255.0) // #1A1A1A
    }
}

