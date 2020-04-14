//
//  AppFlow.swift
//  Stocks
//
//  Created by ALI KIRAN on 11.04.20.
//  Copyright © 2020 ALI KIRAN. All rights reserved.
//

import Foundation
import NeedleFoundation
import RxCocoa
import RxFlow
import RxSwift
import UIKit

protocol AppFlowConfiguration {
    var liveStockDataSource: LiveStockConfiguration { get }
}

class AppFlow: Flow {
    // MARK: Properties
    
    var root: Presentable {
        return rootViewController
    }
    
    private lazy var rootViewController: UINavigationController = {
        let viewController = UINavigationController()
        viewController.setNavigationBarHidden(true, animated: false)
        return viewController
    }()
    
    // Manual dependency injection
    
    let configuration: AppFlowConfiguration
    
    // MARK: Life Cycle
    
    init(configuration: AppFlowConfiguration) {
        self.configuration = configuration
    }
    
    // Resolves app navigation from steps (Route Handler)
    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? AppStep else { return .none }
        
        switch step {
        case .liveStocks:
            return navigationToLiveStockScreen()
        }
    }
}

extension AppFlow {
    // Presenting live stock feature. If feature includes more screen it's better to intorduce seperate flow.
    func navigationToLiveStockScreen() -> FlowContributors {
        let viewModel = LiveStockViewModel(configuration: configuration.liveStockDataSource)
        let viewController = LiveStockViewController(viewModel: viewModel)
        rootViewController.setViewControllers([viewController], animated: true)
        
        return .one(flowContributor: .contribute(
            withNextPresentable: viewController,
            withNextStepper: viewController.viewModel
        ))
    }
}

// App router. Possible in future, it will be used as delegate to handle routing calls.
class AppStepper: Stepper {
    let steps = PublishRelay<Step>()
    
    init() {}
    
    var initialStep: Step {
        return AppStep.liveStocks
    }
    
    /// callback used to emit steps once the FlowCoordinator is ready to listen to them to contribute to the Flow
    func readyToEmitSteps() {}
}
