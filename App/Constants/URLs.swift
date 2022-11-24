//
//  URLs.swift
//  App
//
//  Created by kangc on 2022/11/23.
//  Copyright © 2022 Enliple. All rights reserved.
//

import Foundation

struct URLs {
    
    static let appStore: String = "https://itunes.apple.com/app/id\(Constant.Identifier.appId)?mt=8"
    static let appStoreLoockup: String = "http://itunes.apple.com/lookup?id=\(Constant.Identifier.appId)"
}

extension URLs {
    
    enum Web: Int, CaseIterable {
        case store, staff, payment, apply, calculate
        
        var url: String {
            switch self {
            case .store: return "https://flex.day"
            case .staff: return "https://dev-store.flex.day/store/login"
            case .apply: return "https://amazon.com"
            case .calculate: return "https://github.com"
            default: return "brank"
            }
        }
    }
}
