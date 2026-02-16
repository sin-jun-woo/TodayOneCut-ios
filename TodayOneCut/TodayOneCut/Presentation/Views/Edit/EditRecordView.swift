//
//  EditRecordView.swift
//  TodayOneCut
//
//  Created by 신준우 on 2/13/26.
//

import SwiftUI
import PhotosUI
import Photos

/// 기록 수정 화면
struct EditRecordView: View {
    @StateObject private var viewModel: EditRecordViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var showGalleryPicker = false
    @State private var showCamera = false
    
    init(recordId: Int64, viewModel: EditRecordViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        Form {
            // 이미지 섹션
            Section {
                if let image = viewModel.selectedImage {
                    VStack {
                        Image(uiImage: image)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(maxHeight: 300)
                            .cornerRadius(12)
                        
                        HStack {
                            Button("사진 변경") {
                                if showCamera {
                                    showCamera = false
                                    Task { @MainActor in
                                        try? await Task.sleep(nanoseconds: 300_000_000)
                                        showGalleryPicker = true
                                    }
                                } else {
                                    showGalleryPicker = true
                                }
                            }
                            
                            Spacer()
                            
                            Button("사진 제거") {
                                viewModel.removeImage()
                            }
                            .foregroundColor(.red)
                        }
                    }
                } else {
                    HStack {
                        Button {
                            if showCamera {
                                showCamera = false
                                Task { @MainActor in
                                    try? await Task.sleep(nanoseconds: 300_000_000)
                                    showGalleryPicker = true
                                }
                            } else {
                                showGalleryPicker = true
                            }
                        } label: {
                            Label("갤러리에서 선택", systemImage: "photo.on.rectangle")
                        }
                        
                        Spacer()
                        
                        Button {
                            if showGalleryPicker {
                                showGalleryPicker = false
                                Task { @MainActor in
                                    try? await Task.sleep(nanoseconds: 300_000_000)
                                    showCamera = true
                                }
                            } else {
                                showCamera = true
                            }
                        } label: {
                            Label("카메라로 촬영", systemImage: "camera")
                        }
                    }
                }
            } header: {
                Text("사진")
            }
            
            // 텍스트 섹션
            Section {
                TextField("오늘의 장면을 기록해보세요", text: $viewModel.contentText, axis: .vertical)
                    .lineLimit(5...10)
            } header: {
                Text("내용")
            }
            
            // 위치 정보
            if let record = viewModel.record, let location = record.location, let locationName = location.name {
                Section {
                    HStack {
                        Image(systemName: "location.fill")
                            .foregroundColor(.secondary)
                        Text(locationName)
                            .foregroundColor(.secondary)
                    }
                } header: {
                    Text("위치")
                }
            }
            
            // 수정 횟수 제한 안내
            if let record = viewModel.record {
                Section {
                    if record.updateCount >= Constants.Record.maxUpdateCount {
                        Text("수정 횟수를 초과했습니다. 더 이상 수정할 수 없습니다.")
                            .foregroundColor(.red)
                            .font(.caption)
                    } else {
                        Text("수정 가능 횟수: \(Constants.Record.maxUpdateCount - record.updateCount)회 남음")
                            .foregroundColor(.secondary)
                            .font(.caption)
                    }
                } header: {
                    Text("수정 정보")
                }
            }
            
            // 에러 메시지
            if let errorMessage = viewModel.errorMessage {
                Section {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .font(.caption)
                }
            }
        }
        .navigationTitle("기록 수정")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button("취소") {
                    dismiss()
                }
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("저장") {
                    Task {
                        let success = await viewModel.saveRecord()
                        if success {
                            dismiss()
                        }
                    }
                }
                .disabled(
                    viewModel.isLoading ||
                    (viewModel.contentText.isEmpty && viewModel.imageData == nil) ||
                    (viewModel.record?.updateCount ?? 0 >= Constants.Record.maxUpdateCount)
                )
            }
        }
        .sheet(isPresented: $showGalleryPicker) {
            PhotoLibraryPicker(isPresented: $showGalleryPicker) { image in
                viewModel.setImage(image)
                showGalleryPicker = false
            }
        }
        .fullScreenCover(isPresented: $showCamera) {
            CameraView { image in
                viewModel.setImage(image)
                showCamera = false
            }
        }
        .onAppear {
            viewModel.loadRecord()
        }
    }
}

#Preview {
    NavigationStack {
        EditRecordView(
            recordId: 1,
            viewModel: EditRecordViewModel(
                recordId: 1,
                getRecordByIdUseCase: GetRecordByIdUseCase(
                    recordRepository: RecordRepositoryImpl(
                        coreDataStack: CoreDataStack.shared,
                        recordMapper: RecordMapper()
                    )
                ),
                updateRecordUseCase: UpdateRecordUseCase(
                    recordRepository: RecordRepositoryImpl(
                        coreDataStack: CoreDataStack.shared,
                        recordMapper: RecordMapper()
                    ),
                    fileRepository: FileRepositoryImpl(),
                    validateUpdateLimit: ValidateUpdateLimitUseCase()
                ),
                getSettingsUseCase: GetSettingsUseCase(
                    settingsRepository: SettingsRepositoryImpl(
                        coreDataStack: CoreDataStack.shared,
                        settingsMapper: SettingsMapper()
                    )
                )
            )
        )
        .navigationBarTitleDisplayMode(.inline)
    }
}

