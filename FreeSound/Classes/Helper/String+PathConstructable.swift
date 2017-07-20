//
//  String+PathConstructable.swift
//  FreeSound
//
//  Created by Anton Shcherba on 5/26/16.
//  Copyright © 2016 Anton Shcherba. All rights reserved.
//

import Foundation

protocol PathConstructable {
    
    static var slash: String { get }
    static var backSlash: String { get }
    static var and: String { get }
    static var questionMark: String { get }
    static var equal: String { get }
    static var blank: String { get }
}

extension String: PathConstructable {
    
    static var slash: String {
        get {
            return "/"
        }
    }
    
    static var backSlash: String {
        get {
            return "\\"
        }
    }
    
    static var and: String {
        get {
            return "&"
        }
    }
    
    static var questionMark: String {
        get {
            return "?"
        }
    }
    
    static var equal: String {
        get {
            return "="
        }
    }
    
    static var blank: String {
        get {
            return ""
        }
    }
}