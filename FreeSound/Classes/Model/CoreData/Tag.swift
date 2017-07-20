//
//  Tag.swift
//  
//
//  Created by Anton Shcherba on 5/16/16.
//
//

import Foundation
import CoreData
import SwiftyJSON


class Tag: NSManagedObject {

    class var entityName:String {
        get {
            return "Tag"
        }
    }
    
    func configureWithJson(_ json: JSON) {
        
        guard let title = json.string else {
            print("Error Tag initalization! 1")
            return
        }
        
        self.title = title
    }
    
    class func tagsFromJSON(_ json: JSON, context: NSManagedObjectContext) -> [Tag] {
//        let database = DatabaseManager()
//        let tagsContext = database.coreData.context
//        tagsContext.parentContext = context
        
//        var tagss = [String]()
//        for tagJSON in json["tags"].array! {
//            
//            tagss.append(tagJSON.stringValue)
//        }
        
        let tagsTitle = json["tags"].array!.map { $0.stringValue }
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Tag.entityName)
        fetchRequest.predicate = NSPredicate(format: "title IN %@", tagsTitle)
        
        var existingTags: [Tag]
        do {
            existingTags = try context.fetch(fetchRequest) as! [Tag]
        } catch {
            fatalError("Fetch Tags: \(error)")
        }
        
        let existTagsTitles = existingTags.map() {$0.title}
        let newTags = tagsTitle.filter() { !existTagsTitles.contains($0) }
        
        for title in newTags {
            let tag = NSEntityDescription.insertNewObject(forEntityName: Tag.entityName, into: context) as! Tag
            tag.title = title
            existingTags.append(tag)
        }
        
        do {
            try context.save()
        } catch {
            fatalError("Error saving Tags: \(error)")
        }
        
//        print("Tags count: \(existingTags.count)")
        return existingTags
    }
}
