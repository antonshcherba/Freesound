//
//  RequestBuilder.swift
//  FreeSound
//
//  Created by Anton Shcherba on 2/27/18.
//  Copyright © 2018 Anton Shcherba. All rights reserved.
//

import Foundation

class RequestBuilder {
    static func create(request: FRRequest) -> URLRequest {
        var urlString = request.url! + request.path
        if let method = request.httpMethod {
            switch method {
            case "GET":
                let urlParams = request.params.map({ (key, value) -> String in
                    "\(key)=\(value)"
                }).joined(separator: "&")
                
                if urlParams.count > 0 {
                    urlString += "?" + urlParams
                }
            default:
                break
            }
        }
        
        let url = URL(string: urlString)!
        
        var urlRequest = URLRequest(url: url)
        
        urlRequest.httpMethod = request.httpMethod
        
        request.headers.forEach {
            urlRequest.addValue($0.value, forHTTPHeaderField: $0.key)
        }
        
        urlRequest.timeoutInterval = 30
        
        
        
        
        return urlRequest
    }
    
    
}
