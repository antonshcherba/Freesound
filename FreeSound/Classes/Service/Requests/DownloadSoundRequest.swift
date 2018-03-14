//
//  DownloadSoundRequest.swift
//  FreeSound
//
//  Created by Anton Shcherba on 3/13/18.
//  Copyright © 2018 Anton Shcherba. All rights reserved.
//

import Foundation

class DownloadSoundRequest: FRRequest {
    var url: String?
    
    var httpMethod: String?
    
    var params: [String:Any] = [:]
    
    var path = ""
    
    var headers: [String: String]
    
    init(id: String) {
        url = ResourcePathManager().downloadSoundPathFor(id)
        httpMethod = "GET"
        
        headers = ["Authorization": "Bearer \(oauthSwift!.client.credential.oauthToken)"]
    }
}
