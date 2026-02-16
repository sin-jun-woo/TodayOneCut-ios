//
//  AppThemeSelectorView.swift
//  TodayOneCut
//
//  Created by 신준우 on 2/13/26.
//

import SwiftUI

/// 앱 테마 선택 뷰
struct AppThemeSelectorView: View {
    let currentTheme: AppTheme
    let onThemeSelected: (AppTheme) -> Void
    let onDismiss: () -> Void
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(AppTheme.allCases, id: \.self) { theme in
                    Button {
                        onThemeSelected(theme)
                    } label: {
                        HStack {
                            // 테마 색상 원형 표시
                            Circle()
                                .fill(getThemeColor(theme))
                                .frame(width: 24, height: 24)
                            
                            Text(theme.displayName)
                            
                            Spacer()
                            
                            if currentTheme == theme {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.blue)
                            }
                        }
                    }
                }
            }
            .navigationTitle("앱 테마 선택")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("취소") {
                        onDismiss()
                    }
                }
            }
        }
    }
    
    private func getThemeColor(_ theme: AppTheme) -> Color {
        switch theme {
        case .warmCozy:
            return Color.WarmCozy.primary
        case .natureCalm:
            return Color.NatureCalm.primary
        case .deepEmotional:
            return Color.DeepEmotional.primary
        }
    }
}

