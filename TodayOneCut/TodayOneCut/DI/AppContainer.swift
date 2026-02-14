//
//  AppContainer.swift
//  TodayOneCut
//
//  Created by 신준우 on 2/13/26.
//

import Foundation

// TODO: Swinject 추가 후 구현
// Swift Package Manager로 Swinject 추가 필요:
// 1. Xcode에서 File > Add Package Dependencies...
// 2. https://github.com/Swinject/Swinject.git 추가
// 3. import Swinject 추가

/// 의존성 주입 컨테이너
/// 
/// Swinject를 사용하여 의존성을 관리합니다.
class AppContainer {
    static let shared = AppContainer()
    
    // TODO: Swinject Container 추가
    // private let container = Container()
    
    private init() {
        setupDependencies()
    }
    
    private func setupDependencies() {
        // TODO: Swinject 추가 후 구현
        // 
        // // Core Data Stack
        // container.register(CoreDataStack.self) { _ in
        //     CoreDataStack.shared
        // }.inObjectScope(.container)
        // 
        // // Repositories
        // container.register(RecordRepository.self) { r in
        //     RecordRepositoryImpl(
        //         coreDataStack: r.resolve(CoreDataStack.self)!,
        //         recordMapper: r.resolve(RecordMapper.self)!
        //     )
        // }.inObjectScope(.container)
        // 
        // // Use Cases
        // container.register(CreateRecordUseCase.self) { r in
        //     CreateRecordUseCase(
        //         recordRepository: r.resolve(RecordRepository.self)!,
        //         fileRepository: r.resolve(FileRepository.self)!,
        //         validateDailyLimit: r.resolve(ValidateDailyLimitUseCase.self)!,
        //         validateDate: r.resolve(ValidateDateUseCase.self)!
        //     )
        // }
        // 
        // // ViewModels
        // container.register(HomeViewModel.self) { r in
        //     HomeViewModel(
        //         getTodayRecordUseCase: r.resolve(GetTodayRecordUseCase.self)!,
        //         checkTodayRecordExistsUseCase: r.resolve(CheckTodayRecordExistsUseCase.self)!
        //     )
        // }
    }
    
    // TODO: Swinject 추가 후 구현
    // func resolve<T>(_ type: T.Type) -> T? {
    //     return container.resolve(type)
    // }
}

