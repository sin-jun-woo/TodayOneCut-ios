//
//  SettingsRepositoryImplTests.swift
//  TodayOneCutTests
//
//  Created by 신준우 on 2/13/26.
//

import XCTest
import Combine
@testable import TodayOneCut

/// SettingsRepositoryImpl 통합 테스트
@MainActor
final class SettingsRepositoryImplTests: XCTestCase {
    var repository: SettingsRepositoryImpl!
    var testCoreDataStack: TestCoreDataStack!
    var settingsMapper: SettingsMapper!
    
    override func setUp() {
        super.setUp()
        testCoreDataStack = TestCoreDataStack()
        settingsMapper = SettingsMapper()
        repository = SettingsRepositoryImpl(
            coreDataStack: testCoreDataStack,
            settingsMapper: settingsMapper
        )
        testCoreDataStack.reset()
    }
    
    override func tearDown() {
        repository = nil
        settingsMapper = nil
        testCoreDataStack = nil
        super.tearDown()
    }
    
    /// 설정 조회
    func testGetSettings_ShouldReturnDefaultSettings() async throws {
        // When
        let settings = try await repository.getSettingsOnce()
        
        // Then
        XCTAssertNotNil(settings)
        XCTAssertEqual(settings.themeMode, .system)
        XCTAssertFalse(settings.enableLocation)
        XCTAssertFalse(settings.enableNotification)
    }
    
    /// 위치 설정 업데이트
    func testUpdateLocationSetting_ShouldUpdateSuccessfully() async throws {
        // Given
        let initialSettings = try await repository.getSettingsOnce()
        XCTAssertFalse(initialSettings.enableLocation)
        
        // When
        try await repository.updateLocationEnabled(true)
        
        // Then
        let updatedSettings = try await repository.getSettingsOnce()
        XCTAssertTrue(updatedSettings.enableLocation)
    }
    
    /// 테마 모드 업데이트
    func testUpdateTheme_ShouldUpdateSuccessfully() async throws {
        // When
        try await repository.updateThemeMode(.dark)
        
        // Then
        let settings = try await repository.getSettingsOnce()
        XCTAssertEqual(settings.themeMode, .dark)
    }
    
    /// 알림 설정 업데이트
    func testUpdateNotificationEnabled_ShouldUpdateSuccessfully() async throws {
        // When
        try await repository.updateNotificationEnabled(true)
        
        // Then
        let settings = try await repository.getSettingsOnce()
        XCTAssertTrue(settings.enableNotification)
    }
    
    /// 앱 테마 업데이트
    func testUpdateAppTheme_ShouldUpdateSuccessfully() async throws {
        // When
        try await repository.updateAppTheme(.natureCalm)
        
        // Then
        let settings = try await repository.getSettingsOnce()
        XCTAssertEqual(settings.appTheme, .natureCalm)
    }
    
    /// 폰트 패밀리 업데이트
    func testUpdateFontFamily_ShouldUpdateSuccessfully() async throws {
        // When
        try await repository.updateFontFamily(.gowunBatang)
        
        // Then
        let settings = try await repository.getSettingsOnce()
        XCTAssertEqual(settings.fontFamily, .gowunBatang)
    }
    
    /// 총 기록 수 업데이트
    func testUpdateTotalRecords_ShouldUpdateSuccessfully() async throws {
        // When
        try await repository.updateTotalRecords(10)
        
        // Then
        let settings = try await repository.getSettingsOnce()
        XCTAssertEqual(settings.totalRecords, 10)
    }
    
    /// 설정 초기화
    func testResetSettings_ShouldResetToDefaults() async throws {
        // Given
        try await repository.updateLocationEnabled(true)
        try await repository.updateThemeMode(.dark)
        try await repository.updateNotificationEnabled(true)
        
        // When
        try await repository.resetSettings()
        
        // Then
        let settings = try await repository.getSettingsOnce()
        XCTAssertEqual(settings.themeMode, .system)
        XCTAssertFalse(settings.enableLocation)
        XCTAssertFalse(settings.enableNotification)
    }
}

