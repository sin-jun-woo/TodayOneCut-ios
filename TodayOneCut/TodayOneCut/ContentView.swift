//
//  ContentView.swift
//  TodayOneCut
//
//  Created by 신준우 on 2/13/26.
//

import SwiftUI

/// 기본 ContentView (임시)
/// Phase 3에서 HomeView로 교체 예정
struct ContentView: View {
    var body: some View {
        VStack {
            Text("오늘의 한 컷")
                .font(.largeTitle)
                .padding()
            
            Text("Phase 3에서 HomeView로 교체 예정")
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
}

#Preview {
    ContentView()
}
