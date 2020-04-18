//
//  StaticLiveStockInteractor.swift
//  Stocks
//
//  Created by ALI KIRAN on 11.04.20.
//  Copyright © 2020 ALI KIRAN. All rights reserved.
//

import Foundation
import W
import RxSwift

class MockStockChangesInteractor: StockChangesInteractor {
    var isConnected: Bool {
        true
    }
    
    var event: Observable<SocketMessage> {
        return Observable<SocketMessage>.just(.message(["isin": 1, "price": 1.0]))
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
