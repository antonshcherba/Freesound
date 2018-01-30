//
//  DatabaseManager.swift
//  FreeSound
//
//  Created by Anton Shcherba on 5/11/16.
//  Copyright © 2016 Anton Shcherba. All rights reserved.
//

import Foundation
import CoreData


class DatabaseManager {
    
    let coreData = CoreDataManager.sharedInstance
    
    var newSoundInfo: SoundInfo {
        
        let tmp = NSEntityDescription.insertNewObject(forEntityName: SoundInfo.entityName,
                                                                   into: coreData.context) as! SoundInfo
        
        return tmp
    }
    
    var newComment: CommentCoreData {
        return NSEntityDescription.insertNewObject(forEntityName: CommentCoreData.entityName,
                                                                   into: coreData.context) as! CommentCoreData
    }
    
    var newSoundDetailInfo: SoundDetailInfo {
        return NSEntityDescription.insertNewObject(forEntityName: SoundDetailInfo.entityName,
                                                   into: coreData.context) as! SoundDetailInfo
    }
    
    func fetchDetailInfoForID(_ id: Int64) -> SoundDetailInfo? {
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: SoundDetailInfo.entityName)
        request.predicate = NSPredicate(format: "id == %ld", id)
        
        do {
            let results = try coreData.newContext.fetch(request) as! [SoundDetailInfo]
            return results.first
        } catch {
            fatalError("Error loading detail info: \(error)")
        }
    }
    
    func saveObject<T: NSManagedObject>(_ object: T) {
        
        do {
//            try object.managedObjectContext?.save()
        } catch {
            fatalError("Error saving: \(error)")
        }
    }
    
    func soundsInfoCount() -> Int {
        
        var error: NSError?
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: SoundInfo.entityName)
        request.sortDescriptors = []
        
        let count = try? coreData.context.count(for: request)
        
        return count ?? 0
    }
    
    func soundsInfoCount(from request: NSFetchRequest<NSFetchRequestResult>) -> Int {
        
        var error: NSError?
        request.sortDescriptors = []
        let count = try? coreData.context.count(for: request)
        
        return count ?? 0
    }
}
