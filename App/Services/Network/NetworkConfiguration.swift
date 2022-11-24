//
//  Configuration.swift
//  flexday
//
//  Created by inchan on 2021/04/20.
//  Copyright © 2021 Enliple. All rights reserved.
//

import Foundation

struct NetworkServer {
    struct API {
        static let live = "https://api.flexday.kr/stores"
        static let dev = "https://dev-api.flexday.kr/stores"
    }
    
    struct Web {
        static let live = "https://flex.day"
        static let dev = "https://dev-store.flex.day"
    }
}

enum ServerConfiguration: String, CaseIterable {
    case live
    case dev
    
    var webHost: String {
        switch self {
        case .dev: return NetworkServer.Web.dev
        default: return NetworkServer.Web.live
        }
    }
    
    var apiHost: String {
        switch self {
        case .dev: return NetworkServer.API.dev
        default: return NetworkServer.API.live
        }
    }
}


