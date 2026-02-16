//
//  AppTheme.swift
//  TodayOneCut
//
//  Created by 신준우 on 2/13/26.
//

import Foundation

/// 앱 테마 타입
enum AppTheme: String, Codable, CaseIterable {
    case warmCozy = "WARM_COZY"
    case natureCalm = "NATURE_CALM"
    case deepEmotional = "DEEP_EMOTIONAL"
    
    var displayName: String {
        switch self {
        case .warmCozy:
            return "포근한 기록"
        case .natureCalm:
            return "자연의 조각"
        case .deepEmotional:
            return "새벽의 감성"
        }
    }
}

