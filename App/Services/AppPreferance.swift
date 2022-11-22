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
