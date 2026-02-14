//
//  FileRepository.swift
//  TodayOneCut
//
//  Created by 신준우 on 2/13/26.
//

import Foundation

/// 파일 시스템 관리를 위한 저장소 프로토콜
protocol FileRepository {
    
    /// 사진 저장
    /// - Parameters:
    ///   - imageData: 이미지 데이터
    ///   - date: 기록 날짜 (파일명으로 사용)
    /// - Returns: 저장된 파일 경로
    /// - Throws: FileSaveError 저장 실패
    func savePhoto(_ imageData: Data, date: Date) async throws -> String
    
    /// 사진 삭제
    /// - Parameter path: 파일 경로
    /// - Throws: FileNotFoundError 파일이 존재하지 않는 경우
    func deletePhoto(path: String) async throws
    
    /// 사진 파일 존재 확인
    /// - Parameter path: 파일 경로
    /// - Returns: 파일 존재 여부
    func photoExists(path: String) async throws -> Bool
    
    /// 사진 압축 및 리사이징
    /// - Parameters:
    ///   - imageData: 원본 이미지 데이터
    ///   - maxSize: 최대 크기 (px)
    ///   - quality: 압축 품질 (0.0-1.0)
    /// - Returns: 압축된 이미지 데이터
    func compressPhoto(
        _ imageData: Data,
        maxSize: Int,
        quality: CGFloat
    ) async throws -> Data
    
    /// 전체 데이터 백업 (JSON)
    /// - Parameter destinationURL: 백업 파일 저장 위치
    /// - Throws: FileSaveError 저장 실패
    func exportData(to destinationURL: URL) async throws
    
    /// 데이터 복원
    /// - Parameter sourceURL: 백업 파일 위치
    /// - Returns: 복원된 기록 개수
    /// - Throws: FileNotFoundError, InvalidDataError
    func importData(from sourceURL: URL) async throws -> Int
    
    /// 사진 저장소 전체 용량 계산
    /// - Returns: 총 용량 (bytes)
    func getTotalPhotoSize() async throws -> Int64
}

