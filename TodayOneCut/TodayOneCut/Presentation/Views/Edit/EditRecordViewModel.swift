//
//  EditRecordViewModel.swift
//  TodayOneCut
//
//  Created by 신준우 on 2/13/26.
//

import Foundation
import Combine
import UIKit

/// 기록 수정 화면 ViewModel
@MainActor
class EditRecordViewModel: ObservableObject {
    @Published var record: Record?
    @Published var contentText: String = ""
    @Published var selectedImage: UIImage?
    @Published var imageData: Data?
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var toastMessage: String?
    @Published var isLocationEnabled: Bool = false
    
    private let getRecordByIdUseCase: GetRecordByIdUseCase
    private let updateRecordUseCase: UpdateRecordUseCase
    private let getSettingsUseCase: GetSettingsUseCase
    private let recordId: Int64
    private var loadTask: Task<Void, Never>?
    
    init(
        recordId: Int64,
        getRecordByIdUseCase: GetRecordByIdUseCase,
        updateRecordUseCase: UpdateRecordUseCase,
        getSettingsUseCase: GetSettingsUseCase
    ) {
        self.recordId = recordId
        self.getRecordByIdUseCase = getRecordByIdUseCase
        self.updateRecordUseCase = updateRecordUseCase
        self.getSettingsUseCase = getSettingsUseCase
    }
    
    /// 기록 로드
    func loadRecord() {
        loadTask?.cancel()
        
        loadTask = Task {
            isLoading = true
            errorMessage = nil
            
            do {
                record = try await getRecordByIdUseCase.execute(id: recordId)
                try Task.checkCancellation()
                
                if let record = record {
                    contentText = record.contentText ?? ""
                    
                    // 기존 사진 로드
                    if let photoPath = record.photoPath {
                        if let data = try? Data(contentsOf: URL(fileURLWithPath: photoPath)),
                           let image = UIImage(data: data) {
                            try Task.checkCancellation()
                            selectedImage = image
                        }
                    }
                    
                    // 설정 로드
                    let settings = try await getSettingsUseCase.executeOnce()
                    try Task.checkCancellation()
                    isLocationEnabled = settings.enableLocation
                }
            } catch {
                if !Task.isCancelled {
                    errorMessage = (error as? TodayOneCutError)?.userMessage ?? "기록을 불러올 수 없습니다"
                }
            }
            
            if !Task.isCancelled {
                isLoading = false
            }
        }
    }
    
    deinit {
        loadTask?.cancel()
    }
    
    /// 이미지 선택
    func setImage(_ image: UIImage) {
        selectedImage = image
        imageData = image.jpegData(compressionQuality: 1.0)
    }
    
    /// 이미지 제거
    func removeImage() {
        selectedImage = nil
        imageData = nil
    }
    
    /// 기록 저장
    func saveRecord() async -> Bool {
        guard let record = record else {
            errorMessage = "기록을 불러올 수 없습니다"
            return false
        }
        
        guard !contentText.isEmpty || imageData != nil else {
            errorMessage = "사진 또는 텍스트가 필요합니다"
            return false
        }
        
        isLoading = true
        errorMessage = nil
        
        do {
            // 기존/새 사진 상태 계산
            let hasExistingPhoto = record.photoPath != nil
            let hasNewPhoto = imageData != nil
            let isPhotoRemoved = hasExistingPhoto && !hasNewPhoto && selectedImage == nil
            
            // 최종 타입 결정:
            // - 새 사진 선택 또는 기존 사진 유지: .photo
            // - 사진 제거 또는 원래부터 사진 없음: .text
            let finalType: RecordType = {
                if isPhotoRemoved {
                    return .text
                } else if hasExistingPhoto || hasNewPhoto {
                    return .photo
                } else {
                    return .text
                }
            }()
            
            // 최종 사진 경로:
            // - 사진 제거 시에는 nil
            // - 기존/새 사진 유지 시에는 기존 경로 (새 사진은 UseCase에서 경로 갱신)
            let finalPhotoPath: String? = isPhotoRemoved ? nil : record.photoPath
            
            let updatedRecord = Record(
                id: record.id,
                date: record.date,
                type: finalType,
                contentText: contentText.isEmpty ? nil : contentText,
                photoPath: finalPhotoPath, // 기존 경로 유지 또는 제거 여부 반영
                location: record.location,
                createdAt: record.createdAt,
                updatedAt: Date(),
                updateCount: record.updateCount
            )
            
            _ = try await updateRecordUseCase.execute(
                record: updatedRecord,
                newPhotoData: imageData
            )
            
            isLoading = false
            return true
        } catch {
            isLoading = false
            let message = (error as? TodayOneCutError)?.userMessage ?? "기록 수정에 실패했습니다"
            errorMessage = message
            toastMessage = message
            return false
        }
    }
}

