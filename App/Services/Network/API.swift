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

    struct apps: APIRequestable {
        
        typealias ModelType = UserInfo
        
        var url: String = "https://flexday.co.kr/apps"
        
        var parameters: [String : String]? = nil
        
        var header: HTTPHeaders? {
            return HTTPHeaders()
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

