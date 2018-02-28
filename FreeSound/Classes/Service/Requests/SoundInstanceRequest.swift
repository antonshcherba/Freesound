//
//  SoundInstanceRequest.swift
//  FreeSound
//
//  Created by Anton Shcherba on 2/28/18.
//  Copyright © 2018 Anton Shcherba. All rights reserved.
//

import Foundation

class SoundInstanceRequest: FRRequest {
    var url: String?
    
    var httpMethod: String?
    
    var params: [String:Any] = [:]
    
    var path = ""
    
    var headers: [String: String]
    
    init(id: Int) {
        url = "https://freesound.org/apiv2/"
        httpMethod = "GET"
        path = "sounds/\(id)/"
        
        headers = ["Authorization": "Bearer \(oauthSwift!.client.credential.oauthToken)"]
    }
}
