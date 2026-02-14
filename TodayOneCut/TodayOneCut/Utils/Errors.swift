//
//  Errors.swift
//  TodayOneCut
//
//  Created by 신준우 on 2/13/26.
//

import Foundation

/// 앱 전용 에러 타입
enum TodayOneCutError: LocalizedError {
    case dailyLimitExceeded(message: String = "하루에 하나만 기록할 수 있습니다")
    case updateLimitExceeded(message: String = "수정은 1회만 가능합니다")
    case invalidDate(message: String)
    case invalidContent(message: String = "사진 또는 텍스트가 필요합니다")
    case recordNotFound(message: String = "기록을 찾을 수 없습니다")
    case fileSaveError(message: String = "파일 저장에 실패했습니다")
    case fileNotFound(message: String = "파일을 찾을 수 없습니다")
    case permissionDenied(message: String = "필요한 권한이 없습니다")
    case databaseError(message: String = "데이터 저장 중 오류가 발생했습니다")
    
    var errorDescription: String? {
        switch self {
        case .dailyLimitExceeded(let message),
             .updateLimitExceeded(let message),
             .invalidDate(let message),
             .invalidContent(let message),
             .recordNotFound(let message),
             .fileSaveError(let message),
             .fileNotFound(let message),
             .permissionDenied(let message),
             .databaseError(let message):
            return message
        }
    }
    
    var userMessage: String {
        switch self {
        case .dailyLimitExceeded:
            return "오늘은 이미 기록을 남겼어요"
        case .updateLimitExceeded:
            return "이미 수정한 기록은 다시 수정할 수 없어요"
        case .invalidDate(let message):
            return message
        case .invalidContent:
            return "사진이나 텍스트 중 하나는 있어야 해요"
        case .recordNotFound:
            return "기록을 찾을 수 없어요"
        case .fileSaveError:
            return "사진 저장에 실패했어요"
        case .fileNotFound:
            return "사진 파일을 찾을 수 없어요"
        case .permissionDenied:
            return "필요한 권한이 없어요"
        case .databaseError:
            return "데이터 저장에 실패했어요. 다시 시도해주세요"
        }
    }
}

