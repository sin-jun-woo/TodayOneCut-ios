//
//  Constants.swift
//  TodayOneCut
//
//  Created by 신준우 on 2/13/26.
//

import Foundation

/// 앱 전역 상수
enum Constants {
    /// 데이터베이스 관련 상수
    enum Database {
        static let databaseName = "TodayOneCut"
        static let modelName = "TodayOneCut"
    }
    
    /// 사진 관련 상수
    enum Photo {
        static let maxSize: Int = 1920 // 최대 크기 (px)
        static let compressionQuality: CGFloat = 0.85 // 압축 품질 (0.0-1.0)
        static let photosDirectory = "photos" // 사진 저장 디렉토리
    }
    
    /// 텍스트 관련 상수
    enum Text {
        static let maxContentLength: Int = 500 // 최대 텍스트 길이
    }
    
    /// 기록 관련 상수
    enum Record {
        static let maxUpdateCount: Int = 1 // 최대 수정 횟수
        static let dailyLimit: Int = 1 // 하루 최대 기록 수
    }
    
    /// 페이징 관련 상수
    enum Paging {
        static let defaultPageSize: Int = 30 // 기본 페이지 크기
    }
    
    /// 날짜 포맷
    enum DateFormat {
        static let localDateString = "yyyy-MM-dd" // 로컬 날짜 문자열 포맷
        static let displayDate = "yyyy년 MM월 dd일" // 표시용 날짜 포맷
        static let displayDateTime = "yyyy년 MM월 dd일 HH:mm" // 표시용 날짜시간 포맷
    }
}

