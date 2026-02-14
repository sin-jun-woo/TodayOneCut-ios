//
//  RecordType.swift
//  TodayOneCut
//
//  Created by 신준우 on 2/13/26.
//

import Foundation

/// 기록 타입
enum RecordType: String, Codable, CaseIterable {
    case photo = "PHOTO"  // 사진 타입
    case text = "TEXT"    // 텍스트 타입
    
    var displayName: String {
        switch self {
        case .photo:
            return "사진"
        case .text:
            return "텍스트"
        }
    }
}

