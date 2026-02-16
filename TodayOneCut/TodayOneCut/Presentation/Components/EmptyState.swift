//
//  EmptyState.swift
//  TodayOneCut
//
//  Created by 신준우 on 2/13/26.
//

import SwiftUI

/// 빈 상태 뷰
struct EmptyStateView: View {
    let message: String
    let actionText: String?
    let action: (() -> Void)?
    
    @State private var animated = false
    
    init(
        message: String,
        actionText: String? = nil,
        action: (() -> Void)? = nil
    ) {
        self.message = message
        self.actionText = actionText
        self.action = action
    }
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "photo.on.rectangle.angled")
                .font(.system(size: 60))
                .foregroundColor(.secondary)
            
            Text(message)
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            if let actionText = actionText, let action = action {
                Button(action: action) {
                    Text(actionText)
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 12)
                        .background(Color.accentColor)
                        .cornerRadius(8)
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .opacity(animated ? 1.0 : 0.0)
        .onAppear {
            withAnimation(.easeInOut(duration: 0.6)) {
                animated = true
            }
        }
    }
}

#Preview {
    EmptyStateView(
        message: "아직 오늘의 장면을 남기지 않았어요",
        actionText: "오늘의 장면 남기기",
        action: {}
    )
}

