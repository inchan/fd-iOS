//
//  flexdayViewController.swift
//  flexday
//
//  Created by inchan on 14/04/2021..
//  Copyright © 2021 flexday korea. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa


protocol FDBackaButtonBuilder {
    func onBack(animated flag: Bool, completion: (() -> Void)?)
    func buildBackButton()
    func buildCloseButton(title: String)
}

extension FDBackaButtonBuilder where Self: UIViewController {
    
    func onBack(animated flag: Bool = true, completion: (() -> Void)? = nil) {
        if let navigationController = navigationController, 1 < navigationController.viewControllers.count {
            navigationController.popViewController(animated: flag, completion)
        }
        else {
            dismiss(animated: flag, completion: completion)
        }
    }
    
    func buildBackButton() {
        let btn = UIButton(type: .custom)
        let image = UIImage(named: "icon_back")!
        btn.setImage(image, for: .normal)
        btn.frame = CGRect(origin: .zero, size: CGSize(width: 30, height: 30))
        btn.contentHorizontalAlignment = .leading
        btn.rx.tap
            .subscribe ({ [weak self] (_) in
                guard let strongSelf = self else { return }
                strongSelf.onBack()
            })
            .disposed(by: rx.disposeBag)
        navigationItem.leftBarButtonItems = [UIBarButtonItem(customView: btn)]
    }

    func buildCloseButton(title: String = "닫기") {
        let btn = UIButton(type: .custom)
        btn.setTitle(title, for: .normal)
        btn.rx.controlEvent(.touchUpInside)
            .subscribe({ [weak self] _ in
                guard let strongSelf = self else { return }
                strongSelf.onBack()
            })
            .disposed(by: rx.disposeBag)
        btn.setTitleColor(UIColor.darkGray, for: .normal)
        let barBtnItem = UIBarButtonItem(customView: btn)
        navigationItem.rightBarButtonItem = barBtnItem
    }

}

class FDBaseViewController: UIViewController, UILoadable, FinalizePrinter, FDBackaButtonBuilder {    
    
    var isFristAppeared = true
    
    deinit {
        printFinalize()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if (isFristAppeared == true) {
            isFristAppeared = false
        }
    }
}
