//
//  AppFlow.swift
//  Stocks
//
//  Created by ALI KIRAN on 11.04.20.
//  Copyright © 2020 ALI KIRAN. All rights reserved.
//

import Foundation
import RxCocoa
import RxFlow
import RxSwift
import UIKit

class AppFlow: Flow {
    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? AppStep else { return .none }
        
        switch step {
        case .liveStocks:
            return navigationToLiveStockScreen()
        }
    }
    
    var root: Presentable {
        return rootViewController
    }
    
    private lazy var rootViewController: UINavigationController = {
        let viewController = UINavigationController()
        viewController.setNavigationBarHidden(true, animated: false)
        return viewController
    }()
}

extension AppFlow {
    func navigationToLiveStockScreen() -> FlowContributors {
        let viewController = LiveStockViewController(viewModel: LiveStockViewModel())
        rootViewController.setViewControllers([viewController], animated: true)
        
        return .one(flowContributor: .contribute(
            withNextPresentable: viewController,
            withNextStepper: viewController.viewModel
        ))
    }
}

class AppStepper: Stepper {
    let steps = PublishRelay<Step>()
    
    init() {}
    
    var initialStep: Step {
        return AppStep.liveStocks
    }
    
    /// callback used to emit steps once the FlowCoordinator is ready to listen to them to contribute to the Flow
    func readyToEmitSteps() {}
}
