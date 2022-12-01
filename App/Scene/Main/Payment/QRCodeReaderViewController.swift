//
//  QRCodeReaderViewController.swift
//  App
//
//  Created by inchan on 2022/11/22.
//  Copyright © 2022 Enliple. All rights reserved.
//

import UIKit
import Toaster

class QRCodeReaderViewController: FDBaseViewController {
    
    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var qrcodeReaderView: QRCodeReaderView!
    
    @IBOutlet weak var inputContentsView: UIView!
    @IBOutlet weak var inputBackgroundView: UIView!
    @IBOutlet weak var inputTextField: UITextField!
    @IBOutlet weak var inputButton: UIButton!
    
    @IBOutlet weak var stackViewBottom: NSLayoutConstraint!
    
    
    var didReceived: ((String) -> Void)? = nil

    
    // MARK - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        qrcodeReaderView.delegate = self
        setupUI()
        setupKeyboardNotification()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if !qrcodeReaderView.isRunning {
            qrcodeReaderView.start()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if !qrcodeReaderView.isRunning {
            qrcodeReaderView.stop(isButtonTap: false)
        }
    }
    
    // MARK - Setup

    func setupUI() {
        let backBarButtonItem = UIBarButtonItem(title: "취소", primaryAction: UIAction(handler: { [weak self] action in
            guard let strongSelf = self else { return }
            strongSelf.onBack()
        }))
        backBarButtonItem.tintColor = UIColor.label
        navigationItem.leftBarButtonItem = backBarButtonItem
        
        inputBackgroundView.borderColor = .separator
        inputBackgroundView.borderWidth = 1
    }
    
    func setupKeyboardNotification() {
        [UIResponder.keyboardWillShowNotification, UIResponder.keyboardWillHideNotification].forEach { notiName in
            NotificationCenter.default.addObserver(forName: notiName, object: nil, queue: .main) { noti in
                if let keyboardSize = (noti.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                    let willShow = noti.name == UIResponder.keyboardWillShowNotification
                    let newValue: CGFloat = willShow ? keyboardSize.height : 0
                    if self.stackViewBottom.constant != newValue {
                        self.stackViewBottom.constant = newValue
                        UIView.animate(withDuration: 0.3, animations: {
                            self.view.layoutIfNeeded()
                        })
                    }
                }
            }
        }
    }
    
    @IBAction func onBack(_ sender: UIButton?) {
        self.dismiss(animated: true)
    }
    
    @IBAction func onSendInputCode(_ sender: UIButton?) {
        func clear() {
            inputTextField.text = ""
            resignFirstResponder()
        }
        
        guard let text = inputTextField.text else {
            clear()
            return
        }
        requestQRcode(text)
        clear()
    }

    func requestQRcode(_ qrcode: String) {
        guard qrcode.count > 0 else { return }
        API.GetQRCode(qrcode: qrcode).request { [weak self] result in
            guard let strongSelf = self else { return }
            switch result {
            case .success(let coupon):
                strongSelf.sendToWeb(coupon: coupon)
                break
            case .failure(let error):
                if let data = error.errorResponse?.data, let stringValue = data.string(encoding: .utf8) {
                    strongSelf.sendToWeb(received: stringValue)
                }
                break
            }
        }
    }
    
    func sendToWeb(coupon: Coupon) {
        if let jsonString = coupon.asJsonString {
            didReceived?(jsonString)
        }
    }
    
    func sendToWeb(received: String) {
        didReceived?(received)
    }

}

extension QRCodeReaderViewController: QRCodeReaderViewDelegate {
    func readerComplete(status: FDQRCodeReaderStatus) {
        switch status {
        case let .success(code):
            guard let code = code else { break }
            self.requestQRcode(code)
            break
        default: break
            
        }
    }
}

extension QRCodeReaderViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
