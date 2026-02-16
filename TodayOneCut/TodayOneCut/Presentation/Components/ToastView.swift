//
//  ToastView.swift
//  TodayOneCut
//
//  Created by 신준우 on 2/13/26.
//

import SwiftUI

/// Toast 메시지 뷰
struct ToastView: View {
    let message: String
    @Binding var isPresented: Bool
    
    var body: some View {
        VStack {
            Spacer()
            
            if isPresented {
                Text(message)
                    .font(.body)
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.black.opacity(0.8))
                    )
                    .padding(.bottom, 50)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                    .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isPresented)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .allowsHitTesting(false)
    }
}

/// Toast 메시지를 표시하는 ViewModifier
struct ToastModifier: ViewModifier {
    @Binding var message: String?
    @State private var isPresented = false
    
    func body(content: Content) -> some View {
        ZStack {
            content
            
            if let message = message {
                ToastView(message: message, isPresented: $isPresented)
                    .onChange(of: message) { _ in
                        isPresented = true
                        // 2초 후 자동으로 사라짐
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            isPresented = false
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                self.message = nil
                            }
                        }
                    }
                    .onAppear {
                        isPresented = true
                        // 2초 후 자동으로 사라짐
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            isPresented = false
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                self.message = nil
                            }
                        }
                    }
            }
        }
    }
}

extension View {
    /// Toast 메시지 표시
    func toast(message: Binding<String?>) -> some View {
        modifier(ToastModifier(message: message))
    }
}

