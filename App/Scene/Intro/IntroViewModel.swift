//
//  IntroViewModel.swift
//  flexday
//
//  Created by inchan on 14/04/2021.
//  Copyright © 2021 flexday korea. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import NSObject_Rx

class IntroViewModel: HasDisposeBag {

    enum State {
        case ready
        case checkVersion
        case needUpdate(_ isForce: Bool)
        case finish
    }
    
    let state = BehaviorRelay<State>(value: .ready)
    let isLoading = PublishRelay<Bool>()
    
    func runProcess(with configuration: ServerConfiguration = .live) {
        setServer(configuration)
        isLoading.accept(true)
        finish()
    }
                        
    func finish() {
        isLoading.accept(false)
        state.accept(.finish)
    }
}

extension IntroViewModel {

    /// DEBUG
    func setServer(_ configuration: ServerConfiguration) {
        AppPreferance.ServerConfiguration.value = configuration.rawValue
        NetworkService.server = configuration
    }

}
