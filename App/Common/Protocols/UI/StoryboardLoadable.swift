//
//  StoryboardLoadable.swift
//  flexday
//
//  Created by inchan on 14/04/2021.
//  Copyright © 2019 inchan. All rights reserved.
//

import Foundation
import UIKit

public protocol StoryboardLoadable: Identifiable {
    static func loadFromStoryboard(_ storyboardName: String?) -> Self?
}

public extension StoryboardLoadable {
    static func loadFromStoryboard(_ storyboardName: String?) -> Self? {
        return nil
    }
}

public extension StoryboardLoadable where Self: UIViewController {
        
    /// instance from storyboard
    /// ViewControllerClassName.instanceFromStoryboard()
    /// - Parameters:
    ///   - storyboardName: Storyboard to which the ViewController belongs (if nil -> search storyboard)
    /// - Returns: self instance (optional value)
    ///
    static func loadFromStoryboard(_ storyboardName: String? = nil) -> Self? {
        let className = String(describing: self)
        func fromStoryboardHelper<T>(_ storyboardName: String?) -> T? where T: UIViewController {
            if let sbName = storyboardName {
                let storyboard = UIStoryboard(name: sbName, bundle: Bundle(for: T.self))
                return storyboard.instantiateViewController(withIdentifier: className) as? T
            }
            else {
                return self.getInstanceFromStoryboard(className) as? T
            }
        }
        return fromStoryboardHelper(storyboardName)
    }
    
    /// Get an instance of a nib whose Identifier matches on the storyboard
    /// - Parameters:
    ///   - identifier: ViewController identifier
    /// - Returns: identifier UIViewController instance (optional value)
    ///
    static func getInstanceFromStoryboard (_ identifier: String) -> UIViewController? {
        guard let resourcePath = Bundle(for: self).resourcePath else { return nil }
        let paths: Array = storyboardAllPaths(resourcePath)
        let path = paths.filter { (path) -> Bool in
            let storyboardContents = try? FileManager.default.contentsOfDirectory(atPath: path)
            return storyboardContents?.filter({ $0 == identifier + ".nib"}).first != nil
        }
        
        guard let sbName: String = path.first?.components(separatedBy: "/").last?.components(separatedBy: ".").first else {
            return nil
        }
        let sb = UIStoryboard(name: sbName, bundle: Bundle.main)
        return sb.instantiateViewController(withIdentifier: identifier)
    }
    
    private static func storyboardAllPaths(_ resourcePath: String ) -> [String] {
        var fileNames: [String] = []
        do {
            if let resourceContents: Array = try? FileManager.default.contentsOfDirectory(atPath: resourcePath) {
                for itemPath: String  in resourceContents {
                    if let fileExtention = itemPath.components(separatedBy: ".").last, fileExtention == "storyboardc" {
                        fileNames.append(resourcePath + "/" + itemPath)
                    }
                    else {
                        let filePath: String = resourcePath + "/" + itemPath
                        var isDirectory: ObjCBool = false
                        let fileExistsAtPath: Bool = FileManager.default.fileExists(atPath: filePath, isDirectory: &isDirectory)
                        // 디렉터리고 파일이 존재하면 재귀호출
                        if isDirectory.boolValue && fileExistsAtPath {
                            let tempPaths: Array = storyboardAllPaths(filePath)
                            if tempPaths.count > 0 {
                                fileNames.append(contentsOf: tempPaths)
                            }
                        }
                    }
                }
            }
        }
        return fileNames
    }
}
