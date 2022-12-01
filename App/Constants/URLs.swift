//
//  URLs.swift
//  App
//
//  Created by kangc on 2022/11/23.
//  Copyright © 2022 Enliple. All rights reserved.
//

import Foundation

struct URLs {
    
    static let appStore: String = "https://itunes.apple.com/app/id\(Constant.Identifier.AppStoreId)?mt=8"
    static let appStoreLoockup: String = "http://itunes.apple.com/lookup?id=\(Constant.Identifier.AppStoreId)"
}

extension URLs {
    
    enum Web: Int, CaseIterable {
        case store, staff, payment, apply, calculate
        
        var url: String {
            
            guard let baseURL = NetworkService.server?.web.url?.absoluteString else {
                return ""
            }
            
            switch self {
            case .store: return baseURL
            case .staff: return baseURL + "/store/login"
            case .apply: return baseURL
            case .calculate: return baseURL + "/store/calculator"
            default: return "brank"
            }
        }
    }
}
