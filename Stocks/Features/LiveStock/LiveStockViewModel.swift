//
//  LiveStockViewModel.swift
//  Stocks
//
//  Created by ALI KIRAN on 11.04.20.
//  Copyright © 2020 ALI KIRAN. All rights reserved.
//

import RxCocoa
import RxFlow

protocol LiveStockInteractorDependency {
    var liveStockInteractor: LiveStockInteractor { get }
}

class LiveStockViewModel: Stepper {
    let steps = PublishRelay<Step>()
    let subscribingTopStocksUseCase: SubscribingTopStocksUseCase
    
    init(liveStock: LiveStockInteractorDependency) {
        subscribingTopStocksUseCase = SubscribingTopStocksUseCase(liveStock: liveStock.liveStockInteractor)
    }
}
