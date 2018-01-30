//
//  Tag+CoreDataProperties.swift
//  
//
//  Created by Anton Shcherba on 7/6/17.
//
//

import Foundation
import CoreData


extension Tag {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Tag> {
        return NSFetchRequest<Tag>(entityName: "Tag")
    }

    @NSManaged public var title: String
    @NSManaged public var soundInfo: NSSet?

}

// MARK: Generated accessors for soundInfo
extension Tag {

    @objc(addSoundInfoObject:)
    @NSManaged public func addToSoundInfo(_ value: SoundInfo)

    @objc(removeSoundInfoObject:)
    @NSManaged public func removeFromSoundInfo(_ value: SoundInfo)

    @objc(addSoundInfo:)
    @NSManaged public func addToSoundInfo(_ values: NSSet)

    @objc(removeSoundInfo:)
    @NSManaged public func removeFromSoundInfo(_ values: NSSet)

}
