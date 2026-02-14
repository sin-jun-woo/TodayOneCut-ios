//
//  AppContainer.swift
//  TodayOneCut
//
//  Created by 신준우 on 2/13/26.
//

import Foundation
// TODO: Xcode에서 Swinject 추가 후 주석 해제
// import Swinject

/// 의존성 주입 컨테이너
/// 
/// Swinject를 사용하여 의존성을 관리합니다.
/// 
/// Swinject 추가 방법:
/// 1. Xcode에서 File > Add Package Dependencies...
/// 2. https://github.com/Swinject/Swinject.git 입력
/// 3. Add Package 클릭
/// 4. 위의 import Swinject 주석 해제
class AppContainer {
    static let shared = AppContainer()
    
    // TODO: Swinject 추가 후 주석 해제
    // private let container = Container()
    
    private init() {
        setupDependencies()
    }
    
    private func setupDependencies() {
        // TODO: Swinject 추가 후 구현
        // Phase 1, 2에서 실제 구현할 때 아래 주석 해제
        //
        // // Core Data Stack
        // container.register(CoreDataStack.self) { _ in
        //     CoreDataStack.shared
        // }.inObjectScope(.container)
        //
        // // Mappers
        // container.register(RecordMapper.self) { _ in
        //     RecordMapper()
        // }
        //
        // container.register(SettingsMapper.self) { _ in
        //     SettingsMapper()
        // }
        //
        // // Repositories
        // container.register(RecordRepository.self) { r in
        //     RecordRepositoryImpl(
        //         coreDataStack: r.resolve(CoreDataStack.self)!,
        //         recordMapper: r.resolve(RecordMapper.self)!
        //     )
        // }.inObjectScope(.container)
        //
        // container.register(SettingsRepository.self) { r in
        //     SettingsRepositoryImpl(
        //         coreDataStack: r.resolve(CoreDataStack.self)!,
        //         settingsMapper: r.resolve(SettingsMapper.self)!
        //     )
        // }.inObjectScope(.container)
        //
        // container.register(FileRepository.self) { _ in
        //     FileRepositoryImpl()
        // }.inObjectScope(.container)
        //
        // // Validation Use Cases
        // container.register(ValidateDailyLimitUseCase.self) { r in
        //     ValidateDailyLimitUseCase(
        //         recordRepository: r.resolve(RecordRepository.self)!
        //     )
        // }
        //
        // container.register(ValidateUpdateLimitUseCase.self) { _ in
        //     ValidateUpdateLimitUseCase()
        // }
        //
        // container.register(ValidateDateUseCase.self) { _ in
        //     ValidateDateUseCase()
        // }
        //
        // container.register(ValidateRecordContentUseCase.self) { _ in
        //     ValidateRecordContentUseCase()
        // }
        //
        // // Record Use Cases
        // container.register(CreateRecordUseCase.self) { r in
        //     CreateRecordUseCase(
        //         recordRepository: r.resolve(RecordRepository.self)!,
        //         fileRepository: r.resolve(FileRepository.self)!,
        //         validateDailyLimit: r.resolve(ValidateDailyLimitUseCase.self)!,
        //         validateDate: r.resolve(ValidateDateUseCase.self)!
        //     )
        // }
        //
        // container.register(GetTodayRecordUseCase.self) { r in
        //     GetTodayRecordUseCase(
        //         recordRepository: r.resolve(RecordRepository.self)!
        //     )
        // }
        //
        // container.register(GetAllRecordsUseCase.self) { r in
        //     GetAllRecordsUseCase(
        //         recordRepository: r.resolve(RecordRepository.self)!
        //     )
        // }
        //
        // container.register(GetRecordByIdUseCase.self) { r in
        //     GetRecordByIdUseCase(
        //         recordRepository: r.resolve(RecordRepository.self)!
        //     )
        // }
        //
        // container.register(UpdateRecordUseCase.self) { r in
        //     UpdateRecordUseCase(
        //         recordRepository: r.resolve(RecordRepository.self)!,
        //         fileRepository: r.resolve(FileRepository.self)!,
        //         validateUpdateLimit: r.resolve(ValidateUpdateLimitUseCase.self)!
        //     )
        // }
        //
        // container.register(DeleteRecordUseCase.self) { r in
        //     DeleteRecordUseCase(
        //         recordRepository: r.resolve(RecordRepository.self)!,
        //         fileRepository: r.resolve(FileRepository.self)!
        //     )
        // }
        //
        // container.register(SearchRecordsUseCase.self) { r in
        //     SearchRecordsUseCase(
        //         recordRepository: r.resolve(RecordRepository.self)!
        //     )
        // }
        //
        // container.register(CheckTodayRecordExistsUseCase.self) { r in
        //     CheckTodayRecordExistsUseCase(
        //         recordRepository: r.resolve(RecordRepository.self)!
        //     )
        // }
        //
        // // Calendar Use Cases
        // container.register(GetMonthRecordsUseCase.self) { r in
        //     GetMonthRecordsUseCase(
        //         recordRepository: r.resolve(RecordRepository.self)!
        //     )
        // }
        //
        // container.register(GetRecordDatesUseCase.self) { r in
        //     GetRecordDatesUseCase(
        //         recordRepository: r.resolve(RecordRepository.self)!
        //     )
        // }
        //
        // // Settings Use Cases
        // container.register(GetSettingsUseCase.self) { r in
        //     GetSettingsUseCase(
        //         settingsRepository: r.resolve(SettingsRepository.self)!
        //     )
        // }
        //
        // container.register(UpdateLocationSettingUseCase.self) { r in
        //     UpdateLocationSettingUseCase(
        //         settingsRepository: r.resolve(SettingsRepository.self)!
        //     )
        // }
        //
        // container.register(UpdateThemeUseCase.self) { r in
        //     UpdateThemeUseCase(
        //         settingsRepository: r.resolve(SettingsRepository.self)!
        //     )
        // }
        //
        // // Location Use Cases
        // container.register(GetCurrentLocationUseCase.self) { _ in
        //     GetCurrentLocationUseCase()
        // }
        //
        // container.register(ReverseGeocodeUseCase.self) { _ in
        //     ReverseGeocodeUseCase()
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
    
    // TODO: Swinject 추가 후 주석 해제
    // func resolve<T>(_ type: T.Type) -> T? {
    //     return container.resolve(type)
    // }
}

