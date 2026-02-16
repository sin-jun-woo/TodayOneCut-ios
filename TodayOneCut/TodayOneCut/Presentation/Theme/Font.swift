//
//  Font.swift
//  TodayOneCut
//
//  Created by 신준우 on 2/13/26.
//

import SwiftUI

extension Font {
    /// AppFont에 따른 Font 반환
    static func appFont(_ appFont: AppFont, size: CGFloat = 17) -> Font {
        switch appFont {
        case .gowunBatang:
            // 여러 가능한 폰트 이름 시도
            let possibleNames = ["GowunBatang-Bold", "Gowun Batang Bold", "GowunBatangBold"]
            for fontName in possibleNames {
                if let font = UIFont(name: fontName, size: size) {
                    return Font(font)
                }
            }
            return .system(size: size, design: .serif)
            
        case .kyoboHandwriting:
            // 여러 가능한 폰트 이름 시도
            let possibleNames = ["KyoboHandwriting2024psw", "Kyobo Handwriting 2024", "KyoboHandwriting"]
            for fontName in possibleNames {
                if let font = UIFont(name: fontName, size: size) {
                    return Font(font)
                }
            }
            return .system(size: size, design: .default)
            
        case .maruBuri:
            // 여러 가능한 폰트 이름 시도
            let possibleNames = ["MaruBuri-Bold", "Maru Buri Bold", "MaruBuriBold"]
            for fontName in possibleNames {
                if let font = UIFont(name: fontName, size: size) {
                    return Font(font)
                }
            }
            return .system(size: size, design: .serif)
            
        case .systemSerif:
            return .system(size: size, design: .serif)
        }
    }
    
    /// AppFont에 따른 UIFont 반환
    static func uiFont(_ appFont: AppFont, size: CGFloat = 17) -> UIFont? {
        switch appFont {
        case .gowunBatang:
            let possibleNames = ["GowunBatang-Bold", "Gowun Batang Bold", "GowunBatangBold"]
            for fontName in possibleNames {
                if let font = UIFont(name: fontName, size: size) {
                    return font
                }
            }
            return UIFont.systemFont(ofSize: size)
            
        case .kyoboHandwriting:
            let possibleNames = ["KyoboHandwriting2024psw", "Kyobo Handwriting 2024", "KyoboHandwriting"]
            for fontName in possibleNames {
                if let font = UIFont(name: fontName, size: size) {
                    return font
                }
            }
            return UIFont.systemFont(ofSize: size)
            
        case .maruBuri:
            let possibleNames = ["MaruBuri-Bold", "Maru Buri Bold", "MaruBuriBold"]
            for fontName in possibleNames {
                if let font = UIFont(name: fontName, size: size) {
                    return font
                }
            }
            return UIFont.systemFont(ofSize: size)
            
        case .systemSerif:
            return UIFont.systemFont(ofSize: size)
        }
    }
}

/// 폰트 적용을 위한 View Modifier
struct AppFontModifier: ViewModifier {
    let appFont: AppFont
    
    func body(content: Content) -> some View {
        content
            .font(.appFont(appFont))
    }
}

extension View {
    /// 앱 폰트 적용
    func appFont(_ font: AppFont) -> some View {
        modifier(AppFontModifier(appFont: font))
    }
}

