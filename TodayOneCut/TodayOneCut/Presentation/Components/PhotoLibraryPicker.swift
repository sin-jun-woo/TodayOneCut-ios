//
//  PhotoLibraryPicker.swift
//  TodayOneCut
//
//  Created by 신준우 on 2/13/26.
//

import SwiftUI
import PhotosUI
import Photos

/// 갤러리 전용 사진 선택기 (카메라 옵션 없음)
struct PhotoLibraryPicker: UIViewControllerRepresentable {
    @Binding var isPresented: Bool
    let onImageSelected: (UIImage) -> Void
    
    func makeUIViewController(context: Context) -> PHPickerViewController {
        #if DEBUG
        print("DEBUG: PhotoLibraryPicker 생성 중 - 갤러리 전용")
        #endif
        var configuration = PHPickerConfiguration()
        configuration.filter = .images
        configuration.selectionLimit = 1
        configuration.preferredAssetRepresentationMode = .current
        // 갤러리만 표시 (카메라 옵션 제거)
        configuration.preselectedAssetIdentifiers = []
        
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = context.coordinator
        #if DEBUG
        print("DEBUG: PHPickerViewController 생성 완료")
        #endif
        return picker
    }
    
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(isPresented: $isPresented, onImageSelected: onImageSelected)
    }
    
    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        @Binding var isPresented: Bool
        let onImageSelected: (UIImage) -> Void
        
        init(isPresented: Binding<Bool>, onImageSelected: @escaping (UIImage) -> Void) {
            _isPresented = isPresented
            self.onImageSelected = onImageSelected
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            guard let result = results.first else {
                // 선택 취소 시 sheet 닫기
                DispatchQueue.main.async {
                    self.isPresented = false
                }
                return
            }
            
            result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] (object: NSItemProviderReading?, error: Error?) in
                DispatchQueue.main.async {
                    if let image = object as? UIImage {
                        self?.onImageSelected(image)
                        // 이미지 선택 후 sheet 닫기 (onImageSelected에서도 닫지만 확실히)
                        self?.isPresented = false
                    } else if error != nil {
                        // 에러 발생 시 sheet 닫기
                        self?.isPresented = false
                    }
                }
            }
        }
    }
}

