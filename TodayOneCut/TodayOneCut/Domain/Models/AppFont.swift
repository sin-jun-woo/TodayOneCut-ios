//
//  AppFont.swift
//  TodayOneCut
//
//  Created by 신준우 on 2/13/26.
//

import Foundation

/// 앱에서 사용하는 폰트 타입
enum AppFont: String, Codable, CaseIterable {
    case gowunBatang = "GOWUN_BATANG"
    case kyoboHandwriting = "KYOBO_HANDWRITING"
    case maruBuri = "MARU_BURI"
    case systemSerif = "SYSTEM_SERIF"
    
    var displayName: String {
        switch self {
        case .gowunBatang:
            return "고운바탕"
        case .kyoboHandwriting:
            return "교보 손글씨"
        case .maruBuri:
            return "마루부리"
        case .systemSerif:
            return "시스템 세리프"
        }
    }
    
    var resourceName: String? {
        switch self {
        case .gowunBatang:
            return "GowunBatang-Bold"
        case .kyoboHandwriting:
            return "KyoboHandwriting2024psw"
        case .maruBuri:
            return "MaruBuri-Bold"
        case .systemSerif:
            return nil
        }
    }
}

