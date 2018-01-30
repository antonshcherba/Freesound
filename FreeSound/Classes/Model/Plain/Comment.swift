//
//  Comment.swift
//  FreeSound
//
//  Created by chiuser on 1/30/18.
//  Copyright © 2018 Anton Shcherba. All rights reserved.
//

import Foundation

// To parse the JSON, add this file to your project and do:
//
//   guard let comment = try Comment(json) else { ... }

import Foundation

struct Comment: Codable {
    let username: String
    let comment: String
    let created: String
    
    enum CodingKeys: String, CodingKey {
        case username = "username"
        case comment = "comment"
        case created = "created"
    }
}

// MARK: Convenience initializers

extension Comment {
    init(data: Data) throws {
        self = try JSONDecoder().decode(Comment.self, from: data)
    }
    
    init?(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else { return nil }
        try self.init(data: data)
    }
    
    init?(fromURL url: String) throws {
        guard let url = URL(string: url) else { return nil }
        let data = try Data(contentsOf: url)
        try self.init(data: data)
    }
    
    func jsonData() throws -> Data {
        return try JSONEncoder().encode(self)
    }
    
    func jsonString() throws -> String? {
        return String(data: try self.jsonData(), encoding: .utf8)
    }
}
