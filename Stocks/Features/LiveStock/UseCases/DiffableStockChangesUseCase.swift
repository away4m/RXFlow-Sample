//
//  SubscribingTopStocksUseCase.swift
//  Stocks
//
//  Created by ALI KIRAN on 11.04.20.
//  Copyright © 2020 ALI KIRAN. All rights reserved.
//

import Foundation
import RxRelay
import RxSwift
import W

class DiffableStockChangesUseCase {
    // MARK: Properties
    
    let changesRelay = PublishSubject<DataSourceChange<StockData>>()
    var subscriptions = [StockData]()
    
    private let stockInteractor: StockChangesInteractor
    private var subscriptionIndexMap = [String: Int]()
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
    func pause(isin: String) {
        whenReady { [unowned self] in
            self.stockInteractor.send(command: StockUnsubscribeCommand(unsubscribe: isin))
        }
    }
    
    func resume(isin: String) {
        whenReady { [unowned self] in
            self.stockInteractor.send(command: StockSubscribeCommand(subscribe: isin))
        }
    }
    
    func subscribe(isin: String, name: String) {
        insertStock(isin: isin, name: name)
    }
}

// MARK: Private

private extension DiffableStockChangesUseCase {
    // Stock added into subsription list and index map register array position. After changes arrive we will use this index map to apply diff update
    
    func insertStock(isin: String, name: String) {
        let stock = StockData(name: name, isin: isin, price: 0, index: subscriptions.count)
        
        let index = stock.index
        subscriptions.append(stock)
        subscriptionIndexMap[stock.isin] = index
        changesRelay.onNext(DataSourceChange.insert(index: index, items: subscriptions))
    }
    
    //  Update subscribed stock price
    func updateStock(_ index: Int, price: Decimal) {
        subscriptions[index].price = price
        
        changesRelay.on(.next(
            DataSourceChange.update(index: index, items: subscriptions)
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
            .event
            .bind { [unowned self] event in
                switch event {
                case let .message(json):
                    self.updateSubscribeStockData(from: json)
                    
                case let .failure(error):
                    print(error.message)
                }
            }
            .disposed(by: disposebag)
    }
    
    func updateSubscribeStockData(from json: J) {
        guard let isin = json["isin"]?.string, let index = subscriptionIndexMap[isin] else {
            return
        }
        
        updateStock(index, price: Decimal(json["price"].float ?? 0.0))
    }
}
