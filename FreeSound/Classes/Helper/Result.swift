//
//  Result.swift
//  FreeSound
//
//  Created by Anton Shcherba on 3/5/18.
//  Copyright © 2018 Anton Shcherba. All rights reserved.
//

import Foundation

enum Result<Value> {
    case success(Value)
    case failure(Error)
    
    public init(_ capturing: () throws -> Value) {
        do {
            self = .success(try capturing())
        } catch {
            self = .failure(error)
        }
    }
}

extension Result {
    func flatMap<U>(transform: (Value) -> Result<U>) -> Result<U> {
        switch self {
        case .success(let value): return transform(value)
        case .failure(let err): return .failure(err)
        }
    }
    
    public func map<U>(_ transform: (Value) throws -> U) -> Result<U> {
        switch self {
        case .success(let val): return Result<U> { try transform(val) }
        case .failure(let e): return .failure(e)
        }
    }
}
