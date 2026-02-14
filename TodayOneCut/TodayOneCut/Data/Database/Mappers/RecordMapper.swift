//
//  RecordMapper.swift
//  TodayOneCut
//
//  Created by 신준우 on 2/13/26.
//

import Foundation
import CoreData

/// Record Entity ↔ Domain Model 변환
class RecordMapper {
    
    /// Entity를 Domain Model로 변환
    func toDomain(_ entity: RecordEntity) -> Record {
        let location: Location?
        
        if entity.latitude != 0 && entity.longitude != 0 {
            location = Location(
                latitude: entity.latitude,
                longitude: entity.longitude,
                name: entity.locationName
            )
        } else {
            location = nil
        }
        
        return Record(
            id: entity.id,
            date: entity.recordDate?.toDate() ?? Date(),
            type: RecordType(rawValue: entity.recordType ?? RecordType.text.rawValue) ?? .text,
            contentText: entity.contentText,
            photoPath: entity.photoPath,
            location: location,
            createdAt: entity.createdAt ?? Date(),
            updatedAt: entity.updatedAt,
            updateCount: Int(entity.updateCount)
        )
    }
    
    /// Domain Model을 Entity로 변환
    func toEntity(_ record: Record, context: NSManagedObjectContext) -> RecordEntity {
        let entity = RecordEntity(context: context)
        entity.id = record.id
        entity.recordDate = record.date.toLocalDateString()
        entity.recordType = record.type.rawValue
        entity.contentText = record.contentText
        entity.photoPath = record.photoPath
        entity.latitude = record.location?.latitude ?? 0
        entity.longitude = record.location?.longitude ?? 0
        entity.locationName = record.location?.name
        entity.createdAt = record.createdAt
        entity.updatedAt = record.updatedAt
        entity.updateCount = Int32(record.updateCount)
        return entity
    }
}

