//
//  CreateRecordView.swift
//  TodayOneCut
//
//  Created by 신준우 on 2/13/26.
//

import SwiftUI
import PhotosUI
import Photos

/// 기록 작성 화면
struct CreateRecordView: View {
    @StateObject private var viewModel: CreateRecordViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var showGalleryPicker: Bool = false
    @State private var showCamera: Bool = false
    
    init(viewModel: CreateRecordViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        Form {
            // 기록 타입 선택
            Section {
                VStack(alignment: .leading, spacing: 12) {
                    Text("어떤 순간을 남기시나요?")
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    HStack(spacing: 12) {
                        RecordTypeCard(
                            type: .photo,
                            isSelected: viewModel.recordType == .photo,
                            onSelect: { viewModel.selectRecordType(.photo) }
                        )
                        
                        RecordTypeCard(
                            type: .text,
                            isSelected: viewModel.recordType == .text,
                            onSelect: { viewModel.selectRecordType(.text) }
                        )
                    }
                }
                .padding(.vertical, 8)
            } header: {
                Text("기록 타입")
            }
            
            // 사진/텍스트 입력 영역
            if let recordType = viewModel.recordType {
                if recordType == .photo {
                    // 이미지 섹션
                    Section {
                        if let image = viewModel.selectedImage {
                            VStack {
                                Image(uiImage: image)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(maxHeight: 300)
                                    .cornerRadius(12)
                                
                                HStack(spacing: 12) {
                                    Button {
                                        showCamera = false
                                        showGalleryPicker = true
                                    } label: {
                                        Text("다시 선택")
                                            .frame(maxWidth: .infinity)
                                            .padding()
                                            .background(Color.blue)
                                            .foregroundColor(.white)
                                            .cornerRadius(8)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                    
                                    Button("제거") {
                                        viewModel.removeImage()
                                    }
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.gray.opacity(0.2))
                                    .foregroundColor(.red)
                                    .cornerRadius(8)
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                        } else {
                            VStack(spacing: 12) {
                                Button {
                                    showCamera = false
                                    showGalleryPicker = true
                                } label: {
                                    HStack {
                                        Image(systemName: "photo.on.rectangle")
                                        Text("갤러리에서 선택")
                                    }
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.blue.opacity(0.1))
                                    .foregroundColor(.blue)
                                    .cornerRadius(8)
                                }
                                .buttonStyle(PlainButtonStyle())
                                
                                Button {
                                    showGalleryPicker = false
                                    showCamera = true
                                } label: {
                                    HStack {
                                        Image(systemName: "camera")
                                        Text("카메라로 촬영")
                                    }
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.green.opacity(0.1))
                                    .foregroundColor(.green)
                                    .cornerRadius(8)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                    } header: {
                        Text("사진으로 남기기")
                    }
                    
                    // 메모 섹션
                    Section {
                        TextField("사진에 대한 메모를 입력하세요", text: $viewModel.contentText, axis: .vertical)
                            .lineLimit(5...10)
                    } header: {
                        Text("메모 (선택사항)")
                    }
                } else {
                    // 텍스트 섹션
                    Section {
                        TextField("오늘의 기록을 입력하세요", text: $viewModel.contentText, axis: .vertical)
                            .lineLimit(5...10)
                        
                        HStack {
                            Spacer()
                            Text("\(viewModel.contentText.count) / \(Constants.Text.maxContentLength)자")
                                .font(.caption)
                                .foregroundColor(viewModel.contentText.count > Constants.Text.maxContentLength ? .red : .secondary)
                        }
                    } header: {
                        Text("글로 남기기")
                    }
                }
            }
            
            // 위치 정보
            if let location = viewModel.location, let locationName = location.name {
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
            
            // 에러 메시지
            if let errorMessage = viewModel.errorMessage {
                Section {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .font(.caption)
                }
            }
        }
        .navigationTitle("오늘의 장면")
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
                .disabled(viewModel.isLoading || viewModel.recordType == nil || (viewModel.contentText.isEmpty && viewModel.imageData == nil))
            }
        }
        .sheet(isPresented: Binding(
            get: { showGalleryPicker && !showCamera },
            set: { newValue in
                if !newValue {
                    showGalleryPicker = false
                }
            }
        )) {
            PhotoLibraryPicker(isPresented: Binding(
                get: { showGalleryPicker && !showCamera },
                set: { newValue in
                    if !newValue {
                        showGalleryPicker = false
                    }
                }
            )) { image in
                print("✅ 갤러리에서 이미지 선택됨")
                viewModel.setImage(image)
                showGalleryPicker = false
                showCamera = false
            }
        }
        .fullScreenCover(isPresented: Binding(
            get: { showCamera && !showGalleryPicker },
            set: { newValue in
                if !newValue {
                    showCamera = false
                }
            }
        )) {
            CameraView { image in
                print("✅ 카메라에서 이미지 촬영됨")
                viewModel.setImage(image)
                showCamera = false
                showGalleryPicker = false
            }
        }
        .onAppear {
            Task {
                await viewModel.fetchCurrentLocation()
            }
        }
        .toast(message: $viewModel.toastMessage)
    }
}

/// 기록 타입 선택 카드
struct RecordTypeCard: View {
    let type: RecordType
    let isSelected: Bool
    let onSelect: () -> Void
    
    var body: some View {
        Button(action: onSelect) {
            VStack(spacing: 8) {
                Image(systemName: type == .photo ? "camera.fill" : "text.alignleft")
                    .font(.system(size: 32))
                    .foregroundColor(isSelected ? (type == .photo ? .blue : .green) : .secondary)
                
                Text(type.displayName)
                    .font(.subheadline)
                    .fontWeight(isSelected ? .bold : .medium)
                    .foregroundColor(isSelected ? .primary : .secondary)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 110)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? (type == .photo ? Color.blue.opacity(0.1) : Color.green.opacity(0.1)) : Color.clear)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? (type == .photo ? Color.blue : Color.green) : Color.gray.opacity(0.3), lineWidth: isSelected ? 2 : 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

/// 카메라 뷰
struct CameraView: UIViewControllerRepresentable {
    let onImageSelected: (UIImage) -> Void
    @Environment(\.dismiss) private var dismiss
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.cameraCaptureMode = .photo
        picker.allowsEditing = false
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(onImageSelected: onImageSelected, dismiss: dismiss)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let onImageSelected: (UIImage) -> Void
        let dismiss: DismissAction
        
        init(onImageSelected: @escaping (UIImage) -> Void, dismiss: DismissAction) {
            self.onImageSelected = onImageSelected
            self.dismiss = dismiss
        }
        
        func imagePickerController(
            _ picker: UIImagePickerController,
            didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]
        ) {
            if let image = info[.originalImage] as? UIImage {
                onImageSelected(image)
            }
            dismiss()
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            dismiss()
        }
    }
}

#Preview {
    NavigationStack {
        CreateRecordView(
            viewModel: CreateRecordViewModel(
                createRecordUseCase: CreateRecordUseCase(
                    recordRepository: RecordRepositoryImpl(
                        coreDataStack: CoreDataStack.shared,
                        recordMapper: RecordMapper()
                    ),
                    fileRepository: FileRepositoryImpl(),
                    validateDailyLimit: ValidateDailyLimitUseCase(
                        recordRepository: RecordRepositoryImpl(
                            coreDataStack: CoreDataStack.shared,
                            recordMapper: RecordMapper()
                        )
                    ),
                    validateDate: ValidateDateUseCase(),
                    validateContent: ValidateRecordContentUseCase()
                ),
                getCurrentLocationUseCase: GetCurrentLocationUseCase(),
                reverseGeocodeUseCase: ReverseGeocodeUseCase(),
                getSettingsUseCase: GetSettingsUseCase(
                    settingsRepository: SettingsRepositoryImpl(
                        coreDataStack: CoreDataStack.shared,
                        settingsMapper: SettingsMapper()
                    )
                )
            )
        )
    }
}

