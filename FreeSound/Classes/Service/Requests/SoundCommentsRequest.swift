//
//  SoundCommentsRequest.swift
//  FreeSound
//
//  Created by Anton Shcherba on 3/4/18.
//  Copyright © 2018 Anton Shcherba. All rights reserved.
//

import Foundation

class SoundCommentsRequest: FRRequest {
    var url: String?
    
    var httpMethod: String?
    
    var params: [String:Any] = [:]
    
    var path = ""
    
    var headers: [String: String]
    
    init(id: Int) {
        url = "https://freesound.org/apiv2/"
        httpMethod = "GET"
        path = "sounds/\(id)/comments/"
        
        headers = ["Authorization": "Bearer \(oauthSwift!.client.credential.oauthToken)"]
    }
}
