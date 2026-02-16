//
//  SettingsRepositoryImpl.swift
//  TodayOneCut
//
//  Created by 신준우 on 2/13/26.
//

import Foundation
import CoreData
import Combine

/// SettingsRepository 구현체
class SettingsRepositoryImpl: SettingsRepository {
    private let coreDataStack: CoreDataStack
    private let settingsMapper: SettingsMapper
    
    init(coreDataStack: CoreDataStack, settingsMapper: SettingsMapper) {
        self.coreDataStack = coreDataStack
        self.settingsMapper = settingsMapper
    }
    
    func getSettings() -> AnyPublisher<AppSettings, Never> {
        let context = coreDataStack.viewContext
        
        return NotificationCenter.default.publisher(
            for: .NSManagedObjectContextDidSave,
            object: context
        )
        .map { _ in
            self.fetchSettings(context: context) ?? AppSettings()
        }
        .prepend(fetchSettings(context: context) ?? AppSettings())
        .eraseToAnyPublisher()
    }
    
    func getSettingsOnce() async throws -> AppSettings {
        let context = coreDataStack.viewContext
        
        guard let entity = fetchSettingsEntity(context: context) else {
            // 없으면 기본 설정 생성
            let defaultSettings = AppSettings()
            try await updateSettings(defaultSettings)
            return defaultSettings
        }
        
        return settingsMapper.toDomain(entity)
    }
    
    func updateLocationEnabled(_ enabled: Bool) async throws {
        let context = coreDataStack.viewContext
        
        guard let entity = fetchSettingsEntity(context: context) else {
            throw TodayOneCutError.databaseError(message: "설정을 찾을 수 없습니다")
        }
        
        entity.enableLocation = enabled
        entity.updatedAt = Date()
        
        try coreDataStack.saveContext()
    }
    
    func updateThemeMode(_ mode: ThemeMode) async throws {
        let context = coreDataStack.viewContext
        
        guard let entity = fetchSettingsEntity(context: context) else {
            throw TodayOneCutError.databaseError(message: "설정을 찾을 수 없습니다")
        }
        
        entity.themeMode = mode.rawValue
        entity.updatedAt = Date()
        
        try coreDataStack.saveContext()
    }
    
    func updateNotificationEnabled(_ enabled: Bool) async throws {
        let context = coreDataStack.viewContext
        
        guard let entity = fetchSettingsEntity(context: context) else {
            throw TodayOneCutError.databaseError(message: "설정을 찾을 수 없습니다")
        }
        
        entity.enableNotification = enabled
        entity.updatedAt = Date()
        
        try coreDataStack.saveContext()
    }
    
    func updateAppTheme(_ theme: AppTheme) async throws {
        let context = coreDataStack.viewContext
        
        guard let entity = fetchSettingsEntity(context: context) else {
            throw TodayOneCutError.databaseError(message: "설정을 찾을 수 없습니다")
        }
        
        entity.appTheme = theme.rawValue
        entity.updatedAt = Date()
        
        try coreDataStack.saveContext()
    }
    
    func updateFontFamily(_ font: AppFont) async throws {
        let context = coreDataStack.viewContext
        
        guard let entity = fetchSettingsEntity(context: context) else {
            throw TodayOneCutError.databaseError(message: "설정을 찾을 수 없습니다")
        }
        
        entity.fontFamily = font.rawValue
        entity.updatedAt = Date()
        
        try coreDataStack.saveContext()
    }
    
    func markFirstLaunchComplete() async throws {
        let context = coreDataStack.viewContext
        
        guard let entity = fetchSettingsEntity(context: context) else {
            throw TodayOneCutError.databaseError(message: "설정을 찾을 수 없습니다")
        }
        
        entity.firstLaunch = false
        entity.updatedAt = Date()
        
        try coreDataStack.saveContext()
    }
    
    func updateSettings(_ settings: AppSettings) async throws {
        let context = coreDataStack.viewContext
        
        let entity = fetchSettingsEntity(context: context) ?? AppSettingsEntity(context: context)
        
        let updatedEntity = settingsMapper.toEntity(settings, context: context)
        entity.id = updatedEntity.id
        entity.enableLocation = updatedEntity.enableLocation
        entity.enableNotification = updatedEntity.enableNotification
        entity.themeMode = updatedEntity.themeMode
        entity.appTheme = updatedEntity.appTheme
        entity.fontFamily = updatedEntity.fontFamily
        entity.firstLaunch = updatedEntity.firstLaunch
        entity.totalRecords = updatedEntity.totalRecords
        entity.createdAt = updatedEntity.createdAt
        entity.updatedAt = Date()
        
        try coreDataStack.saveContext()
    }
    
    func updateTotalRecords(_ count: Int) async throws {
        let context = coreDataStack.viewContext
        
        guard let entity = fetchSettingsEntity(context: context) else {
            throw TodayOneCutError.databaseError(message: "설정을 찾을 수 없습니다")
        }
        
        entity.totalRecords = Int32(count)
        entity.updatedAt = Date()
        
        try coreDataStack.saveContext()
    }
    
    func resetSettings() async throws {
        let context = coreDataStack.viewContext
        
        guard let entity = fetchSettingsEntity(context: context) else {
            // 없으면 기본 설정 생성
            let defaultSettings = AppSettings()
            try await updateSettings(defaultSettings)
            return
        }
        
        // 기본값으로 리셋
        entity.enableLocation = false
        entity.enableNotification = false
        entity.themeMode = ThemeMode.system.rawValue
        entity.appTheme = AppTheme.warmCozy.rawValue
        entity.fontFamily = AppFont.systemSerif.rawValue
        entity.firstLaunch = false // 이미 실행한 적이 있으므로 false
        entity.totalRecords = 0
        entity.updatedAt = Date()
        
        try coreDataStack.saveContext()
    }
    
    // MARK: - Helper Methods
    
    private func fetchSettings(context: NSManagedObjectContext) -> AppSettings? {
        guard let entity = fetchSettingsEntity(context: context) else {
            return nil
        }
        return settingsMapper.toDomain(entity)
    }
    
    private func fetchSettingsEntity(context: NSManagedObjectContext) -> AppSettingsEntity? {
        let fetchRequest: NSFetchRequest<AppSettingsEntity> = AppSettingsEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == 1")
        fetchRequest.fetchLimit = 1
        
        return try? context.fetch(fetchRequest).first
    }
}

