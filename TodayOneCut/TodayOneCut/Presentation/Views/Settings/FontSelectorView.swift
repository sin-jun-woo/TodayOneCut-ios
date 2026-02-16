//
//  FontSelectorView.swift
//  TodayOneCut
//
//  Created by 신준우 on 2/13/26.
//

import SwiftUI

/// 폰트 선택 뷰
struct FontSelectorView: View {
    let currentFont: AppFont
    let onFontSelected: (AppFont) -> Void
    let onDismiss: () -> Void
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(AppFont.allCases, id: \.self) { font in
                    Button {
                        onFontSelected(font)
                    } label: {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(font.displayName)
                                .font(.appFont(font))
                            
                            Text("가장 기억하고 싶은 순간")
                                .font(.appFont(font, size: 14))
                                .foregroundColor(.secondary)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .overlay(alignment: .trailing) {
                            if currentFont == font {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.blue)
                            }
                        }
                    }
                }
            }
            .navigationTitle("폰트 선택")
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
}

