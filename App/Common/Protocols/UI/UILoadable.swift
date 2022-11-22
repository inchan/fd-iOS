//
//  UILoadable.swift
//  flexday
//
//  Created by inchan on 14/04/2021.
//  Copyright © 2019 inchan. All rights reserved.
//

import Foundation
import UIKit

enum UILoadType {
    case none
    case nib
    case storyboard
}

protocol UILoadable: NibLoadable, StoryboardLoadable {
    static func loadInstance() -> Self
    static func loadInstance(_ from: UILoadType) -> Self?
}

extension UILoadable where Self: UIViewController {
    static func loadInstance() -> Self {
        return loadFromStoryboard() ?? loadFromNib() ?? Self()
    }
    
    static func loadInstance(_ from: UILoadType) -> Self? {
        switch from {
        case .storyboard: return loadFromStoryboard()
        case .nib: return loadFromNib()
        case .none: return Self()
        }
    }
}

extension UILoadable where Self: UIView {
    static func loadInstance() -> Self {
        return loadFromNib() ?? Self()
    }
    
    static func loadInstance(_ from: UILoadType) -> Self? {
        switch from {
        case .storyboard: return nil
        case .nib: return loadFromNib()
        case .none: return Self()
        }
    }
}

