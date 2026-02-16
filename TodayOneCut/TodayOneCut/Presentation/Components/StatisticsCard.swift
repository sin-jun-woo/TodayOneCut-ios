//
//  StatisticsCard.swift
//  TodayOneCut
//
//  Created by 신준우 on 2/13/26.
//

import SwiftUI

/// 통계 카드 컴포넌트
struct StatisticsCard: View {
    let totalRecords: Int
    
    var body: some View {
        HStack(spacing: 4) {
            Text("총 ")
                .font(.body)
                .foregroundColor(.secondary)
            
            Text("\(totalRecords)")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            Text("개의 기록")
                .font(.body)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemGray6))
        )
    }
}

#Preview {
    StatisticsCard(totalRecords: 42)
        .padding()
}

