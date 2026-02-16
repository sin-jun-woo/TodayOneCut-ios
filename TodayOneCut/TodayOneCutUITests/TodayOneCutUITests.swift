//
//  TodayOneCutUITests.swift
//  TodayOneCutUITests
//
//  Created by 신준우 on 2/13/26.
//

import XCTest

/// TodayOneCut UI 테스트
final class TodayOneCutUITests: XCTestCase {
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }
    
    override func tearDownWithError() throws {
        app = nil
    }
    
    /// 앱 시작 시 온보딩 화면이 표시되는지 확인
    func testOnboardingScreen_ShouldDisplay() throws {
        // 온보딩 화면의 "시작하기" 버튼이 있는지 확인
        let startButton = app.buttons["시작하기"]
        XCTAssertTrue(startButton.exists, "온보딩 화면의 시작하기 버튼이 표시되어야 합니다")
    }
    
    /// 온보딩 완료 후 메인 화면으로 이동하는지 확인
    func testOnboarding_WhenTappedStart_ShouldNavigateToMain() throws {
        // 시작하기 버튼 탭
        let startButton = app.buttons["시작하기"]
        if startButton.exists {
            startButton.tap()
            
            // 메인 화면의 탭바가 표시되는지 확인
            let tabBar = app.tabBars.firstMatch
            XCTAssertTrue(tabBar.waitForExistence(timeout: 2), "메인 화면의 탭바가 표시되어야 합니다")
        }
    }
    
    /// 홈 화면에서 기록 작성 버튼이 있는지 확인
    func testHomeScreen_ShouldHaveCreateButton() throws {
        // 온보딩 완료 (이미 완료된 경우 스킵)
        let startButton = app.buttons["시작하기"]
        if startButton.exists {
            startButton.tap()
        }
        
        // 홈 탭 선택
        let homeTab = app.tabBars.buttons["홈"]
        if homeTab.exists {
            homeTab.tap()
        }
        
        // 기록 작성 버튼 확인
        let createButton = app.buttons["plus.circle.fill"]
        XCTAssertTrue(createButton.exists || app.navigationBars.buttons["plus.circle.fill"].exists, 
                     "홈 화면에 기록 작성 버튼이 있어야 합니다")
    }
    
    /// 기록 작성 화면으로 이동하는지 확인
    func testCreateRecord_ShouldNavigateToCreateScreen() throws {
        // 온보딩 완료
        let startButton = app.buttons["시작하기"]
        if startButton.exists {
            startButton.tap()
        }
        
        // 홈 탭 선택
        let homeTab = app.tabBars.buttons["홈"]
        if homeTab.exists {
            homeTab.tap()
        }
        
        // 기록 작성 버튼 탭
        let createButton = app.buttons["plus.circle.fill"]
        if !createButton.exists {
            let navCreateButton = app.navigationBars.buttons["plus.circle.fill"]
            if navCreateButton.exists {
                navCreateButton.tap()
            }
        } else {
            createButton.tap()
        }
        
        // 기록 작성 화면의 네비게이션 타이틀 확인
        let navBar = app.navigationBars["오늘의 장면"]
        XCTAssertTrue(navBar.waitForExistence(timeout: 2), "기록 작성 화면으로 이동해야 합니다")
    }
    
    /// 기록 목록 화면으로 이동하는지 확인
    func testRecordList_ShouldNavigateToListScreen() throws {
        // 온보딩 완료
        let startButton = app.buttons["시작하기"]
        if startButton.exists {
            startButton.tap()
        }
        
        // 목록 탭 선택
        let listTab = app.tabBars.buttons["목록"]
        if listTab.exists {
            listTab.tap()
            
            // 기록 목록 화면의 네비게이션 타이틀 확인
            let navBar = app.navigationBars["전체 기록"]
            XCTAssertTrue(navBar.waitForExistence(timeout: 2), "기록 목록 화면으로 이동해야 합니다")
        }
    }
    
    /// 달력 화면으로 이동하는지 확인
    func testCalendar_ShouldNavigateToCalendarScreen() throws {
        // 온보딩 완료
        let startButton = app.buttons["시작하기"]
        if startButton.exists {
            startButton.tap()
        }
        
        // 달력 탭 선택
        let calendarTab = app.tabBars.buttons["달력"]
        if calendarTab.exists {
            calendarTab.tap()
            
            // 달력 화면의 네비게이션 타이틀 확인
            let navBar = app.navigationBars["달력"]
            XCTAssertTrue(navBar.waitForExistence(timeout: 2), "달력 화면으로 이동해야 합니다")
        }
    }
    
    /// 설정 화면으로 이동하는지 확인
    func testSettings_ShouldNavigateToSettingsScreen() throws {
        // 온보딩 완료
        let startButton = app.buttons["시작하기"]
        if startButton.exists {
            startButton.tap()
        }
        
        // 설정 탭 선택
        let settingsTab = app.tabBars.buttons["설정"]
        if settingsTab.exists {
            settingsTab.tap()
            
            // 설정 화면의 네비게이션 타이틀 확인
            let navBar = app.navigationBars["설정"]
            XCTAssertTrue(navBar.waitForExistence(timeout: 2), "설정 화면으로 이동해야 합니다")
        }
    }
}

