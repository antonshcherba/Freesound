//
//  CommentCoreData+CoreDataProperties.swift
//  
//
//  Created by chiuser on 2/5/18.
//
//

import Foundation
import CoreData


extension CommentCoreData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CommentCoreData> {
        return NSFetchRequest<CommentCoreData>(entityName: "CommentCoreData")
    }

    @NSManaged public var created: TimeInterval
    @NSManaged public var text: String?

}
