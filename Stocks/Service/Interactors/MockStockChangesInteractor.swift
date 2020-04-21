//
//  StaticLiveStockInteractor.swift
//  Stocks
//
//  Created by ALI KIRAN on 11.04.20.
//  Copyright © 2020 ALI KIRAN. All rights reserved.
//

import Foundation
import ObjectWrapper
import RxSwift

class MockStockChangesInteractor: StockChangesInteractor {
    var error: Observable<StockError> {
        .never()
    }
    
    func subscribe(identity stock: StockIdentity) -> Bool {
        return true
    }
    
    func unsubscribe(identity stock: StockIdentity) -> Bool {
        return true
    }
    
    var isConnected: Bool {
        true
    }
    
    var event: Observable<StockData> {
        let identity = StockIdentity(name: "ALI Corp", symbol: "ALI", isin: "11111")
        return .just(StockData(identity: identity))
    }
    
    var status: Observable<Bool> {
        Observable.just(true)
    }
    
    func connect() {}
    
    func disconnect() {}
    
    func send(command: StockCommand) -> Bool {
        return true
    }
}
