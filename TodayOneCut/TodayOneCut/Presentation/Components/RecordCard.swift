//
//  RecordCard.swift
//  TodayOneCut
//
//  Created by 신준우 on 2/13/26.
//

import SwiftUI

/// 기록 카드 컴포넌트
struct RecordCard: View {
    let record: Record
    let onTap: (() -> Void)?
    
    @State private var isPressed = false
    
    init(record: Record, onTap: (() -> Void)? = nil) {
        self.record = record
        self.onTap = onTap
    }
    
    var body: some View {
        Button(action: {
            onTap?()
        }) {
            VStack(alignment: .leading, spacing: 12) {
                // 날짜
                Text(record.date.toDisplayDateString())
                    .font(.headline)
                    .foregroundColor(.primary)
                
                // 사진 또는 텍스트
                if let photoPath = record.photoPath {
                    AsyncImage(url: URL(fileURLWithPath: photoPath)) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    } placeholder: {
                        Rectangle()
                            .fill(Color.gray.opacity(0.3))
                            .overlay {
                                ProgressView()
                            }
                    }
                    .frame(height: 200)
                    .cornerRadius(12)
                    .clipped()
                }
                
                if let contentText = record.contentText, !contentText.isEmpty {
                    Text(contentText)
                        .font(.body)
                        .foregroundColor(.secondary)
                        .lineLimit(3)
                }
                
                // 위치 정보
                if let location = record.location, let locationName = location.name {
                    HStack(spacing: 4) {
                        Image(systemName: "location.fill")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Text(locationName)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
                // 수정 여부
                if record.updateCount > 0 {
                    HStack(spacing: 4) {
                        Image(systemName: "pencil")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Text("수정됨")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(16)
            .shadow(color: Color.black.opacity(0.1), radius: isPressed ? 4 : 8, x: 0, y: isPressed ? 1 : 2)
            .scaleEffect(isPressed ? 0.98 : 1.0)
            .animation(.spring(response: 0.1, dampingFraction: 0.7), value: isPressed)
        }
        .buttonStyle(PlainButtonStyle())
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in
                    if !isPressed {
                        isPressed = true
                    }
                }
                .onEnded { _ in
                    isPressed = false
                }
        )
    }
}

#Preview {
    RecordCard(
        record: Record(
            date: Date(),
            type: .photo,
            contentText: "오늘의 장면",
            photoPath: nil,
            location: Location(latitude: 37.5665, longitude: 126.9780, name: "서울")
        ),
        onTap: {}
    )
    .padding()
}

