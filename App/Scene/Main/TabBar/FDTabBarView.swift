//
//  MainTabbarView.swift
//  Store
//
//  Created by inchan on 2022/05/12.
//

import Foundation
import UIKit

enum TabbarItemTag: Int {
    case store, staff, payment, apply, calculate
}

class FDTabBarView: FDBaseView {
    
    @IBOutlet var stackView: UIStackView?
    @IBOutlet var controls: [UIControl]?
 
    override func awakeFromNib() {
        super.awakeFromNib()

        controls?.forEach({ (control) in
            if let index = self.controls?.firstIndex(of: control) {
                control.tag = index
                
                if index != TabbarItemTag.payment.rawValue {
                    control.subviews.forEach({
                        if let label = $0 as? UILabel {
                            label.textColor = .black
                        }
                    })
                }
            }
        })
    }
    
    @IBAction func btnActions(sender: UIControl) {
        controls?.forEach({ (control) in
            control.isSelected = control == sender
        })
    }
}
