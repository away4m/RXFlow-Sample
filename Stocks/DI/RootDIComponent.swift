//
//  RootDIComponent.swift
//  Stocks
//
//  Created by ALI KIRAN on 13.04.20.
//  Copyright © 2020 ALI KIRAN. All rights reserved.
//

import Foundation
import NeedleFoundation
import RxFlow

class RootDIComponent: BootstrapComponent {
    var interactorDI: InteractorDIComponent {
        InteractorDIComponent(parent: self)
    }
    
    var appFlowDI: AppFlowDI {
        AppFlowDI(parent: self)
    }
    
    var appFlow: Flow {
        AppFlow(configuration: appFlowDI)
    }
}
