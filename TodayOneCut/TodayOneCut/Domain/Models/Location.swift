//
//  Location.swift
//  TodayOneCut
//
//  Created by 신준우 on 2/13/26.
//

import Foundation

/// 위치 정보
struct Location: Codable, Equatable {
    let latitude: Double
    let longitude: Double
    var name: String?
    
    init(latitude: Double, longitude: Double, name: String? = nil) {
        self.latitude = latitude
        self.longitude = longitude
        self.name = name
    }
}

