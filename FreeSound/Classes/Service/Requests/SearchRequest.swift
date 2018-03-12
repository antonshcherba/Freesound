//
//  SearchRequest.swift
//  FreeSound
//
//  Created by Anton Shcherba on 3/9/18.
//  Copyright © 2018 Anton Shcherba. All rights reserved.
//

import Foundation

class SearchRequest: FRRequest {
    var url: String?
    
    var httpMethod: String?
    
    var params: [String:Any] = [:]
    
    var path = ""
    
    var headers: [String: String]
    
    init(query: String, filter: FilterParameter?, sort: SortParameter?) {
//        url = "https://freesound.org/apiv2/"
        url = ResourcePathManager().searchPath
        httpMethod = "GET"
//        path = "sounds/\(id)/"
        
        headers = ["Authorization": "Bearer \(oauthSwift!.client.credential.oauthToken)"]
        
        var queryParams: [String: String] = [:]
        
        if let sortParameter = sort {
            queryParams["sort"] = sortParameter.rawValue
        }
        if let filterParameter = filter {
            queryParams["filter"] = filterParameter.rawValue + ":\(query)"
        }
        
        let fields = ["id", "username", "name", "license", "num_downloads", "type", "tags", "geotag"]
        let fieldsString = fields.joined(separator: ",")
        
        params = (queryParams + [ResourcePathManager.RequestParameter.Query: query,
                                 ResourcePathManager.RequestParameter.Fields: fieldsString])
//            .map { key, value in key + String.equal + value }
        
//        return searchPath + String.questionMark + params
    }
}
