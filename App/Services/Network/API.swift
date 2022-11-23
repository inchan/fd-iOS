//
//  API.swift
//  flexday
//
//  Created by inchan on 14/04/2021.
//  Copyright © 2021 flexday korea. All rights reserved.
//

import Foundation
import Alamofire

struct API {

    struct QRCoded: APIRequestable {
        
        typealias ModelType = UserInfo
        
        var url: APIRequestURL = APIRequestURL(url: "https://dev-api.flexday.kr/stores")
        
        var parameters: [String : String]? = nil
        
        var header: HTTPHeaders? {
            var header = HTTPHeaders()
            let accessToken = LoginManager.accessToken.value ?? ""
            header["Authorization"] = "Bearer \(accessToken)"
            return header
        }
        
        var method: HTTPMethod {
            return .post
        }
        
        init (qrcode: String) {
            let storeDomain = LoginManager.storeDomain.value ?? ""
            url.paths.append(contentsOf: [storeDomain, "qrcode", "\(qrcode)"])
        }
    }
}

struct UserInfo: Codable {
    
    var user_data: UserData?
    var tags: [String] = []
    
    
    struct UserData: Codable {
        var id: Int = 0
        var email: String = ""
        var phone: String = ""
        
    }
}

