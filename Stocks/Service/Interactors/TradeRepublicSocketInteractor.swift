//
//  TradeRepublicStockInteractor.swift
//  Stocks
//
//  Created by ALI KIRAN on 11.04.20.
//  Copyright © 2020 ALI KIRAN. All rights reserved.
//

import Foundation
import RxRelay
import RxSwift
import Starscream

class TradeRepublicSocketInteractor {
    // MARK: Properties
    
    var event: Observable<StockEvent> {
        messageRelay.asObservable()
    }
    
    var status: Observable<Bool> {
        connectionRelay.asObservable()
    }
    
    private var messageRelay = PublishRelay<StockEvent>()
    private var connectionRelay = BehaviorRelay<Bool>(value: false)
    
    private let socket: WebSocket
    private let disposeBag = DisposeBag()
    
    // MARK: Life Cycle
    
    init() {
        let request = URLRequest(url: URL(string: "ws://159.89.15.214:8080")!)
        let pinner = FoundationSecurity(allowSelfSigned: true)
        socket = WebSocket(request: request, certPinner: pinner)
    }
}

// MARK: Public

extension TradeRepublicSocketInteractor: StockChangesInteractor {
    var isConnected: Bool {
        connectionRelay.value
    }
    
    func disconnect() {
        socket.disconnect()
        socket.delegate = nil
    }
    
    func connect() {
        socket.connect()
        socket.delegate = self
    }
    
    func send(command: StockCommand) {
        do {
            let message = try command.encode()
            socket.write(data: message, completion: nil)
            
        } catch {
            messageRelay.accept(.failure(StockError(error: error)))
        }
    }
}

// MARK: Websocket

extension TradeRepublicSocketInteractor: WebSocketDelegate {
    func didReceive(event: WebSocketEvent, client: WebSocket) {
        print(event)
        switch event {
        case let .connected(headers):
            connectionRelay.accept(true)
            print("websocket is connected: \(headers)")
            
        case let .disconnected(reason, code):
            print("websocket is disconnected: \(reason) with code: \(code)")
            connectionRelay.accept(false)
            
        case let .text(string):
            print("Received text: \(string)")
        case let .binary(data):
            print("Received data: \(data.count)")
            
        case .ping:
            break
        case .pong:
            break
        case .viabilityChanged:
            break
        case .reconnectSuggested:
            break
        case .cancelled:
            connectionRelay.accept(false)
            messageRelay.accept(.failure(StockError(type: .disconnected)))
            
        case let .error(error):
            connectionRelay.accept(false)
            messageRelay.accept(.failure(StockError(error: error)))
        }
    }
}
