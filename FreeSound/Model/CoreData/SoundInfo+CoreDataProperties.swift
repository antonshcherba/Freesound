//
//  SoundInfo+CoreDataProperties.swift
//  FreeSound
//
//  Created by chiuser on 7/6/17.
//  Copyright © 2017 Anton Shcherba. All rights reserved.
//
//

import Foundation
import CoreData


extension SoundInfo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SoundInfo> {
        return NSFetchRequest<SoundInfo>(entityName: "SoundInfo")
    }

    @NSManaged public var avgRating: Int64
    @NSManaged public var created: TimeInterval
    @NSManaged public var downloadsCount: Int64
    @NSManaged public var id: Int64
    @NSManaged public var latitude: Double
    @NSManaged public var license: String?
    @NSManaged public var longitude: Double
    @NSManaged public var name: String?
    @NSManaged public var type: String?
    @NSManaged public var username: String?
    @NSManaged public var detailInfo: SoundDetailInfo?
    @NSManaged public var tags: NSSet?

    public var fullName: String? {
        guard let name = name,
            let type = type else { return nil }
        
        return [name,".",type].reduce("",+)
    }
}

// MARK: Generated accessors for tags
extension SoundInfo {

    @objc(addTagsObject:)
    @NSManaged public func addToTags(_ value: Tag)

    @objc(removeTagsObject:)
    @NSManaged public func removeFromTags(_ value: Tag)

    @objc(addTags:)
    @NSManaged public func addToTags(_ values: NSSet)

    @objc(removeTags:)
    @NSManaged public func removeFromTags(_ values: NSSet)

}
