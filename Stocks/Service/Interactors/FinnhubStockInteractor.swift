//
//  FinnhubStockInteractor.swift
//  Stocks
//
//  Created by ALI KIRAN on 21.04.20.
//  Copyright © 2020 ALI KIRAN. All rights reserved.
//

import Foundation
import RxRelay
import RxSwift

class FinnhubStockInteractor {
    // MARK: Properties
    
    private let disposeBag = DisposeBag()
    private lazy var socket = DynamicSocket(url: "wss://ws.finnhub.io?token=bqb7pevrh5r8t7qneqp0")
    private var identityMap: [String: StockIdentity] = [:]
    
    struct StockSubscribeCommand: StockCommand {
        let raw: [String: Any]
        
        init(identity: StockIdentity) {
            raw = ["type": "subscribe", "symbol": identity.symbol]
        }
    }
    
    struct StockUnsubscribeCommand: StockCommand {
        let raw: [String: Any]
        
        init(identity: StockIdentity) {
            raw = ["type": "unsubscribe", "symbol": identity.symbol]
        }
    }
    
    // MARK: Life Cycle
    
    init() {}
}

// MARK: Public

extension FinnhubStockInteractor: StockChangesInteractor {
    var error: Observable<StockError> {
        socket.errorRelay.asObservable()
    }
    
    var event: Observable<StockData> {
        socket
            .messageRelay
            .compactMap { (wrapper) -> StockData? in
                guard let symbol = wrapper["data"][0]["s"]?.string, let identity = self.identityMap[symbol] else {
                    return nil
                }
                
                return StockData(identity: identity, price: Decimal(wrapper["data"][0]["p"].float ?? 0.0))
            }
    }
    
    var status: Observable<Bool> {
        socket.connectionRelay.asObservable()
    }
    
    var isConnected: Bool {
        socket.connectionRelay.value
    }
    
    func disconnect() {
        socket.disconnect()
    }
    
    func connect() {
        socket.connect()
    }
    
    func subscribe(identity: StockIdentity) -> Bool {
        identityMap[identity.symbol] = identity
        let command = StockSubscribeCommand(identity: identity)
        return socket.send(command: command)
    }
    
    func unsubscribe(identity: StockIdentity) -> Bool {
        let command = StockUnsubscribeCommand(identity: identity)
        return socket.send(command: command)
    }
}
