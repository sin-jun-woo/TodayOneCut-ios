//
//  ThemeSelectorView.swift
//  TodayOneCut
//
//  Created by 신준우 on 2/13/26.
//

import SwiftUI

/// 테마 선택 뷰
struct ThemeSelectorView: View {
    let currentTheme: ThemeMode
    let onThemeSelected: (ThemeMode) -> Void
    let onDismiss: () -> Void
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(ThemeMode.allCases, id: \.self) { mode in
                    Button {
                        onThemeSelected(mode)
                    } label: {
                        HStack {
                            Text(mode.displayName)
                            Spacer()
                            if currentTheme == mode {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.blue)
                            }
                        }
                    }
                }
            }
            .navigationTitle("테마 선택")
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

