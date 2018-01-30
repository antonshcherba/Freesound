//
//  Comment+CoreDataProperties.swift
//  
//
//  Created by Anton Shcherba on 7/20/17.
//
//

import Foundation
import CoreData


extension CommentCoreData {

    class var entityName:String {
        get {
            return "Comment"
        }
    }
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<CommentCoreData> {
        return NSFetchRequest<CommentCoreData>(entityName: "Comment")
    }

    @NSManaged public var text: String?
    @NSManaged public var created: TimeInterval

}
