//
//  RecordDetailView.swift
//  TodayOneCut
//
//  Created by 신준우 on 2/13/26.
//

import SwiftUI

/// 기록 상세 화면
struct RecordDetailView: View {
    @StateObject private var viewModel: RecordDetailViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var showDeleteAlert = false
    
    init(recordId: Int64, viewModel: RecordDetailViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                if viewModel.isLoading {
                    LoadingView()
                        .frame(height: 200)
                } else if let record = viewModel.record {
                    // 날짜
                    Text(record.date.toDisplayDateString())
                        .font(.title2)
                        .fontWeight(.bold)
                        .padding(.horizontal)
                    
                    // 사진
                    if let photoPath = record.photoPath {
                        AsyncImage(url: URL(fileURLWithPath: photoPath)) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                        } placeholder: {
                            Rectangle()
                                .fill(Color.gray.opacity(0.3))
                                .overlay {
                                    ProgressView()
                                }
                        }
                        .frame(maxHeight: 400)
                        .cornerRadius(12)
                        .padding(.horizontal)
                    }
                    
                    // 텍스트
                    if let contentText = record.contentText, !contentText.isEmpty {
                        Text(contentText)
                            .font(.body)
                            .padding(.horizontal)
                    }
                    
                    // 위치 정보
                    if let location = record.location, let locationName = location.name {
                        HStack {
                            Image(systemName: "location.fill")
                                .foregroundColor(.secondary)
                            Text(locationName)
                                .foregroundColor(.secondary)
                        }
                        .padding(.horizontal)
                    }
                    
                    // 수정 여부
                    if record.updateCount > 0 {
                        HStack {
                            Image(systemName: "pencil")
                                .foregroundColor(.secondary)
                            Text("수정됨 (\(record.updateCount)회)")
                                .foregroundColor(.secondary)
                        }
                        .padding(.horizontal)
                    }
                    
                    // 생성 시간
                    if let createdAt = record.createdAt as Date? {
                        Text("생성: \(createdAt.toDisplayDateTimeString())")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .padding(.horizontal)
                    }
                } else {
                    EmptyStateView(
                        message: viewModel.errorMessage ?? "기록을 불러올 수 없습니다",
                        actionText: nil,
                        action: nil
                    )
                }
            }
            .padding(.vertical)
        }
        .navigationTitle("기록 상세")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu {
                    if let record = viewModel.record, record.canUpdate {
                        Button {
                            // TODO: 수정 화면으로 이동
                        } label: {
                            Label("수정", systemImage: "pencil")
                        }
                    }
                    
                    Button(role: .destructive) {
                        showDeleteAlert = true
                    } label: {
                        Label("삭제", systemImage: "trash")
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                }
            }
        }
        .alert("기록 삭제", isPresented: $showDeleteAlert) {
            Button("취소", role: .cancel) {}
            Button("삭제", role: .destructive) {
                Task {
                    let success = await viewModel.deleteRecord()
                    if success {
                        dismiss()
                    }
                }
            }
        } message: {
            Text("이 기록을 삭제하시겠어요?")
        }
        .onAppear {
            viewModel.loadRecord()
        }
    }
}

#Preview {
    NavigationStack {
        RecordDetailView(
            recordId: 1,
            viewModel: RecordDetailViewModel(
                recordId: 1,
                getRecordByIdUseCase: GetRecordByIdUseCase(
                    recordRepository: RecordRepositoryImpl(
                        coreDataStack: CoreDataStack.shared,
                        recordMapper: RecordMapper()
                    )
                ),
                deleteRecordUseCase: DeleteRecordUseCase(
                    recordRepository: RecordRepositoryImpl(
                        coreDataStack: CoreDataStack.shared,
                        recordMapper: RecordMapper()
                    ),
                    fileRepository: FileRepositoryImpl()
                )
            )
        )
    }
}

