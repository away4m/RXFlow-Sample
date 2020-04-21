//
//  SubscribingTopStocksUseCase.swift
//  Stocks
//
//  Created by ALI KIRAN on 11.04.20.
//  Copyright © 2020 ALI KIRAN. All rights reserved.
//

import Foundation
import ObjectWrapper
import RxRelay
import RxSwift

class DiffableStockChangesUseCase {
    // MARK: Properties
    
    let changesRelay = PublishSubject<DataSourceChange<StockData>>()
    var subscriptions = [StockData]()
    
    private let stockInteractor: StockChangesInteractor
    private let disposebag = DisposeBag()
    
    // MARK: Life Cycle
    
    init(stockInteractor: StockChangesInteractor) {
        self.stockInteractor = stockInteractor
        monitor()
    }
    
    deinit {
        print()
    }
}

// MARK: Public

extension DiffableStockChangesUseCase {
    func pause(_ identity: StockIdentity) {
        whenReady { [unowned self] in
            self.stockInteractor.unsubscribe(identity: identity)
        }
    }
    
    func resume(_ identity: StockIdentity) {
        whenReady { [unowned self] in
            self.stockInteractor.subscribe(identity: identity)
        }
    }
    
    func subscribe(_ identity: StockIdentity) {
        var mutableIdent = identity
        mutableIdent.index = subscriptions.count
        
        let data = StockData(identity: mutableIdent)
        subscriptions.append(data)
        changesRelay.onNext(DataSourceChange.insert(index: data.identity.index, items: subscriptions))
    }
}

// MARK: Private

private extension DiffableStockChangesUseCase {
    // Stock added into subsription list and index map register array position. After changes arrive we will use this index map to apply diff update
    
    //  Update subscribed stock price
    func updateSubscriptions(_ data: StockData) {
        subscriptions[data.identity.index] = data
        
        changesRelay.on(.next(
            DataSourceChange.update(index: data.identity.index, items: subscriptions)
        ))
    }
    
    // Utility function ensure websocket readiness
    func whenReady(callback: @escaping () -> Void) {
        if stockInteractor.isConnected {
            callback()
        } else {
            stockInteractor.status
                .filter({ $0 == true })
                .map({ _ in () })
                .take(1)
                .bind { () in
                    callback()
                }
                .disposed(by: disposebag)
        }
    }
    
    func monitor() {
        stockInteractor.connect()
        
        stockInteractor
            .error
            .bind { error in
                print(error)
            }
            .disposed(by: disposebag)
        
        stockInteractor
            .event
            .bind { [unowned self] data in
                self.updateSubscriptions(data)
            }
            .disposed(by: disposebag)
    }
}
