//
//  flexdayWebViewController.swift
//  flexday
//
//  Created by inchan on 14/04/2021..
//  Copyright © 2021 flexday korea. All rights reserved.
//

import Foundation
import UIKit
import WebKit

class FDBaseWebViewController: FDBaseViewController {
    
    lazy var progressView: UIProgressView = {
        let progressView = UIProgressView(progressViewStyle: .default)
        progressView.translatesAutoresizingMaskIntoConstraints = false
        return progressView
    }()
        
    lazy var webView: FDBaseWebView = {
        return FDBaseWebView(frame: CGRect.zero, scriptMessages: [ScriptMessage(handler:self, name: Constant.Key.WebAppBridgeHandlerKey)])
    }()
    
    var homeUrl: String? {
        didSet {
            try? webView.load(homeUrl)
        }
    }

    var callBackHandler: ((_ message: WKScriptMessage) -> Void)?

    var isEmbedWebView = false
    
    override func loadView() {
        super.loadView()
        if isEmbedWebView == true {
            configuWebView()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        configuWebView(attatch: nil) {
            self.webView.configuration.userContentController.add(self, name: Constant.Key.WebAppBridgeHandlerKey)
        }
    }

    func configuWebView(attatch target: UIView? = nil, completion: (() -> Void)? = nil) {
        if webView.superview != nil {
            webView.removeFromSuperview()
        }
        
        guard let view = target ?? self.view else { return }
        view.addSubview(webView)
        webView.fillToSuperview()
    }
    
    func configuProgressView(attatch target: UIView? = nil) {
        if let targetView = target {
            progressView.attatch(to: targetView)
        }
        else {
            progressView.attatch(to: webView)
        }
        progressView.bind(to: webView, by: rx.disposeBag)
    }
    
    
}

extension FDBaseWebViewController {
    
    func isItunesURL(_ urlString: String) -> Bool {
        func isMatch(_ urlString: String, _ pattern: String) -> Bool {
            let regex = try! NSRegularExpression(pattern: pattern, options: [])
            let result = regex.matches(in: urlString, options: [], range: NSRange(location: 0, length: urlString.count))
            return result.count > 0
        }
        return isMatch(urlString, "\\/\\/itunes\\.apple\\.com\\/")
    }
    
    func isPaymentURL(_ url: URL) -> Bool {
        guard let scheme = url.scheme else { return false}
        return PaymentCard.allCases.map({ $0.scheme }).compactMap({ $0 }).contains(scheme)
    }
    
    func isTelURL(_ url: URL) -> Bool {
        return url.absoluteString.hasPrefix("tel:")
    }
    
    enum PaymentCard: CaseIterable {
        case 비씨카드, 국민카드, 신한카드, 현대카드, 삼성카드, 롯데카드, 하나카드_외환, 농협카드, 하나카드, 씨티카드, 우리카드, 수협카드, 제주카드, KDB산업은행카드, 신협카드
        case 페이코, 스마일페이, 카카오페이
        case 우리페이, 국민앱카드
        
        var scheme: String? {
            switch self {
            case .비씨카드, .국민카드, .우리카드, .수협카드, .제주카드, .KDB산업은행카드, .신협카드:
                return "ispmobile" // ISP
            case .신한카드:
                return "shinhan-sr-ansimclick"
            case .현대카드:
                return "hdcardappcardansimclick"
            case .삼성카드:
                return "mpocket.online.ansimclick"
            case .롯데카드:
                return "lotteappcard"
            case .하나카드_외환, .하나카드:
                return "cloudpay"
            case .농협카드:
                return "nhallonepayansimclick"
            case .씨티카드:
                return "citimobileapp"

                // 간편결제
            case .페이코:
                return nil
            case .스마일페이:
                return nil
            case .카카오페이:
                return "kakaotalk"
                
                
            case .우리페이:
                return "wooripay"
            case .국민앱카드:
                return "kb-acp"
            }
        }
    }
}

extension FDBaseWebViewController: WKScriptMessageHandler {

    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        callBackHandler?(message)
    }

}
