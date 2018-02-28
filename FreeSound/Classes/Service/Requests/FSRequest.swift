//
//  FSRequest.swift
//  FreeSound
//
//  Created by Anton Shcherba on 2/28/18.
//  Copyright © 2018 Anton Shcherba. All rights reserved.
//

import Foundation

protocol FRRequest {
    var url: String? { get }
    
    var httpMethod: String? { get }
    
    var params: [String:Any] { get }
    
    var path: String { get }
    
    var headers: [String: String] { get }
}
