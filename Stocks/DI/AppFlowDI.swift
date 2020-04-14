//
//  AppFlowDI.swift
//  Stocks
//
//  Created by ALI KIRAN on 14.04.20.
//  Copyright © 2020 ALI KIRAN. All rights reserved.
//

import Foundation
import NeedleFoundation
import RxFlow

protocol AppFlowDependency: Dependency {
    var interactorDI: InteractorDIComponent { get }
}

class AppFlowDI: Component<AppFlowDependency>, AppFlowConfiguration {
    var liveStockDataSource: LiveStockConfiguration {
        return dependency.interactorDI
    }
    
    deinit {
        print()
    }
}
