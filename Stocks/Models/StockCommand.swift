//
//  StockCommand.swift
//  Stocks
//
//  Created by ALI KIRAN on 14.04.20.
//  Copyright © 2020 ALI KIRAN. All rights reserved.
//

import Foundation

protocol StockCommand {
    var raw: [String: Any] { get }
    func encode() throws -> Data
}

extension StockCommand {
    func encode() throws -> Data {
        return try JSONSerialization.data(withJSONObject: raw, options: .prettyPrinted)
    }
}
