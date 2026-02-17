//
//  FileRepositoryImpl.swift
//  TodayOneCut
//
//  Created by 신준우 on 2/13/26.
//

import Foundation
import UIKit
import ImageIO
import UniformTypeIdentifiers

/// FileRepository 구현체
class FileRepositoryImpl: FileRepository {
    private let fileManager = FileManager.default
    
    // MARK: - Photo Management
    
    func savePhoto(_ imageData: Data, date: Date) async throws -> String {
        let documentsURL = fileManager.urls(
            for: .documentDirectory,
            in: .userDomainMask
        )[0]
        
        let photosURL = documentsURL.appendingPathComponent(Constants.Photo.photosDirectory)
        
        // 디렉토리 생성
        if !fileManager.fileExists(atPath: photosURL.path) {
            try fileManager.createDirectory(
                at: photosURL,
                withIntermediateDirectories: true
            )
        }
        
        // 기존 파일 삭제 (같은 날짜)
        let fileName = date.toLocalDateString() + ".webp"
        let fileURL = photosURL.appendingPathComponent(fileName)
        
        if fileManager.fileExists(atPath: fileURL.path) {
            try fileManager.removeItem(at: fileURL)
        }
        
        // 파일 저장
        try imageData.write(to: fileURL)
        
        return fileURL.path
    }
    
    func deletePhoto(path: String) async throws {
        guard fileManager.fileExists(atPath: path) else {
            throw TodayOneCutError.fileNotFound()
        }
        
        try fileManager.removeItem(atPath: path)
    }
    
    func deleteAllPhotos() async throws {
        let documentsURL = fileManager.urls(
            for: .documentDirectory,
            in: .userDomainMask
        )[0]
        
        let photosURL = documentsURL.appendingPathComponent(Constants.Photo.photosDirectory)
        
        guard fileManager.fileExists(atPath: photosURL.path) else {
            return // 디렉토리가 없으면 이미 삭제된 것
        }
        
        try fileManager.removeItem(at: photosURL)
        
        // 디렉토리 다시 생성 (나중에 사용할 수 있도록)
        try fileManager.createDirectory(
            at: photosURL,
            withIntermediateDirectories: true
        )
    }
    
    func photoExists(path: String) async throws -> Bool {
        return fileManager.fileExists(atPath: path)
    }
    
    // MARK: - Photo Compression
    
    func compressPhoto(
        _ imageData: Data,
        maxSize: Int = Constants.Photo.maxSize,
        quality: CGFloat = Constants.Photo.compressionQuality
    ) async throws -> Data {
        guard let image = UIImage(data: imageData) else {
            throw TodayOneCutError.fileSaveError(message: "이미지 데이터를 읽을 수 없습니다")
        }
        
        // 리사이징
        let resizedImage = image.resized(to: CGSize(width: maxSize, height: maxSize))
        
        // WebP로 변환
        guard let webpData = resizedImage.webpData(quality: quality) else {
            throw TodayOneCutError.fileSaveError(message: "WebP 변환에 실패했습니다")
        }
        
        return webpData
    }
    
    // MARK: - Data Export/Import
    
    func exportData(to destinationURL: URL) async throws {
        // 백업 기능은 추후 버전에서 구현 예정
        throw TodayOneCutError.fileSaveError(message: "백업 기능은 아직 구현되지 않았습니다")
    }
    
    func importData(from sourceURL: URL) async throws -> Int {
        // 복원 기능은 추후 버전에서 구현 예정
        throw TodayOneCutError.fileSaveError(message: "복원 기능은 아직 구현되지 않았습니다")
    }
    
    // MARK: - Utilities
    
    func getTotalPhotoSize() async throws -> Int64 {
        let documentsURL = fileManager.urls(
            for: .documentDirectory,
            in: .userDomainMask
        )[0]
        
        let photosURL = documentsURL.appendingPathComponent(Constants.Photo.photosDirectory)
        
        guard fileManager.fileExists(atPath: photosURL.path) else {
            return 0
        }
        
        var totalSize: Int64 = 0
        
        if let enumerator = fileManager.enumerator(at: photosURL, includingPropertiesForKeys: [.fileSizeKey]) {
            for case let fileURL as URL in enumerator {
                if let resourceValues = try? fileURL.resourceValues(forKeys: [.fileSizeKey]),
                   let fileSize = resourceValues.fileSize {
                    totalSize += Int64(fileSize)
                }
            }
        }
        
        return totalSize
    }
}

// MARK: - UIImage Extension

extension UIImage {
    /// 이미지 리사이징
    func resized(to size: CGSize) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { _ in
            self.draw(in: CGRect(origin: .zero, size: size))
        }
    }
    
    /// WebP 형식으로 변환
    func webpData(quality: CGFloat) -> Data? {
        guard let cgImage = self.cgImage else { return nil }
        
        let mutableData = NSMutableData()
        
        // iOS 14+에서 WebP 지원
        let webpType = UTType.webP.identifier
        
        guard let destination = CGImageDestinationCreateWithData(
            mutableData,
            webpType as CFString,
            1,
            nil
        ) else {
            // WebP 변환 실패 시 JPEG로 fallback
            return self.jpegData(compressionQuality: quality)
        }
        
        // WebP 옵션 설정
        let options: [CFString: Any] = [
            kCGImageDestinationLossyCompressionQuality: quality
        ]
        
        CGImageDestinationAddImage(destination, cgImage, options as CFDictionary)
        
        guard CGImageDestinationFinalize(destination) else {
            // WebP 변환 실패 시 JPEG로 fallback
            return self.jpegData(compressionQuality: quality)
        }
        
        return mutableData as Data
    }
}

