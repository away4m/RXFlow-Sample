//
//  TradeRepublicStockInteractor.swift
//  Stocks
//
//  Created by ALI KIRAN on 11.04.20.
//  Copyright © 2020 ALI KIRAN. All rights reserved.
//

import Foundation
import RxCocoa
import RxRelay
import RxSwift

class TradeRepublicSocketInteractor {
    // MARK: Properties
    
    private let disposeBag = DisposeBag()
    private lazy var socket = DynamicSocket(url: "ws://159.89.15.214:8080")
    private var identityMap: [String: StockIdentity] = [:]
    
    struct StockSubscribeCommand: StockCommand {
        let raw: [String: Any]
        
        init(identity: StockIdentity) {
            raw = ["subscribe": identity.isin]
        }
    }
    
    struct StockUnsubscribeCommand: StockCommand {
        let raw: [String: Any]
        
        init(identity: StockIdentity) {
            raw = ["unsubscribe": identity.isin]
        }
    }
    
    // MARK: Life Cycle
    
    init() {}
}

// MARK: Public

extension TradeRepublicSocketInteractor: StockChangesInteractor {
    var error: Observable<StockError> {
        socket.errorRelay.asObservable()
    }
    
    var event: Observable<StockData> {
        socket
            .messageRelay
            .compactMap { (wrapper) -> StockData? in
                guard let isin = wrapper["isin"]?.string, let identity = self.identityMap[isin] else {
                    return nil
                }
                
                return StockData(identity: identity, price: Decimal(wrapper["price"].float ?? 0.0))
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
        identityMap[identity.isin] = identity
        let command = StockSubscribeCommand(identity: identity)
        return socket.send(command: command)
    }
    
    func unsubscribe(identity: StockIdentity) -> Bool {
        let command = StockUnsubscribeCommand(identity: identity)
        return socket.send(command: command)
    }
}
