//
//  MainViewController.swift
//  App
//
//  Created by inchan on 2022/11/24.
//  Copyright © 2022 Enliple. All rights reserved.
//

import UIKit
import WebKit
import Toaster

class MainViewController: FDBaseWebViewController
{
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // defined home url
        homeUrl = URLs.Web.store.url
        //self.homeUrl = URLs.Web.calculate.url
        
        setupWebBridge()
    }
    
    func setupWebBridge() {
        // defined web bridge callback handler
        self.callBackHandler = { [weak self] (message) in
            guard let strongSelf = self else { return }
            guard let body = message.body as? String else { return }
            print("WEB BRIDGE<\(message.name)>: \(body)")
            
            if body == "QRRead" {
                Toast(text: "[DEBUG] QRRead").show()
                strongSelf.presentQRCodeReaderController()
            }
            else if let jsonData = body.data(using: .utf8) {
                guard let jsonObj = try? JSONDecoder().decode([String: String].self, from: jsonData) else { return }
                LoginManager.StoreDomain.value = jsonObj["storeDomain"] ?? ""
                LoginManager.AccessToken.value = jsonObj["accessToken"] ?? ""
                Toast(text: "[DEBUG] isLogin: \(LoginManager.isLogin)").show()
                if LoginManager.isLogin {
                    #if DEBUG
                    strongSelf.presentQRCodeReaderController()
                    #endif
                }
            }
        }
    }
        
    func presentQRCodeReaderController() {
        if let qrcodeReaderController = QRCodeReaderViewController.loadFromStoryboard() {
            let navigationController = UINavigationController(rootViewController: qrcodeReaderController)
            present(navigationController, animated: true)
        }
        else {
            // TODO: Not Found View
        }
    }
}
