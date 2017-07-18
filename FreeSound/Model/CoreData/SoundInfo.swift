//
//  SoundInfo.swift
//  
//
//  Created by Anton Shcherba on 5/11/16.
//
//

import Foundation
import CoreData
import SwiftyJSON


class SoundInfo: NSManagedObject {

    class var entityName:String {
        get {
            return "SoundInfo"
        }
    }
    
    func configureWithJson(_ json: JSON) {
        guard let id = json["id"].int else {
            print("Error SoundInfo initalization! 1")
            return
        }
        
        guard let name = json["name"].string else {
            print("Error SoundInfo initalization! 2")
            return
        }
        
        guard let username = json["username"].string else {
            print("Error SoundInfo initalization! 3")
            return
        }
        
        guard let license = json["license"].string else {
            print("Error SoundInfo initalization! 4")
            return
        }

        guard let type = json["type"].string else {
            print("Error SoundInfo initalization! 5")
            return
        }
        
        guard let downloadsCount = json["num_downloads"].int else {
            print("Error SoundInfo initalization! 4")
            return
        }
//        var tags = [String]()
//        for tagJSON in json["tags"].array! {
//            tags.append(tagJSON.stringValue)
//        }
        
        self.id = Int64(id)
        self.name = name
        self.username = username
        self.license = license
        self.type = type
        self.downloadsCount = Int64(downloadsCount)
        let tags = NSSet(array: Tag.tagsFromJSON(json, context: self.managedObjectContext!))
        self.tags = tags
        
        
        if let geodata = json["geotag"].string?.components(separatedBy: " "),
            let latitude = Double(geodata[0]),
            let longitude = Double(geodata[1]) {
            
            self.latitude = latitude
            self.longitude = longitude
        } else {
            self.latitude = 0
            self.longitude = 0
        }
    }
}
