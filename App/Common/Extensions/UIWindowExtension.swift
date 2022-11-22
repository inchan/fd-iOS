//
//  UIWindow.swift
//  flexday
//
//  Created by inchan on 14/04/2021.
//  Copyright © 2021 flexday korea. All rights reserved.
//

import Foundation
import UIKit

extension UIWindow {
    
    static func windows() -> [UIWindow] {
        return UIApplication.shared.windows
    }
    
    static func last() -> UIWindow? {
        return Self.windows().last
    }
    
    static func keyWindow() -> UIWindow? {
        let windows = Self.windows()
        if windows.count > 1 {
            return windows.filter({ $0.isKeyWindow == true }).first
        }
        else {
            return windows.first
        }
    }
    
    func change(_ rootViewController: UIViewController?) {
        guard let rootViewController = rootViewController else { return }
        self.rootViewController = rootViewController
    }
}


