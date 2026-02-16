//
//  DateHeader.swift
//  TodayOneCut
//
//  Created by 신준우 on 2/13/26.
//

import SwiftUI

/// 날짜 헤더 컴포넌트
struct DateHeader: View {
    let date: Date
    
    var body: some View {
        HStack {
            Spacer()
            Text(date.toDisplayDateString())
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.primary)
                .padding(.vertical, 16)
                .padding(.horizontal, 20)
            Spacer()
        }
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.primary.opacity(0.1))
        )
        .padding(.horizontal, 20)
    }
}

#Preview {
    VStack {
        DateHeader(date: Date())
    }
    .padding()
}

