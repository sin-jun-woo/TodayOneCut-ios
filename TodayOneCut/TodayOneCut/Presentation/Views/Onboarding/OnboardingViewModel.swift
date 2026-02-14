//
//  OnboardingViewModel.swift
//  TodayOneCut
//
//  Created by 신준우 on 2/13/26.
//

import Foundation

/// 온보딩 화면 ViewModel
@MainActor
class OnboardingViewModel: ObservableObject {
    @Published var currentPage: Int = 0
    
    private let markFirstLaunchCompleteUseCase: MarkFirstLaunchCompleteUseCase
    
    let pages: [OnboardingPage] = [
        OnboardingPage(
            title: "하루에 하나만",
            description: "오늘 가장 기억에 남는\n한 장면만 기록하세요",
            imageName: "photo.on.rectangle.angled"
        ),
        OnboardingPage(
            title: "간단하게 기록",
            description: "사진과 텍스트로\n오늘의 장면을 남겨보세요",
            imageName: "camera.fill"
        ),
        OnboardingPage(
            title: "언제든 확인",
            description: "달력으로 언제든\n과거 기록을 확인할 수 있어요",
            imageName: "calendar"
        )
    ]
    
    init(markFirstLaunchCompleteUseCase: MarkFirstLaunchCompleteUseCase) {
        self.markFirstLaunchCompleteUseCase = markFirstLaunchCompleteUseCase
    }
    
    /// 다음 페이지로
    func nextPage() {
        if currentPage < pages.count - 1 {
            currentPage += 1
        }
    }
    
    /// 이전 페이지로
    func previousPage() {
        if currentPage > 0 {
            currentPage -= 1
        }
    }
    
    /// 온보딩 완료
    func completeOnboarding() async {
        do {
            try await markFirstLaunchCompleteUseCase.execute()
        } catch {
            // 에러 무시 (설정 저장 실패해도 계속 진행)
        }
    }
}

/// 온보딩 페이지 데이터
struct OnboardingPage {
    let title: String
    let description: String
    let imageName: String
}

