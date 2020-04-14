//
//  TradeRepublicStockInteractor.swift
//  Stocks
//
//  Created by ALI KIRAN on 11.04.20.
//  Copyright © 2020 ALI KIRAN. All rights reserved.
//

import Foundation
import Starscream

class TradeRepublicSocketInteractor: LiveStockInteractor {
    private let socket: WebSocket
    init() {
        let request = URLRequest(url: URL(string: "ws://159.89.15.214:8080")!)
        let pinner = FoundationSecurity(allowSelfSigned: true)
        socket = WebSocket(request: request, certPinner: pinner)
    }
    
    func disconnect() {
        socket.disconnect()
        socket.delegate = nil
    }
    
    func connect() {
        socket.connect()
        socket.delegate = self
    }
    
    func subscribe(isin: String) {}
}

extension TradeRepublicSocketInteractor: WebSocketDelegate {
    func didReceive(event: WebSocketEvent, client: WebSocket) {}
}
