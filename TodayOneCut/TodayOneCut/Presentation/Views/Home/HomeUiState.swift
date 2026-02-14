//
//  HomeUiState.swift
//  TodayOneCut
//
//  Created by 신준우 on 2/13/26.
//

import Foundation

/// 홈 화면 UI 상태
struct HomeUiState {
    var todayRecord: Record?
    var isLoading: Bool = false
    var errorMessage: String?
    var hasTodayRecord: Bool = false
}

