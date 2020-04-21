//
//  DynamicSocket.swift
//  Stocks
//
//  Created by ALI KIRAN on 21.04.20.
//  Copyright © 2020 ALI KIRAN. All rights reserved.
//

import Foundation
import ObjectWrapper
import RxRelay
import RxSwift
import Starscream

class DynamicSocket {
    var messageRelay = PublishRelay<Wrap>()
    var errorRelay = PublishRelay<StockError>()
    var connectionRelay = BehaviorRelay<Bool>(value: false)
    
    private let socket: WebSocket
    private let disposeBag = DisposeBag()
    
    init(url: String) {
        let request = URLRequest(url: URL(string: url)!)
        let pinner = FoundationSecurity(allowSelfSigned: true)
        socket = WebSocket(request: request, certPinner: pinner)
        socket.callbackQueue = DispatchQueue(label: url)
    }
}

extension DynamicSocket {
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
        print("send \(command)")
        do {
            let message = try command.encode()
            socket.write(data: message, completion: nil)
            
        } catch {
            errorRelay.accept(StockError(error: error))
            return false
        }
        
        return true
    }
}

// MARK: Websocket

extension DynamicSocket: WebSocketDelegate {
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
            guard let json = Wrap(usingJSON: string) else {
                errorRelay.accept(StockError(type: .invalidJSON))
                return
            }
            
            messageRelay.accept(json)
            
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
            errorRelay.accept(StockError(type: .disconnected))
            
        case let .error(error):
            connectionRelay.accept(false)
            errorRelay.accept(StockError(error: error))
        }
    }
}
