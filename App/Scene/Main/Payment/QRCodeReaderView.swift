//
//  FDQRReaderView.swift
//  App
//
//  Created by inchan on 2022/11/23.
//  Copyright © 2022 Enliple. All rights reserved.
//

import UIKit
import AVFoundation

enum FDQRCodeReaderStatus {
    case success(_ code: String?)
    case fail
    case stop(_ isButtonTap: Bool)
}

protocol QRCodeReaderViewDelegate: AnyObject {
    func readerComplete(status: FDQRCodeReaderStatus)
}


class QRCodeReaderView: UIView {
    weak var delegate: QRCodeReaderViewDelegate?

    // 카메라 화면을 보여줄 Layer
    var previewLayer: AVCaptureVideoPreviewLayer?
    var captureSession: AVCaptureSession?

    private var cornerLength: CGFloat = 20
    private var cornerLineWidth: CGFloat = 6
    private var rectOfInterest: CGRect {
        CGRect(x: (bounds.width / 2) - (200 / 2),
               y: (bounds.height / 2) - (200 / 2),
                          width: 200, height: 200)
    }
    
    var isRunning: Bool {
        guard let captureSession = self.captureSession else {
            return false
        }
        return captureSession.isRunning
    }
    
    // 촬영 시 어떤 데이터를 검사할건지? - QRCode
    let metadataObjectTypes: [AVMetadataObject.ObjectType] = [.qr]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initialSetupView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initialSetupView()
    }
    
    /// AVCaptureSession을 실행하는 화면을 구성 후 실행합니다.
    private func initialSetupView() {
        self.clipsToBounds = true
        self.captureSession = AVCaptureSession()
        
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else {return}
        
        let videoInput: AVCaptureInput
        
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch let error {
            print(error.localizedDescription)
            return
        }
        
        guard let captureSession = self.captureSession else {
            self.fail()
            return
        }
        
        if captureSession.canAddInput(videoInput) {
            captureSession.addInput(videoInput)
        } else {
            self.fail()
            return
        }
                
        let metadataOutput = AVCaptureMetadataOutput()
                
        if captureSession.canAddOutput(metadataOutput) {
            captureSession.addOutput(metadataOutput)
                    
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = self.metadataObjectTypes
            
        } else {
            self.fail()
            return
        }
                
        self.setPreviewLayer()
        //self.setFocusZoneCornerLayer()
        /*
         // QRCode 인식 범위 설정하기
         metadataOutput.rectOfInterest 는 AVCaptureSession에서 CGRect 크기만큼 인식 구역으로 지정합니다.
         !! 단 해당 값은 먼저 AVCaptureSession를 running 상태로 만든 후 지정해주어야 정상적으로 작동합니다 !!
         */
        self.start()
        metadataOutput.rectOfInterest = previewLayer!.metadataOutputRectConverted(fromLayerRect: rectOfInterest)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.previewLayer?.frame = self.layer.bounds

    }
    
    
    
    /// 중앙에 사각형의 Focus Zone Layer을 설정합니다.
    private func setPreviewLayer() {
        let readingRect = rectOfInterest
        
        guard let captureSession = self.captureSession else {
            return
        }
        
        /*
         AVCaptureVideoPreviewLayer를 구성.
         */
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        previewLayer.frame = self.layer.bounds

        // MARK: - Scan Focus Mask
        /*
         Scan 할 사각형(Focus Zone)을 구성하고 해당 자리만 dimmed 처리를 하지 않음.
         */
        /*
         CAShapeLayer에서 어떠한 모양(다각형, 폴리곤 등의 도형)을 그리고자 할 때 CGPath를 사용한다.
         즉 previewLayer에다가 ShapeLayer를 그리는데
         ShapeLayer의 모양이 [1. bounds 크기의 사각형, 2. readingRect 크기의 사각형]
         두개가 그려져 있는 것이다.
         */
        let path = CGMutablePath()
        path.addRect(bounds)
        path.addRect(readingRect)

        /*
         그럼 Path(경로? 모양?)은 그렸으니 Layer의 특징을 정하고 추가해보자.
         먼저 CAShapeLayer의 path를 위에 지정한 path로 설정해주고,
         QRReader에서 백그라운드 색이 dimmed 처리가 되어야 하므로 layer의 투명도를 0.6 정도로 설정한다.
         단 여기서 QRCode를 읽을 부분은 dimmed 처리가 되어 있으면 안 된다.
         이럴때 fillRule에서 evenOdd를 지정해주는데
         Path(도형)이 겹치는 부분(여기서는 readingRect, QRCode 읽는 부분)은 fillColor의 영향을 받지 않는다
         */
//        let maskLayer = CAShapeLayer()
//        maskLayer.path = path
//        maskLayer.fillColor = UIColor.gray.cgColor
//        maskLayer.fillRule = .evenOdd
//
//        previewLayer.addSublayer(maskLayer)
        
        
        self.layer.addSublayer(previewLayer)
        self.previewLayer = previewLayer
    }
}

// MARK: - ReaderView Running Method
extension QRCodeReaderView {
    
    func start() {
        print("# AVCaptureSession Start Running")
        self.captureSession?.startRunning()
    }
    
    func stop(isButtonTap: Bool) {
        self.captureSession?.stopRunning()
        self.delegate?.readerComplete(status: .stop(isButtonTap))
    }
    
    func fail() {
        self.delegate?.readerComplete(status: .fail)
        self.captureSession = nil
    }
    
    func found(code: String) {
        self.delegate?.readerComplete(status: .success(code))
    }
}

// MARK: - AVCapture Output
extension QRCodeReaderView: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        
        print("# GET metadataOutput")
//        stop(isButtonTap: false)
        
        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject,
                let stringValue = readableObject.stringValue else {
                return
            }

            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
//            AudioServicesPlayAlertSound(SystemSoundID(1407)) // Appstore purchase sound
            found(code: stringValue)
            print("## Found metadata Value\n + \(stringValue)\n")
            stop(isButtonTap: true)
        }
    }
}

internal extension CGPoint {

    // MARK: - CGPoint+offsetBy
    func offsetBy(dx: CGFloat, dy: CGFloat) -> CGPoint {
        var point = self
        point.x += dx
        point.y += dy
        return point
    }
}
