//
//  UIApplicationExtension.swift
//  flexday
//
//  Created by inchan on 14/04/2021.
//  Copyright © 2021 flexday korea. All rights reserved.
//

import Foundation
import UIKit

extension UIApplication {
    
    public var topViewController: UIViewController? {
        
        func topViewController(target: UIViewController) -> UIViewController? {
            if let presentedViewController = target.presentedViewController {
                return topViewController(target: presentedViewController)
            }
            else if let navigationController = target as? UINavigationController {
                if let viewController = navigationController.viewControllers.last {
                    return topViewController(target: viewController)
                }
            }
            return target
        }

        guard let rootViewController = windows.last?.rootViewController else { return nil }
        return topViewController(target: rootViewController)
    }
}
