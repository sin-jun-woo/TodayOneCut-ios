//
//  Result.swift
//  TodayOneCut
//
//  Created by 신준우 on 2/13/26.
//

import Foundation

/// Result 타입 (선택사항 - Swift 표준 Result 사용 가능)
/// 
/// Swift 5.0+ 에서는 표준 Result<Success, Failure> 타입을 사용할 수 있지만,
/// 편의 메서드를 추가하기 위해 extension으로 확장 가능
extension Result {
    /// 성공 여부
    var isSuccess: Bool {
        if case .success = self { return true }
        return false
    }
    
    /// 실패 여부
    var isFailure: Bool {
        if case .failure = self { return true }
        return false
    }
    
    /// 성공 값 또는 nil
    func getOrNil() -> Success? {
        if case .success(let value) = self {
            return value
        }
        return nil
    }
    
    /// 성공 값 또는 예외 발생
    func getOrThrow() throws -> Success {
        switch self {
        case .success(let value):
            return value
        case .failure(let error):
            throw error
        }
    }
    
    /// 성공 시 액션 실행
    func onSuccess(_ action: (Success) -> Void) -> Result<Success, Failure> {
        if case .success(let value) = self {
            action(value)
        }
        return self
    }
    
    /// 실패 시 액션 실행
    func onFailure(_ action: (Failure) -> Void) -> Result<Success, Failure> {
        if case .failure(let error) = self {
            action(error)
        }
        return self
    }
    
    /// 값 변환
    func map<NewSuccess>(_ transform: (Success) -> NewSuccess) -> Result<NewSuccess, Failure> {
        switch self {
        case .success(let value):
            return .success(transform(value))
        case .failure(let error):
            return .failure(error)
        }
    }
}

