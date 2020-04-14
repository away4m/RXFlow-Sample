//
//  StaticLiveStockInteractor.swift
//  Stocks
//
//  Created by ALI KIRAN on 11.04.20.
//  Copyright © 2020 ALI KIRAN. All rights reserved.
//

import Foundation
import RxSwift
class MockStockChangesInteractor: StockChangesInteractor {
    var isConnected: Bool {
        true
    }
    
    var event: Observable<StockEvent> {
        Observable<StockEvent>.just(.message(.init(isin: "1", price: 1.0)))
    }
    
    var status: Observable<Bool> {
        Observable.just(true)
    }
    
    func connect() {}
    
    func disconnect() {}
    
    func send(command: StockCommand) {}
}
