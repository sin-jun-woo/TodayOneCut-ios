//
//  SettingsMapper.swift
//  TodayOneCut
//
//  Created by 신준우 on 2/13/26.
//

import Foundation
import CoreData

/// AppSettings Entity ↔ Domain Model 변환
class SettingsMapper {
    
    /// Entity를 Domain Model로 변환
    func toDomain(_ entity: AppSettingsEntity) -> AppSettings {
        return AppSettings(
            id: entity.id,
            enableLocation: entity.enableLocation,
            themeMode: ThemeMode(rawValue: entity.themeMode ?? ThemeMode.system.rawValue) ?? .system,
            firstLaunch: entity.firstLaunch,
            totalRecords: Int(entity.totalRecords),
            createdAt: entity.createdAt ?? Date(),
            updatedAt: entity.updatedAt
        )
    }
    
    /// Domain Model을 Entity로 변환
    func toEntity(_ settings: AppSettings, context: NSManagedObjectContext) -> AppSettingsEntity {
        let entity = AppSettingsEntity(context: context)
        entity.id = settings.id
        entity.enableLocation = settings.enableLocation
        entity.themeMode = settings.themeMode.rawValue
        entity.firstLaunch = settings.firstLaunch
        entity.totalRecords = Int32(settings.totalRecords)
        entity.createdAt = settings.createdAt
        entity.updatedAt = settings.updatedAt
        return entity
    }
}

