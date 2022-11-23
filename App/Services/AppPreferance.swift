//
//  AppPreferance.swift
//  App
//
//  Created by kangc on 2022/11/23.
//  Copyright © 2022 Enliple. All rights reserved.
//

import Foundation


struct AppPreferance {
    
    static var networkConfiguration: UserDefault<String> = UserDefault<String>(key: "networkConfiguration")
    
}

struct LoginManager {
    
    static var storeDomain: UserDefault<String> = UserDefault<String>(key: "Login.StoreDomain")
    static var accessToken: UserDefault<String> = UserDefault<String>(key: "Login.AccessToken")

    static var isLogin: Bool {
        return LoginManager.storeDomain.value?.count != 0 && LoginManager.accessToken.value?.count != 0
    }
}
