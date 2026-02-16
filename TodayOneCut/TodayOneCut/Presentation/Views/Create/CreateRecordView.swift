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
    @State private var imagePickerType: ImagePickerType? = nil
    
    enum ImagePickerType: Identifiable {
        case gallery
        case camera
        
        var id: Int {
            switch self {
            case .gallery: return 0
            case .camera: return 1
            }
        }
    }
    
    init(viewModel: CreateRecordViewModel) {
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
                        
                        Button("사진 제거") {
                            viewModel.removeImage()
                        }
                        .foregroundColor(.red)
                    }
                } else {
                    HStack {
                        Button {
                            imagePickerType = .gallery
                        } label: {
                            Label("갤러리에서 선택", systemImage: "photo.on.rectangle")
                        }
                        
                        Spacer()
                        
                        Button {
                            imagePickerType = .camera
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
                .disabled(viewModel.isLoading || (viewModel.contentText.isEmpty && viewModel.imageData == nil))
            }
        }
        .sheet(item: $imagePickerType) { type in
            switch type {
            case .gallery:
                PhotoLibraryPicker(isPresented: Binding(
                    get: { imagePickerType == .gallery },
                    set: { if !$0 { imagePickerType = nil } }
                )) { image in
                    viewModel.setImage(image)
                    imagePickerType = nil
                }
            case .camera:
                CameraView { image in
                    viewModel.setImage(image)
                    imagePickerType = nil
                }
            }
        }
        .onAppear {
            Task {
                await viewModel.fetchCurrentLocation()
            }
        }
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

