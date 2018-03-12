//
//  SearchResult.swift
//  FreeSound
//
//  Created by Anton Shcherba on 5/6/16.
//  Copyright © 2016 Anton Shcherba. All rights reserved.
//

import Foundation
import SwiftyJSON
import CoreData

class SearchResult {
    
    var count: Int
    
    var next: String?
    
    var previous: String?
    
    var results: [Any]
    
    required init() {
        count = 0
        results = []
    }
    
    init(count: Int, nextURL: String?, previousURL: String?, searchResults results: [Any]) {
        self.count = count
        self.next = nextURL
        self.previous = previousURL
        self.results = results
    }
    
    convenience init?(fromJSON json: JSON) {
        guard let count = json["count"].int else {
            return nil
        }
        
        let previous = json["previous"].string
        let next = json["next"].string
        
        self.init(count: count, nextURL: next, previousURL: previous, searchResults: [])
    }
}

extension SearchResult: CustomStringConvertible {
    
    var description: String {
        var description = "Results count: \(count)\n"
        
        if let next = next {
            description += "URL to the next page: \(next)"
        }
        
        if let previous = previous {
            description += "URL to the previous page: \(previous)"
        }
        
        return description
    }
}

extension SearchResult: Parsable {
    func configureWithJson(_ json: JSON) {
        let searchJSONResult = json//JSON(data: data)
//        let tmp = String(data: data, encoding: String.Encoding.utf8)
        
        let searchResult = SearchResult(fromJSON: searchJSONResult)
//        if searchResult?.count > 0 ||
//            searchResult?.count > loadedCount {
        
//            searchResult?.results = parseSearchDataFrom(data)
//        }
        
        
        let jsonResultsArray = json["results"].array
        var results = [SoundInfo]()
        
        let database = DatabaseManager()
        
        for (index, subJSON) in jsonResultsArray!.enumerated().reversed() {
            let request = NSFetchRequest<SoundInfo>(entityName: SoundInfo.entityName)
            request.predicate = NSPredicate(format: "id == %ld", subJSON["id"].intValue)
            
            do {
                let results = try database.coreData.context.fetch(request) as! [SoundInfo]
                //                if results.first != nil { jsonResultsArray?.remove(at: index) }
                
            } catch {
                fatalError("Error loading sound info: \(error)")
            }
        }
        
        
        for subJSON in jsonResultsArray! {
            let soundInfo = database.newSoundInfo
            soundInfo.configureWithJson(subJSON)
            
            results.append(soundInfo)
            
            do {
                try soundInfo.managedObjectContext?.save()
            } catch {
                fatalError("Error saving songs")
            }
            
            //            print(soundInfo.tags?.count)
        }
        
        self.results = results
        
//        return searchResult
    }
}
