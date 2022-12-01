//
//  API.swift
//  flexday
//
//  Created by inchan on 14/04/2021.
//  Copyright © 2021 flexday korea. All rights reserved.
//

import Foundation
import Alamofire

protocol FDBaseRequestable: Requestable {
    var needAuthrization: Bool { get }
}

extension FDBaseRequestable {
    
    var url: RequestURL {
        RequestURL(url: NetworkService.server!.api)
    }
    
    var header: HTTPHeaders? {
        var header = HTTPHeaders()
        if needAuthrization == true, let accessToken = LoginManager.AccessToken.value {
            header["Authorization"] = "Bearer \(accessToken)"
        }
        return header
    }
    
    var needAuthrization: Bool {
        return true
    }
}

struct API {
    
    struct GetQRCode: FDBaseRequestable {
        
        typealias ModelType = Coupon
        
        var url: RequestURL = RequestURL(url: NetworkService.server!.api)
                                
        var method: HTTPMethod = .post
        
        var parameters: [String : String]? = nil
        
        init (qrcode: String) {
            let storeDomain = LoginManager.StoreDomain.value ?? ""
            url.paths.append(contentsOf: [storeDomain, "mobile-qrcode", "\(qrcode)"])
        }
    }
}
