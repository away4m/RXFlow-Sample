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
    var stockChangesInteractor: StockChangesInteractor { get }
    var stockListInteractor: StockListInteractor { get }
}

class LiveStockViewModel: Stepper {
    // MARK: Properties
    
    let steps = PublishRelay<Step>()
    let configuration: LiveStockConfiguration
    private let subscribingTopStocksUseCase: DiffableStockChangesUseCase
    private let disposeBag = DisposeBag()
    
    lazy var viewState: Observable<DataSourceChange<StockData>> = {
        subscribingTopStocksUseCase
            .changesRelay
            .observeOn(MainScheduler.instance)
            .asObservable()
        
    }()
    
    // MARK: Life Cycle
    
    init(configuration: LiveStockConfiguration) {
        self.configuration = configuration
        subscribingTopStocksUseCase = DiffableStockChangesUseCase(stockInteractor: configuration.stockChangesInteractor)
    }
}

// MARK: Public

extension LiveStockViewModel {
    func subscribe() {
        subscribeToStocks(list: configuration.stockListInteractor.getStockList())
    }
    
    func pauseSubscription(identity: StockIdentity) {
        subscribingTopStocksUseCase.pause(identity)
    }
    
    func resumeSubscription(identity: StockIdentity) {
        subscribingTopStocksUseCase.resume(identity)
    }
}

// MARK: Private

private extension LiveStockViewModel {
    func subscribeToStocks(list: [StockIdentity]) {
        for identity in list {
            subscribingTopStocksUseCase.subscribe(identity)
        }
    }
}
