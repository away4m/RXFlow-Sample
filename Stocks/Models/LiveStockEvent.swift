//
//  LiveStockEvent.swift
//  Stocks
//
//  Created by ALI KIRAN on 14.04.20.
//  Copyright © 2020 ALI KIRAN. All rights reserved.
//

import Foundation

struct StockError: Equatable {
    enum `Type`: String {
        case unknown = "Unknown Error"
        case disconnected = "Connection Error"
    }
    
    let type: Type
    let message: String
    
    init(type: Type) {
        self.type = type
        message = type.rawValue
    }
    
    init(error: Error?) {
        message = error?.localizedDescription ?? "Undefined Error"
        type = .unknown
    }
}

enum StockEvent: Equatable {
    case message(StockData)
    case failure(StockError)
}
