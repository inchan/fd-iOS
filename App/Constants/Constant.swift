//
//  URLs.swift
//  flexday
//
//  Created by inchan on 14/04/2021..
//  Copyright © 2021 flexday korea. All rights reserved.
//

import Foundation

struct Constant {
    
    struct Identifier {
        static let appId = "U24BE83NSS7R"
        static let userAgnet = "APP_flexday_IOS"
    }
    
    struct Key {

    }
}



enum Scheme: String, CaseIterable {
    

    case app_Version = "app_version"
    case push_setting = "push_setting"
    
    init?(url: URL?) {
        guard url?.scheme == Self.AppScheme else { return nil }
        guard let host = url?.host else { return nil }
        self.init(rawValue: host)
    }
    
    static let AppScheme = "flexdayapp"
}
