//
//  Comment+CoreDataProperties.swift
//  
//
//  Created by Anton Shcherba on 7/20/17.
//
//

import Foundation
import CoreData


extension Comment {

    class var entityName:String {
        get {
            return "Comment"
        }
    }
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Comment> {
        return NSFetchRequest<Comment>(entityName: "Comment")
    }

    @NSManaged public var text: String?
    @NSManaged public var created: TimeInterval

}
