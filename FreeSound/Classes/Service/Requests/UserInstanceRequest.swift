//
//  UserInstanceRequest.swift
//  FreeSound
//
//  Created by Anton Shcherba on 2/27/18.
//  Copyright © 2018 Anton Shcherba. All rights reserved.
//

import Foundation

class UserInstanceRequest: FRRequest {
    var url: String?
    
    var httpMethod: String?
    
    var params: [String:Any] = [:]
    
    var path = ""
    
    var headers: [String: String]
    
    init(username: String) {
        url = "https://freesound.org/apiv2/"
        httpMethod = "GET"
        path = username == "me" ? "me/" : "users/\(username)/"
        
        headers = ["Authorization": "Bearer \(oauthSwift!.client.credential.oauthToken)"]
    }
}
