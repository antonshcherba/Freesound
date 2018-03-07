//
//  Parsable.swift
//  FreeSound
//
//  Created by chiuser on 3/7/18.
//  Copyright © 2018 Anton Shcherba. All rights reserved.
//

import Foundation
import SwiftyJSON

protocol Parsable {
    
    init()
    
    func configureWithJson(_ json: JSON)
}
