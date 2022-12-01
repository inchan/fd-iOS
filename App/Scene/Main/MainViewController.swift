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
        
        setupWebBridge()

        self.webView.defaultUserAgent { defalutUserAgent in
            self.webView.customUserAgent = defalutUserAgent + " " + Constant.Identifier.UserAgnet
            self.loadURL()
        }

    }
    
    func loadURL() {
        // defined home url
        homeUrl = URLs.Web.store.url
        //self.homeUrl = URLs.Web.calculate.url
        func loadFromSampleHtml() {
            self.homeUrl = URLs.Web.calculate.url
            if let url = Bundle.main.url(forResource: "sampleBridge", withExtension: "html") {
                if let data = try? Data(contentsOf: url), let html = String(data: data, encoding: .utf8) {
                    self.webView.loadHTMLString(html, baseURL: nil)
                }
            }
        }
    }
    
    
    // MARK: - Setup

    func setupWebBridge() {
        // defined web bridge callback handler
        self.callBackHandler = { [weak self] (message) in
            guard let strongSelf = self else { return }
            guard let body = message.body as? String else { return }

            if body == "openQRCodeReader" {
                strongSelf.presentQRCodeReaderController()
            }
            else if body == "closeQRCodeReader" {
                strongSelf.dismissQRCodeReaderController()
            }
            else if let jsonData = body.data(using: .utf8) {
                guard let jsonObj = try? JSONDecoder().decode([String: String].self, from: jsonData) else { return }
                LoginManager.StoreDomain.value = jsonObj["storeDomain"] ?? ""
                LoginManager.AccessToken.value = jsonObj["accessToken"] ?? ""
            }
        }
    }
        
   
    // MARK: - send Javascript

    func sendJavaScriptToWeb(_ javascript: String) {
        webView.evaluateJavaScript(javascript)
    }

    
    // MARK: - QRCodeReaderViewController
    
    func presentQRCodeReaderController() {
        if let qrcodeReaderController = QRCodeReaderViewController.loadFromStoryboard() {
            qrcodeReaderController.didReceived = ({ [weak self] coupon in
                guard let strongSelf = self else { return }
                if let jsonStrong = coupon.asJsonString {
                    strongSelf.sendJavaScriptToWeb("window.event('\(jsonStrong)');")
                }
            })
            let navigationController = UINavigationController(rootViewController: qrcodeReaderController)
            present(navigationController, animated: true)
        }
        else {
            // TODO: Not Found View
        }
    }
    
    func dismissQRCodeReaderController() {
        if let presentedViewController = presentedViewController, let nc = presentedViewController as? UINavigationController {
            if let vc = nc.viewControllers.first, vc is QRCodeReaderViewController {
                vc.dismiss(animated: true)
            }
        }
    }
    
    
}
