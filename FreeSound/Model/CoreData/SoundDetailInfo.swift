//
//  SoundDetailInfo.swift
//  
//
//  Created by Anton Shcherba on 5/12/16.
//
//

import Foundation
import CoreData
import SwiftyJSON

enum FileType: String {
    case wav, aif, aiff, mp3, flac, unknown
    
    var title: String {
        let result: String
        
        switch self {
        case .wav:
            result = "Wave"
        case .mp3:
            result = "Mp3"
        case .aif,.aiff:
            result = "AIFF"
        case .flac:
            result = "Flac"
        default:
            result = ""
        }
        
        return result
    }
}

class SoundDetailInfo: NSManagedObject {
    
    class var entityName: String {
        get {
            return "SoundDetailInfo"
        }
    }
    
    var typeEnum: FileType {
        get {
            return FileType(rawValue: type) ?? .unknown
        }
        set {
            type = newValue.rawValue
        }
    }
    
    func configureWithJson(_ json: JSON) {
        guard let description = json["description"].string else {
            print("Error SoundDeetailInfo initalization! 1")
            return
        }
        
        guard let imageURLString = json["images"]["waveform_m"].string else {
            print("Error SoundDeetailInfo initalization! 2")
            return
        }
        
        guard let type = json["type"].string else {
            print("Error SoundDeetailInfo initalization! 3")
            return
        }
        
        guard let bitrate = json["bitrate"].int else {
            print("Error SoundDeetailInfo initalization! 4")
            return
        }
        
        guard let filesize = json["filesize"].int else {
            print("Error SoundDeetailInfo initalization! 5")
            return
        }
        
        guard let duration = json["duration"].double else {
            print("Error SoundDeetailInfo initalization! 6")
            return
        }
        
        guard let previewSound = json["previews"]["preview-hq-mp3"].string else {
            print("Error SoundDeetailInfo initalization! 7")
            return
        }
        
        self.userDescription = description
        let data = try? Data(contentsOf: URL(string: imageURLString)!)
        self.image = imageURLString//UIImage(data: data!)!
        self.typeEnum =  FileType(rawValue: type) ?? .unknown
        self.bitrate = Int64(bitrate)
        self.filesize = Int64(filesize)
        self.duration = duration
        self.previewSound = previewSound
    }
}

typealias Duration = Double

extension Duration {
    
    var stringValue: String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second, .nanosecond]
        formatter.zeroFormattingBehavior = DateComponentsFormatter.ZeroFormattingBehavior()
        
        return formatter.string(from: self)!
    }
}

typealias Filesize = Int64

extension Filesize {
    var stringValue: String {
        return ByteCountFormatter.string(fromByteCount: self, countStyle: .file)
    }
}
