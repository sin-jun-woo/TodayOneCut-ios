//
//  HomeViewModelTests.swift
//  TodayOneCutTests
//
//  Created by 신준우 on 2/13/26.
//

import XCTest
import Combine
@testable import TodayOneCut

/// Home ViewModel 테스트
@MainActor
final class HomeViewModelTests: XCTestCase {
    var viewModel: HomeViewModel!
    var mockGetTodayRecord: MockGetTodayRecordUseCase!
    var mockCheckTodayRecordExists: MockCheckTodayRecordExistsUseCase!
    var mockRecordRepository: MockRecordRepository!
    var mockSettingsRepository: MockSettingsRepository!
    
    override func setUp() {
        super.setUp()
        mockGetTodayRecord = MockGetTodayRecordUseCase()
        mockCheckTodayRecordExists = MockCheckTodayRecordExistsUseCase()
        mockRecordRepository = MockRecordRepository()
        mockSettingsRepository = MockSettingsRepository()
        
        viewModel = HomeViewModel(
            getTodayRecordUseCase: mockGetTodayRecord,
            checkTodayRecordExistsUseCase: mockCheckTodayRecordExists,
            recordRepository: mockRecordRepository,
            settingsRepository: mockSettingsRepository
        )
    }
    
    override func tearDown() {
        viewModel = nil
        mockGetTodayRecord = nil
        mockCheckTodayRecordExists = nil
        mockRecordRepository = nil
        mockSettingsRepository = nil
        super.tearDown()
    }
    
    /// 오늘의 기록 로드 성공
    func testLoadTodayRecord_WhenRecordExists_ShouldUpdateState() async {
        // Given
        let today = Date()
        let record = Record(
            id: 1,
            date: today,
            type: .text,
            contentText: "오늘의 기록",
            photoPath: nil,
            location: nil,
            createdAt: today
        )
        mockCheckTodayRecordExists.result = true
        mockGetTodayRecord.result = record
        
        // When
        viewModel.loadTodayRecord()
        
        // Then
        // 비동기 작업 완료 대기
        try? await Task.sleep(nanoseconds: 500_000_000) // 0.5초 대기
        XCTAssertTrue(viewModel.uiState.hasTodayRecord)
        XCTAssertEqual(viewModel.uiState.todayRecord?.id, record.id)
        XCTAssertFalse(viewModel.uiState.isLoading)
    }
    
    /// 오늘의 기록이 없는 경우
    func testLoadTodayRecord_WhenNoRecord_ShouldShowEmptyState() async {
        // Given
        mockCheckTodayRecordExists.result = false
        mockGetTodayRecord.result = nil
        
        // When
        viewModel.loadTodayRecord()
        
        // Then
        // 비동기 작업 완료 대기
        try? await Task.sleep(nanoseconds: 500_000_000) // 0.5초 대기
        XCTAssertFalse(viewModel.uiState.hasTodayRecord)
        XCTAssertNil(viewModel.uiState.todayRecord)
        XCTAssertFalse(viewModel.uiState.isLoading)
    }
    
    /// 총 기록 수 업데이트 확인
    func testObserveTotalRecords_ShouldUpdateTotalCount() async {
        // Given
        let records = [
            Record(id: 1, date: Date(), type: .text, contentText: "기록1", photoPath: nil, location: nil, createdAt: Date()),
            Record(id: 2, date: Date(), type: .text, contentText: "기록2", photoPath: nil, location: nil, createdAt: Date())
        ]
        mockRecordRepository.getAllRecordsResult = records
        
        // When
        // observeTotalRecords는 init에서 자동 호출됨
        // Publisher 업데이트 대기
        try? await Task.sleep(nanoseconds: 500_000_000) // 0.5초 대기
        
        // Then
        XCTAssertEqual(viewModel.uiState.totalRecords, 2)
    }
}

/// Mock GetTodayRecordUseCase
class MockGetTodayRecordUseCase {
    var result: Record?
    var error: Error?
    
    func execute() async throws -> Record? {
        if let error = error {
            throw error
        }
        return result
    }
}

/// Mock CheckTodayRecordExistsUseCase
class MockCheckTodayRecordExistsUseCase {
    var result: Bool = false
    var error: Error?
    
    func execute() async throws -> Bool {
        if let error = error {
            throw error
        }
        return result
    }
}

/// Mock SettingsRepository
class MockSettingsRepository: SettingsRepository {
    var settings: AppSettings = AppSettings(
        themeMode: .system,
        enableLocation: false,
        enableNotification: false,
        appTheme: .warmCozy,
        fontFamily: .systemSerif,
        totalRecords: 0
    )
    
    func getSettings() -> AnyPublisher<AppSettings, Never> {
        return Just(settings).eraseToAnyPublisher()
    }
    
    func getSettingsOnce() async throws -> AppSettings {
        return settings
    }
    
    func updateLocationSetting(_ enabled: Bool) async throws {
        settings.enableLocation = enabled
    }
    
    func updateTheme(_ theme: ThemeMode) async throws {
        settings.themeMode = theme
    }
    
    func markFirstLaunchComplete() async throws {
        // Mock implementation
    }
    
    func updateNotificationEnabled(_ enabled: Bool) async throws {
        settings.enableNotification = enabled
    }
    
    func updateAppTheme(_ theme: AppTheme) async throws {
        settings.appTheme = theme
    }
    
    func updateFontFamily(_ font: AppFont) async throws {
        settings.fontFamily = font
    }
    
    func resetSettings() async throws {
        settings = AppSettings(
            themeMode: .system,
            enableLocation: false,
            enableNotification: false,
            appTheme: .warmCozy,
            fontFamily: .systemSerif,
            totalRecords: 0
        )
    }
    
    func updateTotalRecords(_ count: Int) async throws {
        settings.totalRecords = count
    }
}

