//
//  ReverseGeocodeUseCase.swift
//  TodayOneCut
//
//  Created by 신준우 on 2/13/26.
//

import Foundation
import CoreLocation

/// 역지오코딩 Use Case (좌표 → 주소)
class ReverseGeocodeUseCase {
    private let geocoder = CLGeocoder()
    
    /// 좌표를 주소로 변환
    /// - Parameter location: 위치 정보
    /// - Returns: 위치 이름이 업데이트된 Location
    func execute(location: Location) async throws -> Location {
        let clLocation = CLLocation(
            latitude: location.latitude,
            longitude: location.longitude
        )
        
        let placemarks = try await geocoder.reverseGeocodeLocation(clLocation)
        
        guard let placemark = placemarks.first else {
            return location
        }
        
        // 주소 구성
        var addressComponents: [String] = []
        
        if let locality = placemark.locality {
            addressComponents.append(locality)
        }
        if let subLocality = placemark.subLocality {
            addressComponents.append(subLocality)
        }
        
        let address = addressComponents.joined(separator: " ")
        
        return Location(
            latitude: location.latitude,
            longitude: location.longitude,
            name: address.isEmpty ? nil : address
        )
    }
}

