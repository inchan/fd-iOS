//
//  UserDefalut.swift
//  flexday
//
//  Created by inchan on 2021/04/22.
//  Copyright © 2021 Enliple. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

struct UserDefault<T> {
    
    let key: String
    
    var value: T? {
        get {
            if T.self == String.self {
                return UserDefaults.standard.string(forKey: key) as? T
            }
            return UserDefaults.standard.object(forKey: key) as? T
        }
        set {
            setValue(newValue)
        }
    }
    
    let rxValue = BehaviorSubject<T?>(value: nil)
        
    func setValue(_ value: T?) {
        if let value = value {
            UserDefaults.standard.set(value, forKey: key)
        }
        else {
            UserDefaults.standard.removeObject(forKey: key)
        }
        
        UserDefaults.standard.synchronize()
        rxValue.onNext(value)
    }
    
    func setValue<T: Codable>(_ value: T?) {
        UserDefaults.standard.set(object: value, forKey: key)
    }
}

