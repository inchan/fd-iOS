//
//  IntroViewController.swift
//  flexday
//
//  Created by inchan on 14/04/2021.
//  Copyright © 2021 flexday korea. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class IntroViewController: FDBaseViewController {
    
    let viewModel = IntroViewModel()
    
    lazy var indicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.color = .gray
        return activityIndicator
    }()
        
    //MARK: - Lifecycle
    
    deinit {
        Log("deinit - \(self)")
    }
    
    override func loadView() {
        super.loadView()
        buildLuanchScreen()
        buildIndicatorView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindViewModel()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if isFristAppeared {
            if let networkConfiguration = AppPreferance.networkConfiguration.value {
                let configuration = NetworkConfiguration(rawValue: networkConfiguration) ?? .live
                self.viewModel.runProcess(with: configuration)
            }
            else {
                chooseServer { (configuration) in
                    self.viewModel.runProcess(with: configuration)
                }
            }
        }
        super.viewDidAppear(animated)
    }
        
    //MARK: - Configu
        
    func buildLuanchScreen() {
        if let launchScreen = UIStoryboard(name: "LaunchScreen", bundle: Bundle.main).instantiateInitialViewController()?.view {
            view.addSubview(launchScreen)
            launchScreen.fillToSuperview()
        }
        else {
            view.backgroundColor = UIColor.white
        }
    }
    
    func buildIndicatorView() {
        view.addSubview(indicator)
        indicator.anchorCenterSuperview()
    }

    func bindViewModel() {
        
        viewModel.isLoading
            .bind(to: self.indicator.rx.isAnimating)
            .disposed(by: rx.disposeBag)
        
        viewModel.state
            .subscribe { [weak self] (e) in
                guard let state = e.element else { return }
                guard let strongSelf = self else { return }
                switch state {
                case .finish:
                    strongSelf.moveToMain()
                    break;
                default: break
                }
            }
            .disposed(by: rx.disposeBag)
    }
    
    
    //MARK: Logic
    
    func chooseServer(completion: @escaping (NetworkConfiguration) -> Void) {
        
        if NetworkService.configuration == nil {
            let buttonTitles = NetworkConfiguration.allCases
                .map({ $0.rawValue })
                .compactMap({ $0 })

            showAlert(title: "DEBUG", message: "서버를 선택해 주세요.", buttonTitles: buttonTitles) { (index) in
                let title = buttonTitles[index]
                let configuration = NetworkConfiguration(rawValue: title) ?? .live
                completion(configuration)
            }
        }
        else {
            completion(.live)
        }
    }
    
    func moveToMain() {
        let sb = UIStoryboard(name: "Main", bundle: .main)
        if let vc = sb.instantiateInitialViewController() {
            UIApplication.shared.delegate?.window??.rootViewController = vc
        }
    }
}

