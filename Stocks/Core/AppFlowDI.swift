//
//  AppFlowDI.swift
//  Stocks
//
//  Created by ALI KIRAN on 13.04.20.
//  Copyright © 2020 ALI KIRAN. All rights reserved.
//
import Foundation
import NeedleFoundation
import RxFlow

protocol AppFlowDependency: Dependency {
    var interactorDI: InteractorDIComponent { get }
}

class AppFlowDI: Component<AppFlowDependency>, AppFlowConfiguration {
    var liveStockDependecy: LiveStockInteractorDependency {
        return dependency.interactorDI
    }
    
    var liveStockViewModel: LiveStockViewModel {
        LiveStockViewModel(liveStock: liveStockDependecy)
    }
}
