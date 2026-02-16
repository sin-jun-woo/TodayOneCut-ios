//
//  ErrorMessage.swift
//  TodayOneCut
//
//  Created by 신준우 on 2/13/26.
//

import SwiftUI

/// 에러 메시지 컴포넌트
struct ErrorMessage: View {
    let message: String
    let onRetry: (() -> Void)?
    
    init(message: String, onRetry: (() -> Void)? = nil) {
        self.message = message
        self.onRetry = onRetry
    }
    
    var body: some View {
        VStack(spacing: 16) {
            VStack(spacing: 12) {
                Text("⚠️")
                    .font(.system(size: 48))
                
                Text(message)
                    .font(.body)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(.systemRed).opacity(0.1))
            )
            
            if let onRetry = onRetry {
                Button(action: onRetry) {
                    Text("다시 시도")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 12)
                        .background(Color.accentColor)
                        .cornerRadius(8)
                }
            }
        }
        .padding(24)
    }
}

#Preview {
    ErrorMessage(
        message: "기록을 불러올 수 없습니다",
        onRetry: {}
    )
}

