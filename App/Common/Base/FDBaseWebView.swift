//
//  flexdayWebView.swift
//  flexday
//
//  Created by inchan on 14/04/2021..
//  Copyright © 2021 flexday korea. All rights reserved.
//

import Foundation
import UIKit
import WebKit
import RxSwift
import RxCocoa

extension WKWebView {
    func printUrl(tag: String) {
        if let url = url?.absoluteString {
            Log("[\(tag)]: \(url)")
        }
    }
}

struct ScriptMessage {
    weak var handler: WKScriptMessageHandler?
    var name: String
}

class FDBaseWebView: WKWebView, FinalizePrinter {
    
    static let commonProcessPool = WKProcessPool()
    static var commonConfig: WKWebViewConfiguration {
        let config = WKWebViewConfiguration()
        config.processPool = FDBaseWebView.commonProcessPool
        config.preferences = WKPreferences()

        return config
    }
    
    init(frame: CGRect, configuration: WKWebViewConfiguration? = nil, scriptMessage: ScriptMessage? = nil) {
        let config = configuration ?? FDBaseWebView.commonConfig
        config.userContentController = {
            let userContentController = WKUserContentController()
            if let scriptMessage = scriptMessage, let handler = scriptMessage.handler {
                userContentController.add(handler, name: scriptMessage.name)
            }
            return userContentController
        }()
        
        super.init(frame: frame, configuration: config)
        self.allowsLinkPreview = true
        self.allowsBackForwardNavigationGestures = true
        self.backgroundColor = .systemBackground

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var isLoaded: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    var isLoadFailed: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    
    var isDebug: Bool = true
    var isRunning: Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    deinit {
        printFinalize()
    }
    
    private var defaultUserAgent: String?
    
    func defaultUserAgent(completion: @escaping (String) -> Void) {
        if let defaultUserAgent = defaultUserAgent {
            completion(defaultUserAgent)
        }
        else {
            evaluateJavaScript("navigator.userAgent", completionHandler: { [weak self] (userAgent, error) in
                guard let strongSelf = self else { completion(""); return }
                guard let userAgent = userAgent as? String else { completion(""); return }
                strongSelf.defaultUserAgent = userAgent
                completion(userAgent)
            })
        }
    }

}

extension FDBaseWebView {
    
    enum RequestError: Error {
        case requestUrlStringError
        case requestUrlError
    }
    
    var loadUrl: String? {
        get {
            return url?.absoluteString
        }
        set {
            do { try load(newValue) }
            catch { Log("error: \(error)") }
        }
    }

    func load(_ url: String?) throws {
        guard let urlString = url else { throw RequestError.requestUrlStringError }
        do { try load(URL(string: urlString)) }
        catch { throw error }
    }
    
    func load(_ url: URL?) throws {
        guard let url = url else { throw RequestError.requestUrlError }
        let request = URLRequest(url: url)
        load(request)
    }
}

extension FDBaseWebView {
    
    func runDebugObserve() {
        guard isRunning == false else { return }
        isRunning = true
        
        rx.didStartLoad
          .bind (onNext: { [weak self] (navigation) in
                guard let strongSelf = self else { return }
                if strongSelf.isDebug, let url = strongSelf.url?.absoluteString {
                    Log("didStartLoad: \(url)")
                }
            })
            .disposed(by: rx.disposeBag)

        rx.didCommit
            .subscribe ({ [weak self] (navigation) in
                guard let strongSelf = self else { return }
                if strongSelf.isDebug, let url = strongSelf.url?.absoluteString  {
                    Log("didCommit: \(url)")
                }
            })
            .disposed(by: rx.disposeBag)
        
        rx.didFinishLoad
            .subscribe ({ [weak self] (navigation) in
                guard let strongSelf = self else { return }
                if strongSelf.isDebug, let url = strongSelf.url?.absoluteString  {
                    Log("didFinishLoad: \(url)")
                }
                if strongSelf.isLoaded.value == false {
                    strongSelf.isLoaded.accept(true)
                }
                strongSelf.isLoadFailed.accept(false)
            })
            .disposed(by: rx.disposeBag)
        
        rx.didFailLoad
            .subscribe ({ [weak self] (r) in
                guard let strongSelf = self else { return }
                if strongSelf.isDebug, let url = strongSelf.url?.absoluteString  {
                    if let error = r.element?.1 {
                        Log("didFailLoad: \(error), \(url)")
                    }
                }
                if strongSelf.isLoaded.value == false {
                    strongSelf.isLoaded.accept(true)
                }
                strongSelf.isLoadFailed.accept(true)
            })
            .disposed(by: rx.disposeBag)
    }
}
