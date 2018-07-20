//
//  Concatable.swift
//  Swiftz-Validation
//
//  Created by Ricardo Pallás on 10/09/2017.
//  Copyright © 2017 Ricardo Pallas. All rights reserved.
//

import Foundation

public protocol Concatable {
    func concat(_ other : Self) -> Self
}

extension String: Concatable {
    public func concat(_ other: String) -> String {
        return self + other
    }
}

extension Array: Concatable {
    public func concat(_ other: Array<Element>) -> Array<Element> {
        return self + other
    }
}
