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
        let urlString = request.url! + request.path
        
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
