//
//  AppRoute.swift
//  TodayOneCut
//
//  Created by 신준우 on 2/13/26.
//

import Foundation

/// 앱 네비게이션 라우트
enum AppRoute: Hashable {
    case home
    case create
    case list
    case detail(recordId: Int64)
    case edit(recordId: Int64)
    case calendar
    case settings
    case onboarding
    case privacyPolicy
    case openSourceLicense
}

