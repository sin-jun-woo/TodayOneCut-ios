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
        var configuration = PHPickerConfiguration()
        configuration.filter = .images
        configuration.selectionLimit = 1
        configuration.preferredAssetRepresentationMode = .current
        // 갤러리만 표시 (카메라 옵션 제거)
        configuration.preselectedAssetIdentifiers = []
        
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = context.coordinator
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
            // SwiftUI sheet는 바인딩으로 자동 dismiss됨
            DispatchQueue.main.async {
                self.isPresented = false
            }
            
            guard let result = results.first else { return }
            
            result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] (object: NSItemProviderReading?, error: Error?) in
                DispatchQueue.main.async {
                    if let image = object as? UIImage {
                        self?.onImageSelected(image)
                    }
                }
            }
        }
    }
}

