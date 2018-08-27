//
//  ResultType.swift
//  FreeSound
//
//  Created by Anton Shcherba on 3/5/18.
//  Copyright © 2018 Anton Shcherba. All rights reserved.
//

import Foundation

enum ResultType<Value> {
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

extension ResultType {
    func flatMap<U>(transform: (Value) -> ResultType<U>) -> ResultType<U> {
        switch self {
        case .success(let value): return transform(value)
        case .failure(let err): return .failure(err)
        }
    }
    
    public func map<U>(_ transform: (Value) throws -> U) -> ResultType<U> {
        switch self {
        case .success(let val): return ResultType<U> { try transform(val) }
        case .failure(let e): return .failure(e)
        }
    }
}
