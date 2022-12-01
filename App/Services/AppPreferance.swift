//
//  AppPreferance.swift
//  App
//
//  Created by kangc on 2022/11/23.
//  Copyright © 2022 Enliple. All rights reserved.
//

import Foundation


struct AppPreferance {
    
    static var ServerHost = UserDefault<String>(key: "ServerHost")
    
}

struct LoginManager {
    
    static var StoreDomain = UserDefault<String>(key: "Login.StoreDomain")
    static var AccessToken = UserDefault<String>(key: "Login.AccessToken")

    static var isLogin: Bool {
        return LoginManager.StoreDomain.value?.count != 0 && LoginManager.AccessToken.value?.count != 0
    }
}
