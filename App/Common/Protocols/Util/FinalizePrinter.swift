//
//  FinalizePrinter.swift
//  flexday
//
//  Created by inchan on 14/04/2021.
//  Copyright © 2021 flexday korea. All rights reserved.
//

import Foundation

protocol FinalizePrinter: class {
    func printFinalize()
}

extension FinalizePrinter {
    func printFinalize() {
        let className = type(of: self)
        let instanceAddress = MemoryAddress(of: self)
        print("=================================================================================")
        print("     deinit - \(className) <\(instanceAddress)>")
        print("=================================================================================")
    }
}

struct MemoryAddress<T>: CustomStringConvertible {

    let intValue: Int

    var description: String {
        let length = 2 + 2 * MemoryLayout<UnsafeRawPointer>.size
        return String(format: "%0\(length)p", intValue)
    }

    init(of structPointer: UnsafePointer<T>) {
        intValue = Int(bitPattern: structPointer)
    }
    
    init(of classInstance: T) {
        intValue = unsafeBitCast(classInstance, to: Int.self)
    }
}
