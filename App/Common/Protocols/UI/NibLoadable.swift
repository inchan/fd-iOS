//
//  NibLoadable.swift
//  flexday
//
//  Created by inchan on 14/04/2021.
//  Copyright © 2019 inchan. All rights reserved.
//

import Foundation
import UIKit

public protocol NibLoadable: Identifiable {
    static var nibName: String { get }
    static var nibBundle: Bundle { get }
    static var nib: UINib { get }
    static func loadFromNib() -> Self?
}

public extension NibLoadable {
    static var nibName: String {
        return identifier
    }
    static var nibBundle: Bundle {
        return Bundle(for: self)
    }
    static var nib: UINib {
        return UINib(nibName: nibName, bundle: nibBundle)
    }
}

public extension NibLoadable where Self: UIView {
    static func loadFromNib() -> Self? {
        guard let nibs = Self.nibBundle.loadNibNamed(Self.nibName, owner: nil) else {
            print("Don't have a Nib File - \(nibName)")
            return nil
        }
        return nibs.lazy.filter { $0 is Self }.first as? Self
    }
}

public extension NibLoadable where Self: UIViewController {
    static func loadFromNib() -> Self? {
        return self.init(nibName: Self.nibName, bundle: Self.nibBundle)
    }
}
