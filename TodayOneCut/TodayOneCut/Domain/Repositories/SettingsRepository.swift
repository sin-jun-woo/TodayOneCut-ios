//
//  SettingsRepository.swift
//  TodayOneCut
//
//  Created by 신준우 on 2/13/26.
//

import Foundation
import Combine

/// 앱 설정 관리를 위한 저장소 프로토콜
protocol SettingsRepository {
    
    /// 앱 설정 조회 (Publisher)
    /// - Returns: 실시간 업데이트되는 설정
    func getSettings() -> AnyPublisher<AppSettings, Never>
    
    /// 앱 설정 조회 (단건)
    /// - Returns: 현재 설정
    func getSettingsOnce() async throws -> AppSettings
    
    /// 위치 정보 저장 설정 업데이트
    /// - Parameter enabled: 위치 저장 활성화 여부
    func updateLocationEnabled(_ enabled: Bool) async throws
    
    /// 테마 모드 변경
    /// - Parameter mode: 테마 모드 (LIGHT, DARK, SYSTEM)
    func updateThemeMode(_ mode: ThemeMode) async throws
    
    /// 알림 설정 업데이트
    /// - Parameter enabled: 알림 활성화 여부
    func updateNotificationEnabled(_ enabled: Bool) async throws
    
    /// 앱 테마 업데이트
    /// - Parameter theme: 앱 테마 (WARM_COZY, NATURE_CALM, DEEP_EMOTIONAL)
    func updateAppTheme(_ theme: AppTheme) async throws
    
    /// 폰트 패밀리 업데이트
    /// - Parameter font: 폰트 타입
    func updateFontFamily(_ font: AppFont) async throws
    
    /// 최초 실행 완료 표시
    func markFirstLaunchComplete() async throws
    
    /// 전체 설정 업데이트
    /// - Parameter settings: 새로운 설정
    func updateSettings(_ settings: AppSettings) async throws
    
    /// 총 기록 개수 업데이트 (캐시)
    /// - Parameter count: 총 기록 수
    func updateTotalRecords(_ count: Int) async throws
    
    /// 모든 설정 초기화 (기본값으로 리셋)
    /// - Throws: 데이터베이스 오류
    func resetSettings() async throws
}

