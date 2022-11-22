//
//  Identifiable.swift
//  flexday
//
//  Created by inchan on 14/04/2021.
//  Copyright © 2019 inchan. All rights reserved.
//

import Foundation

public protocol Identifiable: NSObjectProtocol {
    static var identifier: String { get }
}

public extension Identifiable {
    static var identifier: String {
        return String(describing: self)
    }
}
