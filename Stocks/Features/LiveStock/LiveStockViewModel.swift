//
//  LiveStockViewModel.swift
//  Stocks
//
//  Created by ALI KIRAN on 11.04.20.
//  Copyright © 2020 ALI KIRAN. All rights reserved.
//

import RxCocoa
import RxFlow

class LiveStockViewModel: Stepper {
    let steps = PublishRelay<Step>()
    let subscribingTopStocksUseCase: SubscribingTopStocksUseCase
    
    init(liveStock: LiveStockInteractor) {
        subscribingTopStocksUseCase = SubscribingTopStocksUseCase(liveStock: liveStock)
    }
}

