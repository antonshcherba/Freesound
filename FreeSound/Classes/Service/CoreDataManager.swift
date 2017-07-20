//
//  CoreDataManager.swift
//  FreeSound
//
//  Created by Anton Shcherba on 5/11/16.
//  Copyright © 2016 Anton Shcherba. All rights reserved.
//

import Foundation
import CoreData

class CoreDataManager {
    
    static let sharedInstance = CoreDataManager()
    
    var context: NSManagedObjectContext!
    
    var psc: NSPersistentStoreCoordinator!
    
    let modelName = "FreeSound"
    
    let modelExtension = "momd"
    
    let storeName = "FreeSound"
    
    let storeExtension = "sqlite"
    
    
    fileprivate init() {
        
        psc = self.createPersistanceStoreCoordinatorForModel(mom)
        addPersistanceStoreTo(psc)
        
        context = newContext
        
    }
    
    var mom: NSManagedObjectModel {
        guard let modelURL = Bundle.main.url(forResource: modelName, withExtension: modelExtension) else {
            fatalError("Error loading model from bundle")
        }
        
        guard let mom = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError("Error initializing mom from: \(modelURL)")
        }
        return mom
    }
    
    var newContext: NSManagedObjectContext {
        let moc = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        moc.persistentStoreCoordinator = psc
        
        return moc
    }
    
    var newChildContext: NSManagedObjectContext {
        let moc = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        
        return moc
    }
    
    fileprivate func createPersistanceStoreCoordinatorForModel(_ model: NSManagedObjectModel) -> NSPersistentStoreCoordinator {
        
        let psc = NSPersistentStoreCoordinator(managedObjectModel: model)
        return psc
    }
    
    fileprivate func addPersistanceStoreTo(_ coordinator: NSPersistentStoreCoordinator) {
        DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated).async
        { [unowned self] in
            
            let urls = FileManager.default.urls(for: .documentDirectory,
                                                                       in: .userDomainMask)
            let docURL = urls[urls.endIndex-1]
            let storeURL = docURL.appendingPathComponent(self.storeName + "." + self.storeExtension)
            
            do {
                try coordinator.addPersistentStore(ofType: NSSQLiteStoreType,
                                                           configurationName: nil,
                                                           at: storeURL,
                                                           options: nil)
                
            } catch {
                
                do {
                    try FileManager.default.removeItem(at: storeURL)
                } catch {
                    fatalError("Error deleting old store; \(error)")
                }
                fatalError("Error migrating store; \(error)")
            }
            
            print("Succesfully created Core Data Stack")
        }
    }
}
