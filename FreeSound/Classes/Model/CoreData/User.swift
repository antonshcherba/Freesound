//
//  User.swift
//  FreeSound
//
//  Created by Anton Shcherba on 5/26/16.
//  Copyright © 2016 Anton Shcherba. All rights reserved.
//

import Foundation
import SwiftyJSON

class User: Parsable {
    
    // MARK: - Variables
    var name = ""
    
    var about = ""
    
    var avatar:UIImage?
    
    var homepage: String?
    
    var joinedDate: String?
    
    var soundsCount = 0
    
    var packsCount = 0
    
    // MARK: - Public Properties
    
    // MARK: - Private Properties
    
    // MARK: - Constructors
    
    required init() {
    }
    
    // MARK: - Methods of class
    class func start() {
        
    }
    
    // MARK: - Methods of instance
    
    func configureWithJson(_ json: JSON) {
        let username = json["username"].string
//        guard let username = json["username"].string else {
//            print("Error SoundDeetailInfo initalization! 1")
//            return
//        }
        if let usr = json["username"].string {
            self.name = usr
        }
        guard let about = json["about"].string else {
            print("Error SoundDeetailInfo initalization! 2")
            return
        }
        
        guard let homepage = json["home_page"].string else {
            print("Error SoundDeetailInfo initalization! 2")
            return
        }
        
        guard let joinedDate = json["date_joined"].string else {
            print("Error SoundDeetailInfo initalization! 3")
            return
        }
        
        guard let soundsCount = json["num_sounds"].int else {
            print("Error SoundDeetailInfo initalization! 4")
            return
        }
        
        guard let packsCount = json["num_packs"].int else {
            print("Error SoundDeetailInfo initalization! 5")
            return
        }
        
        guard let avatar = json["avatar"]["medium"].string else {
            print("Error SoundDeetailInfo initalization! 6")
            return
        }
        
//        guard let previewSound = json["previews"]["preview-hq-mp3"].string else {
//            print("Error SoundDeetailInfo initalization! 7")
//            return
//        }
        
//        self.name = usr
        if let data = try? Data(contentsOf: URL(string: avatar)!) {
            self.avatar = UIImage(data: data)
        }
        
        self.about =  about
        self.soundsCount = soundsCount
        self.packsCount = packsCount
        self.homepage = homepage
        self.joinedDate = joinedDate
        
    }
    
    // MARK: - Overrided methods
    
    // MARK: - Private methods
    
}
