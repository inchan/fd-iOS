//
//  flexdayProgressView.swift
//  flexday
//
//  Created by inchan on 14/04/2021.
//  Copyright © 2021 flexday korea. All rights reserved.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift
import WebKit
import NSObject_Rx

extension UIProgressView: HasDisposeBag {
    
    func bind(to webView: WKWebView?, by bag: DisposeBag) {
        webView?.rx.observe(Double.self, #keyPath(WKWebView.estimatedProgress))
            .subscribe(onNext: { [weak self] (new) in
                guard let strongSelf = self else { return }
                let new: Float = Float(new?.cgFloat ?? 0.0)
                let isHidden = 0.0 == new || new == 1.0
                strongSelf.isHidden = isHidden
                strongSelf.progress = new
            })
            .disposed(by: bag)
    }

    func show() {
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
            self.alpha = 1
        }, completion: nil)
    }
    
    func hide() {
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
            self.alpha = 0
        }, completion: nil)
    }
    
    func attatch(to targetView: UIView? ) {
        guard let targetView = targetView else { return }
        if targetView.subviews.contains(self) {
            removeFromSuperview()
        }
        targetView.addSubview(self)
        leadingAnchor.constraint(equalTo: targetView.leadingAnchor).isActive = true
        trailingAnchor.constraint(equalTo: targetView.trailingAnchor).isActive = true
        topAnchor.constraint(equalTo: targetView.safeAreaLayoutGuide.topAnchor).isActive = true
        heightAnchor.constraint(equalToConstant: 2).isActive = true
    }
}
