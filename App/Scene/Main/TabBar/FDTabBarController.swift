//
//  MainTabBarController.swift
//  Store
//
//  Created by inchan on 2022/05/10.
//

import Foundation
import UIKit

var kTabBarHeight: CGFloat = 80// Input the height we want to set for Tabbar here
typealias KPTabActionHandler = ( _ selectedTag: Int) -> Void

class FDTabBarController: UITabBarController, FinalizePrinter, FDBackaButtonBuilder {
    
    open var tabBarView: FDTabBarView? = nil
    
    open var isTabBarHidden = false {
        didSet{
            if isTabBarHidden == true {
                kTabBarHeight = 0
                self.tabBarView?.isHidden = true
                self.tabBar.isHidden = true
            }
            else {
                kTabBarHeight = 80
                self.tabBarView?.isHidden = false
                self.tabBar.isHidden = false
            }
            self.view.setNeedsDisplay()
        }
    }
    
    private var tabActionHandler: KPTabActionHandler? = nil

    
    // MARK: ViewController LifeCycle
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        self.displayCustomTabBar()
        
        if let viewControllers = self.viewControllers {
            
            for i in 0..<viewControllers.count {
                if let vc = viewControllers[i] as? FDBaseWebViewController {
                    vc.homeUrl = (URLs.Web(rawValue:i) ?? .store).url
                }
            }
        }
    }
    
    // MARK: Display UI
    open func displayCustomTabBar() {
        
        
        if tabBarView == nil {
            tabBarView = FDTabBarView.loadFromNib()
            self.view.addSubview(self.tabBarView!)
            tabBarView?.translatesAutoresizingMaskIntoConstraints = false;
            tabBarView?.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
            tabBarView?.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
            tabBarView?.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
            
            tabBarView?.heightAnchor.constraint(equalToConstant: kTabBarHeight + view.safeAreaInsets.bottom ).isActive = true

            
            tabBarView?.controls?.forEach({ (control) in
                control.isUserInteractionEnabled = true
                control.addTarget(self, action: #selector(controlAction), for: .touchUpInside)
            })
        }
    }
    
    override func viewSafeAreaInsetsDidChange() {
        super.viewSafeAreaInsetsDidChange()
        self.tabBarView?.constraints.forEach({
            if $0.firstAnchor == self.tabBarView?.heightAnchor || $0.secondAnchor == self.tabBarView?.heightAnchor {
                $0.constant = kTabBarHeight + view.safeAreaInsets.bottom
            }
        })
    }
    
    // MARK: Tab Button Pressed Handler
    func tabActionHandler(_ handler : KPTabActionHandler? = nil) {
        self.tabActionHandler = handler
    }

    
    // MARK: IBActions
    
    @IBAction func controlAction(sender: UIControl) {
    
        let tag = sender.tag
        
        // handler block
        if self.tabActionHandler != nil {
            self.tabActionHandler?(tag)
        }
        
        // move selected RootViewController
        if tag == self.selectedIndex {
            if let selectedNavigationController = self.selectedViewController as? UINavigationController {
                if selectedNavigationController.viewControllers.count > 1 {
                    selectedNavigationController.popToRootViewController(animated: true)
                    
                }
                else {
                    
                }
            }
//            else if let selectedWebViewController = self.selectedViewController as? FDBaseWebViewController
//            {
//
//            }
        }
        
        if (tag == 2) {
            if let vc = QRCodeReaderViewController.loadFromStoryboard() {
                self.present(vc, animated: true, completion: nil)
            }
        }
        else {
            // selected
            self.selectedIndex = tag
        }
        
    }

}


class tabbar: UITabBar {
 
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        
        super.sizeThatFits(size)
        
        return CGSize(width: size.width, height: kTabBarHeight)
    }
    
}
