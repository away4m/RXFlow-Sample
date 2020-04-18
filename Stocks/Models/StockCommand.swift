//
//  StockCommand.swift
//  Stocks
//
//  Created by ALI KIRAN on 14.04.20.
//  Copyright © 2020 ALI KIRAN. All rights reserved.
//

import Foundation

protocol StockCommand: Encodable {
    func encode() throws -> Data
}

extension StockCommand {
    func encode() throws -> Data {
        let jsonEncoder = JSONEncoder()
        return try jsonEncoder.encode(self)
    }
}

struct StockSubscribeCommand: StockCommand {
    let subscribe: String
}

struct StockUnsubscribeCommand: StockCommand {
    let unsubscribe: String
}
