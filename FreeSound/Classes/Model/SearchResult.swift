//
//  SearchResult.swift
//  FreeSound
//
//  Created by Anton Shcherba on 5/6/16.
//  Copyright © 2016 Anton Shcherba. All rights reserved.
//

import Foundation
import SwiftyJSON

class SearchResult {
    
    var count: Int
    
    var next: String?
    
    var previous: String?
    
    var results: [Any]
    
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
