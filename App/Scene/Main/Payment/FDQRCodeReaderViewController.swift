//
//  QRCodeReaderViewController.swift
//  App
//
//  Created by inchan on 2022/11/22.
//  Copyright © 2022 Enliple. All rights reserved.
//

import UIKit




class FDQRCodeReaderViewController: FDBaseViewController {
    
    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var readerView: FDQRCodeReaderView!
    
    @IBOutlet weak var inputContentsView: UIView!
    @IBOutlet weak var inputTextField: UITextField!
    @IBOutlet weak var inputButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.readerView.delegate = self
        
        NotificationCenter.default.addObserver(forName: FDQRCodeReaderViewController.keyboardWillShowNotification, object: nil, queue: .main) { noti in
            
        }
        NotificationCenter.default.addObserver(forName: FDQRCodeReaderViewController.keyboardWillHideNotification, object: nil, queue: .main) { noti in
            
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if !self.readerView.isRunning {
            self.readerView.stop(isButtonTap: false)
        }
    }
    
    @IBAction func onBack(_ sender: UIButton) {
        
    }

}

extension FDQRCodeReaderViewController: FDQRCodeReaderViewDelegate {
    func readerComplete(status: FDQRCodeReaderStatus) {

        var title = ""
        var message = ""
        switch status {
        case let .success(code):
            guard let code = code else {
                title = "에러"
                message = "QR코드 or 바코드를 인식하지 못했습니다.\n다시 시도해주세요."
                break
            }

            title = "알림"
            message = "인식성공\n\(code)"
        case .fail:
            title = "에러"
            message = "QR코드 or 바코드를 인식하지 못했습니다.\n다시 시도해주세요."
        case let .stop(isButtonTap):
            if isButtonTap {
                title = "알림"
                message = "바코드 읽기를 멈추었습니다."
            } else {
                return
            }
        }

        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
}
