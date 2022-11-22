//
//  URLExtension.swift
//  flexday
//
//  Created by inchan on 14/04/2021.
//  Copyright © 2021 flexday korea. All rights reserved.
//

import Foundation
import UIKit

extension URL {
    
    func openExternal(options: [UIApplication.OpenExternalURLOptionsKey : Any] = [:], completion: ((Bool) -> Void)? = nil) {
        guard UIApplication.shared.canOpenURL(self) == true else {
            completion?(false)
            return
        }
        UIApplication.shared.open(self, options: options, completionHandler: completion)
    }
}
