//
//  MockFileRepository.swift
//  TodayOneCutTests
//
//  Created by 신준우 on 2/13/26.
//

import Foundation
@testable import TodayOneCut

/// Mock FileRepository
class MockFileRepository: FileRepository {
    var compressPhotoResult: Data?
    var savePhotoResult: String?
    var deletePhotoError: Error?
    var photoExistsResult: Bool = false
    var totalPhotoSizeResult: Int64 = 0
    
    func compressPhoto(_ imageData: Data, maxSize: Int, quality: CGFloat) async throws -> Data {
        if let result = compressPhotoResult {
            return result
        }
        return imageData
    }
    
    func savePhoto(_ imageData: Data, date: Date) async throws -> String {
        if let result = savePhotoResult {
            return result
        }
        return "/path/to/photo.webp"
    }
    
    func deletePhoto(path: String) async throws {
        if let error = deletePhotoError {
            throw error
        }
    }
    
    func photoExists(path: String) async throws -> Bool {
        return photoExistsResult
    }
    
    func exportData(to destinationURL: URL) async throws {
        throw TodayOneCutError.fileSaveError(message: "백업 기능은 아직 구현되지 않았습니다")
    }
    
    func importData(from sourceURL: URL) async throws -> Int {
        throw TodayOneCutError.fileSaveError(message: "복원 기능은 아직 구현되지 않았습니다")
    }
    
    func getTotalPhotoSize() async throws -> Int64 {
        return totalPhotoSizeResult
    }
    
    func deleteAllPhotos() async throws {}
}

