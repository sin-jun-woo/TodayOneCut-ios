//
//  Extensions.swift
//  TodayOneCut
//
//  Created by 신준우 on 2/13/26.
//

import Foundation

extension Date {
    /// 오늘 날짜인지 확인
    var isToday: Bool {
        Calendar.current.isDateInToday(self)
    }
    
    /// 하루의 시작 시간
    var startOfDay: Date {
        Calendar.current.startOfDay(for: self)
    }
    
    /// 하루의 끝 시간
    var endOfDay: Date {
        var components = DateComponents()
        components.day = 1
        components.second = -1
        return Calendar.current.date(byAdding: components, to: startOfDay) ?? self
    }
    
    /// 로컬 날짜 문자열로 변환 (yyyy-MM-dd)
    func toLocalDateString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = Constants.DateFormat.localDateString
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.string(from: self)
    }
    
    /// 표시용 날짜 문자열로 변환 (yyyy년 MM월 dd일)
    func toDisplayDateString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = Constants.DateFormat.displayDate
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.string(from: self)
    }
    
    /// 표시용 날짜시간 문자열로 변환 (yyyy년 MM월 dd일 HH:mm)
    func toDisplayDateTimeString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = Constants.DateFormat.displayDateTime
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.string(from: self)
    }
    
    /// 문자열에서 Date로 변환 (yyyy-MM-dd)
    static func fromLocalDateString(_ string: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = Constants.DateFormat.localDateString
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.date(from: string)
    }
}

extension String {
    /// Date로 변환 (yyyy-MM-dd)
    func toDate() -> Date? {
        Date.fromLocalDateString(self)
    }
}

extension Bundle {
    /// 앱 버전 문자열 (예: "1.0.0")
    var appVersion: String {
        return infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0.0"
    }
    
    /// 빌드 번호 (예: "1")
    var buildNumber: String {
        return infoDictionary?["CFBundleVersion"] as? String ?? "1"
    }
    
    /// 전체 버전 문자열 (예: "1.0.0 (1)")
    var fullVersionString: String {
        return "\(appVersion) (\(buildNumber))"
    }
}

