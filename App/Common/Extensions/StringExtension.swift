//
//  StringExtenstion.swift
//  flexday
//
//  Created by inchan on 14/04/2021.
//  Copyright © 2021 flexday korea. All rights reserved.
//

import Foundation

extension String {
    
    var toURL: URL? {
        return URL(string: self)
    }
    
    var toTel: URL? {
        return URL(string: "telprompt://\(self)")
    }
}
