//
//  Comment+CoreDataClass.swift
//  
//
//  Created by Anton Shcherba on 7/20/17.
//
//

import Foundation
import CoreData
import SwiftyJSON

public class Comment: NSManagedObject {

    var user: User?
    
    func configureWithJson(_ json: JSON) {
        guard let text = json["comment"].string else {
            print("Error Comment initalization! 1")
            return
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS"//this your string date format
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone!
        let date = dateFormatter.date(from: "")
        
        guard let createdString = json["created"].string,
            let created = dateFormatter.date(from: createdString) else {
            print("Error Comment initalization! 2")
            return
        }
        
        guard let username = json["username"].string else {
            print("Error Comment initalization! 3")
            return
        }
        
        self.text = text
        self.created = created.timeIntervalSince1970
        
        let user = User()
        user.name = username
        self.user = user
    }
}
