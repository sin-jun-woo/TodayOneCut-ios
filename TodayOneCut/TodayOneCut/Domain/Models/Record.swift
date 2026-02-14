//
//  Record.swift
//  TodayOneCut
//
//  Created by 신준우 on 2/13/26.
//

import Foundation

/// 기록 도메인 모델
struct Record: Identifiable, Codable, Equatable {
    let id: Int64
    let date: Date
    let type: RecordType
    var contentText: String?
    var photoPath: String?
    var location: Location?
    let createdAt: Date
    var updatedAt: Date?
    var updateCount: Int
    
    /// 수정 가능 여부
    var canUpdate: Bool {
        updateCount < Constants.Record.maxUpdateCount && date.isToday
    }
    
    init(
        id: Int64 = 0,
        date: Date,
        type: RecordType,
        contentText: String? = nil,
        photoPath: String? = nil,
        location: Location? = nil,
        createdAt: Date = Date(),
        updatedAt: Date? = nil,
        updateCount: Int = 0
    ) {
        self.id = id
        self.date = date
        self.type = type
        self.contentText = contentText
        self.photoPath = photoPath
        self.location = location
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.updateCount = updateCount
    }
}

