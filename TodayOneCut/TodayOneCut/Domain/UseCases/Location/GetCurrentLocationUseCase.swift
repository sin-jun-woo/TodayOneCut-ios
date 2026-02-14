//
//  GetCurrentLocationUseCase.swift
//  TodayOneCut
//
//  Created by 신준우 on 2/13/26.
//

import Foundation
import CoreLocation

/// 현재 위치 조회 Use Case
class GetCurrentLocationUseCase: NSObject {
    private let locationManager = CLLocationManager()
    private var continuation: CheckedContinuation<Location, Error>?
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    /// 현재 위치 조회
    /// - Returns: 현재 위치
    /// - Throws: PermissionDeniedError 권한이 없는 경우
    func execute() async throws -> Location {
        // 권한 확인
        let status = locationManager.authorizationStatus
        if status == .denied || status == .restricted {
            throw TodayOneCutError.permissionDenied(message: "위치 권한이 필요합니다")
        }
        
        if status == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
            // 권한 대기
            try await Task.sleep(nanoseconds: 500_000_000) // 0.5초
            let newStatus = locationManager.authorizationStatus
            if newStatus == .denied || newStatus == .restricted {
                throw TodayOneCutError.permissionDenied(message: "위치 권한이 필요합니다")
            }
        }
        
        return try await withCheckedThrowingContinuation { continuation in
            self.continuation = continuation
            locationManager.requestLocation()
        }
    }
}

extension GetCurrentLocationUseCase: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        
        let domainLocation = Location(
            latitude: location.coordinate.latitude,
            longitude: location.coordinate.longitude
        )
        
        continuation?.resume(returning: domainLocation)
        continuation = nil
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        continuation?.resume(throwing: error)
        continuation = nil
    }
}

