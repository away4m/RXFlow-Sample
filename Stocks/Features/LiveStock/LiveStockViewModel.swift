//
//  LiveStockViewModel.swift
//  Stocks
//
//  Created by ALI KIRAN on 11.04.20.
//  Copyright © 2020 ALI KIRAN. All rights reserved.
//

import RxCocoa
import RxFlow
import RxSwift
protocol LiveStockConfiguration {
    var stockInteractor: StockChangesInteractor { get }
}

class LiveStockViewModel: Stepper {
    let steps = PublishRelay<Step>()
    private let subscribingTopStocksUseCase: DiffableStockChangesUseCase
    
    init(configuration: LiveStockConfiguration) {
        subscribingTopStocksUseCase = DiffableStockChangesUseCase(stockInteractor: configuration.stockInteractor)
    }
    
    func subscribe() -> Observable<SnapShot> {
        subscribingTopStocksUseCase.subscribe(isin: "US0378331005")
        subscribingTopStocksUseCase.subscribe(isin: "US0231351067")
        return subscribingTopStocksUseCase.diffRelay.asObservable()
    }
}
