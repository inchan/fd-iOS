//
//  Logger.swift
//  flexday
//
//  Created by inchan on 14/04/2021.
//  Copyright © 2019 inchan. All rights reserved.
//

import Foundation

public enum LogLevel: String {
    case none       = ""
    case debug      = "[DEBUG] "
    case warning    = "[WARNING] "
    case error      = "[ERROR] "
    case notice     = "[NOTICE] "
}

public func Log<Value>(_ log: Value?, _ file: String = #file, _ function: String = #function, _ line: Int = #line, type: LogLevel? = nil) {

    if let type = type {
        Logger.shared.type = type
    }
    Logger.shared.output(log, file, function, line)
}

public class Logger {

    fileprivate static let shared = Logger()

    #if DEBUG
    public var enable = true
    #else
    public var enable = false
    #endif

    public var type: LogLevel = LogLevel.none

    fileprivate func output<Value>(_ value: Value?, _ file: String, _ function: String, _ line: Int) {
        if enable == true {
            let filename = getFileName(file)
            let type = self.type.rawValue

            if let value = value {
                print(" \(filename).\(function) <\(line)> : \(type)\(value)", terminator: "\n")
            }
            else {
                print(" \(filename).\(function) <\(line)> : \(type)\(String(describing: value))", terminator: "\n")
            }
        }
    }

    private func getFileName(_ file: String) -> String {
        guard let fileName = file.components(separatedBy: ".").first?.components(separatedBy: "/").last else {
            return file
        }
        return fileName
    }
}

extension Logger {
    
    func setIsWrite(_ newVlaue: Bool) {
        
    }
    
    var isWrite: Bool {
        get {
            return UserDefault<Bool>(key: "key.Looger.write").value ?? false
        }
        set {
            UserDefault<Bool>(key: "key.Looger.write").setValue(newValue)
        }
    }
}
