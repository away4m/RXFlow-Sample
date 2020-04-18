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
import W

class TradeRepublicSocketInteractor {
    // MARK: Properties
    
    var event: Observable<SocketMessage> {
        messageRelay.asObservable()
    }
    
    var status: Observable<Bool> {
        connectionRelay.asObservable()
    }
    
    private var messageRelay = PublishRelay<SocketMessage>()
    private var connectionRelay = BehaviorRelay<Bool>(value: false)
    
    private let socket: WebSocket
    private let disposeBag = DisposeBag()
    
    // MARK: Life Cycle
    
    init() {
        let request = URLRequest(url: URL(string: "ws://159.89.15.214:8080")!)
        let pinner = FoundationSecurity(allowSelfSigned: true)
        socket = WebSocket(request: request, certPinner: pinner)
        socket.callbackQueue = DispatchQueue(label: "stocks.socket.queue")
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
    
    @discardableResult
    func send(command: StockCommand) -> Bool {
        do {
            let message = try command.encode()
            socket.write(data: message, completion: nil)
            
        } catch {
            messageRelay.accept(.failure(StockError(error: error)))
            return false
        }
        
        return true
    }
}

// MARK: Websocket

extension TradeRepublicSocketInteractor: WebSocketDelegate {
    func didReceive(event: WebSocketEvent, client: WebSocket) {
        switch event {
        case let .connected(headers):
            connectionRelay.accept(true)
            print("websocket is connected: \(headers)")
            
        case let .disconnected(reason, code):
            print("websocket is disconnected: \(reason) with code: \(code)")
            connectionRelay.accept(false)
            
        case let .text(string):
            guard let json = J(withJSON: string) else {
                messageRelay.accept(.failure(StockError(type: .invalidJSON)))
                return
            }
            
            messageRelay.accept(.message(json))
            
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
