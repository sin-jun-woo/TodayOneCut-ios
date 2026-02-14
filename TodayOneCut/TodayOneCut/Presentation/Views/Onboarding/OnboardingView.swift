//
//  OnboardingView.swift
//  TodayOneCut
//
//  Created by 신준우 on 2/13/26.
//

import SwiftUI

/// 온보딩 화면
struct OnboardingView: View {
    @StateObject private var viewModel: OnboardingViewModel
    @Environment(\.dismiss) private var dismiss
    
    init(viewModel: OnboardingViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // 페이지 인디케이터
            TabView(selection: $viewModel.currentPage) {
                ForEach(0..<viewModel.pages.count, id: \.self) { index in
                    OnboardingPageView(page: viewModel.pages[index])
                        .tag(index)
                }
            }
            .tabViewStyle(.page)
            .indexViewStyle(.page(backgroundDisplayMode: .always))
            
            // 네비게이션 버튼
            HStack {
                if viewModel.currentPage > 0 {
                    Button("이전") {
                        viewModel.previousPage()
                    }
                    .foregroundColor(.secondary)
                }
                
                Spacer()
                
                if viewModel.currentPage < viewModel.pages.count - 1 {
                    Button("다음") {
                        viewModel.nextPage()
                    }
                    .buttonStyle(.borderedProminent)
                } else {
                    Button("시작하기") {
                        Task {
                            await viewModel.completeOnboarding()
                            dismiss()
                        }
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
            .padding()
        }
        .navigationBarBackButtonHidden(true)
    }
}

/// 온보딩 페이지 뷰
struct OnboardingPageView: View {
    let page: OnboardingPage
    
    var body: some View {
        VStack(spacing: 32) {
            Spacer()
            
            // 아이콘
            Image(systemName: page.imageName)
                .font(.system(size: 80))
                .foregroundColor(.accentColor)
            
            // 제목
            Text(page.title)
                .font(.largeTitle)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
            
            // 설명
            Text(page.description)
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            
            Spacer()
        }
    }
}

#Preview {
    NavigationStack {
        OnboardingView(
            viewModel: OnboardingViewModel(
                markFirstLaunchCompleteUseCase: MarkFirstLaunchCompleteUseCase(
                    settingsRepository: SettingsRepositoryImpl(
                        coreDataStack: CoreDataStack.shared,
                        settingsMapper: SettingsMapper()
                    )
                )
            )
        )
    }
}

