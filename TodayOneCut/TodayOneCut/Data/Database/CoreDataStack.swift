//
//  CoreDataStack.swift
//  TodayOneCut
//
//  Created by 신준우 on 2/13/26.
//

import CoreData
import Foundation

/// Core Data 스택 관리 클래스
class CoreDataStack {
    static let shared = CoreDataStack()
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: Constants.Database.modelName)
        
        container.loadPersistentStores { description, error in
            if let error = error as NSError? {
                // 프로덕션에서는 에러 로깅 및 복구 로직 필요
                fatalError("Core Data 저장소 로드 실패: \(error), \(error.userInfo)")
            }
        }
        
        // 자동으로 부모 컨텍스트 변경사항 병합
        container.viewContext.automaticallyMergesChangesFromParent = true
        
        // 변경사항 저장 시 자동 저장 비활성화 (수동 저장)
        container.viewContext.automaticallyMergesChangesFromParent = true
        
        return container
    }()
    
    /// 메인 뷰 컨텍스트
    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    /// 백그라운드 컨텍스트 생성
    func newBackgroundContext() -> NSManagedObjectContext {
        return persistentContainer.newBackgroundContext()
    }
    
    /// 컨텍스트 저장
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
    
    /// 백그라운드 컨텍스트 저장
    func saveBackgroundContext(_ context: NSManagedObjectContext) throws {
        guard context.hasChanges else { return }
        
        do {
            try context.save()
        } catch {
            let nsError = error as NSError
            throw nsError
        }
    }
    
    private init() {
        // 초기화 시 데이터베이스 초기화 (최초 실행 시)
        initializeDatabaseIfNeeded()
    }
    
    /// 최초 실행 시 데이터베이스 초기화
    private func initializeDatabaseIfNeeded() {
        let context = viewContext
        
        // AppSettingsEntity가 없으면 초기 데이터 생성
        let fetchRequest: NSFetchRequest<AppSettingsEntity> = AppSettingsEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == 1")
        
        do {
            let existingSettings = try context.fetch(fetchRequest).first
            
            if existingSettings == nil {
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
                
                try context.save()
            }
        } catch {
            print("데이터베이스 초기화 실패: \(error)")
        }
    }
}

