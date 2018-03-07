//
//  Error.swift
//  FreeSound
//
//  Created by Anton Shcherba on 3/6/18.
//  Copyright © 2018 Anton Shcherba. All rights reserved.
//

import Foundation

enum NetworkError: Error {
    case responseStatusError(status: Int, message: String)
}

extension NetworkError: LocalizedError {
    var localizedDescription: String {
        switch self {
        case let .responseStatusError(status, message):
            return "NetworkError \nStatus \(status) \nMessage \(message)"
        }
    }
}

enum SomeError: Error {
    case wrongData
}
