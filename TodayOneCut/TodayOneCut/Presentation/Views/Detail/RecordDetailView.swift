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
    @AppStorage("appTheme") private var appThemeString: String = AppTheme.warmCozy.rawValue
    @State private var showDeleteAlert = false
    @State private var showImageViewer = false
    
    private var themePrimary: Color {
        let appTheme = AppTheme(rawValue: appThemeString) ?? .warmCozy
        return getColorForAppTheme(appTheme).primary
    }
    
    init(recordId: Int64, viewModel: RecordDetailViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                if viewModel.isLoading {
                    LoadingView()
                        .frame(height: 200)
                } else if let record = viewModel.record {
                    // 날짜 헤더
                    DateHeader(date: record.date)
                    
                    // 타입 뱃지
                    HStack {
                        Text(record.type == .photo ? "사진 기록" : "텍스트 기록")
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundColor(record.type == .photo ? Color.blue : Color.green)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(record.type == .photo ? Color.blue.opacity(0.1) : Color.green.opacity(0.1))
                            )
                        Spacer()
                    }
                    .padding(.horizontal)
                    
                    // 내용 카드
                    VStack(alignment: .leading, spacing: 16) {
                        if record.type == .photo {
                            if let photoPath = record.photoPath {
                                AsyncImage(url: URL(fileURLWithPath: photoPath)) { image in
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                } placeholder: {
                                    Rectangle()
                                        .fill(themePrimary.opacity(0.1))
                                        .overlay {
                                            ProgressView()
                                        }
                                }
                                .frame(maxHeight: 400)
                                .cornerRadius(16)
                                .onTapGesture {
                                    showImageViewer = true
                                }
                            }
                            
                            if let contentText = record.contentText, !contentText.isEmpty {
                                Text(contentText)
                                    .font(.body)
                                    .foregroundColor(.primary)
                            }
                        } else {
                            if let contentText = record.contentText, !contentText.isEmpty {
                                Text(contentText)
                                    .font(.body)
                                    .foregroundColor(.primary)
                            }
                        }
                    }
                    .padding(20)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color(.systemBackground))
                            .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 2)
                    )
                    .padding(.horizontal)
                    
                    // 위치 정보 카드 (있는 경우)
                    if let location = record.location, let locationName = location.name {
                        HStack(spacing: 12) {
                            Image(systemName: "location.fill")
                                .foregroundColor(.blue)
                                .font(.system(size: 24))
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text("위치")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                Text(locationName)
                                    .font(.body)
                                    .fontWeight(.medium)
                                    .foregroundColor(.primary)
                            }
                            
                            Spacer()
                        }
                        .padding(20)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color(.secondarySystemBackground))
                                .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 2)
                        )
                        .padding(.horizontal)
                    }
                    
                    // 날짜/시간 정보 카드
                    VStack(alignment: .leading, spacing: 12) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("작성 시간")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            if let createdAt = record.createdAt as Date? {
                                Text(createdAt.toDisplayDateTimeString())
                                    .font(.body)
                                    .fontWeight(.medium)
                                    .foregroundColor(.primary)
                            }
                        }
                        
                        if let updatedAt = record.updatedAt as Date? {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("수정 시간")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                Text(updatedAt.toDisplayDateTimeString())
                                    .font(.body)
                                    .fontWeight(.medium)
                                    .foregroundColor(.primary)
                            }
                        }
                    }
                    .padding(20)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color(.secondarySystemBackground))
                            .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 2)
                    )
                    .padding(.horizontal)
                } else {
                    EmptyStateView(
                        message: viewModel.errorMessage ?? "기록을 불러올 수 없습니다",
                        actionText: nil,
                        action: nil
                    )
                }
            }
            .padding(.vertical, 20)
        }
        .navigationTitle("기록 상세")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu {
                    if let record = viewModel.record, record.canUpdate {
                        NavigationLink(value: AppRoute.edit(recordId: record.id)) {
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
        .fullScreenCover(isPresented: $showImageViewer) {
            if let photoPath = viewModel.record?.photoPath {
                ImageViewer(imagePath: photoPath) {
                    showImageViewer = false
                }
            }
        }
        .onAppear {
            viewModel.loadRecord()
        }
        .toast(message: $viewModel.toastMessage)
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

