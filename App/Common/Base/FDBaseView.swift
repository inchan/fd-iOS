//
//  flexdayView.swift
//  flexday
//
//  Created by inchan on 14/04/2021..
//  Copyright © 2021 flexday korea. All rights reserved.
//

import Foundation
import UIKit

class FDBaseView: UIView, UILoadable, FinalizePrinter {
    
    deinit {
        printFinalize()
    }
}
