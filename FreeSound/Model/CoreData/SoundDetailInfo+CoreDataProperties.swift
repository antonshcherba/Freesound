//
//  SoundDetailInfo+CoreDataProperties.swift
//  
//
//  Created by Anton Shcherba on 5/13/16.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension SoundDetailInfo {

    @NSManaged var bitrate: Int64
    @NSManaged var duration: Double
    @NSManaged var filesize: Int64
    @NSManaged var image: String
    @NSManaged var previewSound: String
    @NSManaged var type: String
    @NSManaged var userDescription: String
    @NSManaged var info: SoundInfo

}
