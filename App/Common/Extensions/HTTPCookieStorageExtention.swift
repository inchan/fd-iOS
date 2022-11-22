//
//  HTTPCookieStorageExtention.swift
//  flexday
//
//  Created by inchan on 2021/04/22.
//  Copyright © 2021 Enliple. All rights reserved.
//

import Foundation

extension HTTPCookieStorage {
    
    private static func restoreKey() -> String {
        return "cookies_restore_key"
    }
    
    static func clear() {
        HTTPCookieStorage.shared.cookies?.forEach({ HTTPCookieStorage.shared.deleteCookie($0) })
    }
    
    static func saveAll() {
        
        var cookies = [Any]()
        
        HTTPCookieStorage.shared.cookies?.forEach({ (newCookie) in
            var cookie = [HTTPCookiePropertyKey : Any]()
            cookie[.name] = newCookie.name
            cookie[.value] = newCookie.value
            cookie[.domain] = newCookie.domain
            cookie[.path] = newCookie.path
            cookie[.version] = newCookie.version
            if let date = newCookie.expiresDate {
                cookie[.expires] = date
            }
            cookies.append(cookie)
            
        })
        
        UserDefaults.standard.setValue(cookies, forKey: HTTPCookieStorage.restoreKey())
        UserDefaults.standard.synchronize()
    }
    
    static func restore(){
        
        guard let cookies = UserDefaults.standard.value(forKey: HTTPCookieStorage.restoreKey()) as? [[HTTPCookiePropertyKey : Any]] else { return }
        
        cookies.forEach { (cookie) in
            if let oldCookie = HTTPCookie(properties: cookie) {
                HTTPCookieStorage.shared.setCookie(oldCookie)
            }
        }
    }
    
    
}

