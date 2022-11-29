//
//  QRCodeReaderViewController.swift
//  App
//
//  Created by inchan on 2022/11/22.
//  Copyright © 2022 Enliple. All rights reserved.
//

import UIKit




class QRCodeReaderViewController: FDBaseViewController {
    
    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var qrcodeReaderView: QRCodeReaderView!
    
    @IBOutlet weak var inputContentsView: UIView!
    @IBOutlet weak var inputBackgroundView: UIView!
    @IBOutlet weak var inputTextField: UITextField!
    @IBOutlet weak var inputButton: UIButton!
    
    @IBOutlet weak var stackViewBottom: NSLayoutConstraint!

    
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
        
        requestQRcode("642533508882")
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
        requestQRcode(inputTextField.text ?? "")
        inputTextField.text = ""
        resignFirstResponder()
    }

    func requestQRcode(_ qrcode: String) {
        guard qrcode.count > 0 else { return }
        API.ProcessQRCode(qrcode: qrcode).request { response in
            print("response: \(response)")
            
            //self.webView?.evaluateJavaScript("dispatchEvent('asdf');")
        }
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
