//
//  CreateRecordViewModel.swift
//  TodayOneCut
//
//  Created by 신준우 on 2/13/26.
//

import Foundation
import Combine
import UIKit

/// 기록 작성 화면 ViewModel
@MainActor
class CreateRecordViewModel: ObservableObject {
    @Published var contentText: String = ""
    @Published var selectedImage: UIImage?
    @Published var imageData: Data?
    @Published var recordType: RecordType? = nil
    @Published var location: Location?
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var toastMessage: String?
    @Published var isLocationEnabled: Bool = false
    
    private let createRecordUseCase: CreateRecordUseCase
    private let getCurrentLocationUseCase: GetCurrentLocationUseCase
    private let reverseGeocodeUseCase: ReverseGeocodeUseCase
    private let getSettingsUseCase: GetSettingsUseCase
    private var loadTask: Task<Void, Never>?
    private var locationTask: Task<Void, Never>?
    
    init(
        createRecordUseCase: CreateRecordUseCase,
        getCurrentLocationUseCase: GetCurrentLocationUseCase,
        reverseGeocodeUseCase: ReverseGeocodeUseCase,
        getSettingsUseCase: GetSettingsUseCase
    ) {
        self.createRecordUseCase = createRecordUseCase
        self.getCurrentLocationUseCase = getCurrentLocationUseCase
        self.reverseGeocodeUseCase = reverseGeocodeUseCase
        self.getSettingsUseCase = getSettingsUseCase
        
        loadSettings()
    }
    
    /// 설정 로드
    private func loadSettings() {
        loadTask?.cancel()
        
        loadTask = Task {
            do {
                let settings = try await getSettingsUseCase.executeOnce()
                try Task.checkCancellation()
                isLocationEnabled = settings.enableLocation
                
                if isLocationEnabled {
                    await fetchCurrentLocation()
                }
            } catch {
                if !Task.isCancelled {
                    // 설정 로드 실패는 무시
                }
            }
        }
    }
    
    /// 현재 위치 가져오기
    func fetchCurrentLocation() async {
        guard isLocationEnabled else { return }
        
        locationTask?.cancel()
        
        locationTask = Task {
            do {
                let currentLocation = try await getCurrentLocationUseCase.execute()
                try Task.checkCancellation()
                let locationWithName = try await reverseGeocodeUseCase.execute(location: currentLocation)
                try Task.checkCancellation()
                location = locationWithName
            } catch {
                if !Task.isCancelled {
                    // 위치 가져오기 실패는 무시 (선택적 기능)
                    // Toast 메시지만 표시 (에러 메시지는 표시 안 함)
                    toastMessage = "위치 정보를 가져올 수 없습니다"
                }
            }
        }
    }
    
    /// 기록 타입 선택
    func selectRecordType(_ type: RecordType) {
        recordType = type
        if type == .text {
            // 텍스트 타입 선택 시 이미지 제거
            selectedImage = nil
            imageData = nil
        }
    }
    
    /// 이미지 선택
    func setImage(_ image: UIImage) {
        selectedImage = image
        // WebP로 변환 (나중에 compressPhoto에서 처리되므로 여기서는 원본 데이터 저장)
        imageData = image.jpegData(compressionQuality: 1.0) // 임시로 JPEG, compressPhoto에서 WebP로 변환
        if imageData != nil {
            recordType = .photo
        }
    }
    
    /// 이미지 제거
    func removeImage() {
        selectedImage = nil
        imageData = nil
        if contentText.isEmpty {
            recordType = nil
        }
    }
    
    /// 기록 저장
    func saveRecord() async -> Bool {
        guard let type = recordType else {
            errorMessage = "기록 타입을 선택해주세요"
            return false
        }
        
        guard !contentText.isEmpty || imageData != nil else {
            errorMessage = "사진 또는 텍스트가 필요합니다"
            return false
        }
        
        isLoading = true
        errorMessage = nil
        
        do {
            _ = try await createRecordUseCase.execute(
                type: type,
                contentText: contentText.isEmpty ? nil : contentText,
                photoData: imageData,
                location: isLocationEnabled ? location : nil
            )
            
            isLoading = false
            return true
        } catch {
            isLoading = false
            let message = (error as? TodayOneCutError)?.userMessage ?? "기록 저장에 실패했습니다"
            errorMessage = message
            toastMessage = message
            return false
        }
    }
    
    deinit {
        loadTask?.cancel()
        locationTask?.cancel()
        // 이미지 메모리 해제 (Main actor에서 실행)
        Task { @MainActor in
            selectedImage = nil
            imageData = nil
        }
    }
}

