//
//  TestCoreDataStack.swift
//  TodayOneCutTests
//
//  Created by 신준우 on 2/13/26.
//

import CoreData
import Foundation
@testable import TodayOneCut

/// 테스트용 Core Data Stack (in-memory)
class TestCoreDataStack {
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: Constants.Database.modelName)
        
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        description.shouldAddStoreAsynchronously = false
        
        container.persistentStoreDescriptions = [description]
        
        container.loadPersistentStores { description, error in
            if let error = error as NSError? {
                fatalError("테스트용 Core Data 저장소 로드 실패: \(error), \(error.userInfo)")
            }
        }
        
        container.viewContext.automaticallyMergesChangesFromParent = true
        
        return container
    }()
    
    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    func newBackgroundContext() -> NSManagedObjectContext {
        return persistentContainer.newBackgroundContext()
    }
    
    func saveContext() throws {
        let context = viewContext
        
        guard context.hasChanges else { return }
        
        do {
            try context.save()
        } catch {
            let nsError = error as NSError
            throw nsError
        }
    }
    
    /// 테스트 데이터 초기화
    func reset() {
        let context = viewContext
        
        // 모든 RecordEntity 삭제
        let recordFetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "RecordEntity")
        let recordDeleteRequest = NSBatchDeleteRequest(fetchRequest: recordFetchRequest)
        try? context.execute(recordDeleteRequest)
        
        // AppSettingsEntity 초기화
        let settingsFetchRequest: NSFetchRequest<AppSettingsEntity> = AppSettingsEntity.fetchRequest()
        if let settings = try? context.fetch(settingsFetchRequest).first {
            settings.enableLocation = false
            settings.enableNotification = false
            settings.themeMode = ThemeMode.system.rawValue
            settings.appTheme = AppTheme.warmCozy.rawValue
            settings.fontFamily = AppFont.systemSerif.rawValue
            settings.firstLaunch = true
            settings.totalRecords = 0
        } else {
            let defaultSettings = AppSettingsEntity(context: context)
            defaultSettings.id = 1
            defaultSettings.enableLocation = false
            defaultSettings.enableNotification = false
            defaultSettings.themeMode = ThemeMode.system.rawValue
            defaultSettings.appTheme = AppTheme.warmCozy.rawValue
            defaultSettings.fontFamily = AppFont.systemSerif.rawValue
            defaultSettings.firstLaunch = true
            defaultSettings.totalRecords = 0
            defaultSettings.createdAt = Date()
        }
        
        try? context.save()
    }
}

