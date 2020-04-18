//
//  StockData.swift
//  Stocks
//
//  Created by ALI KIRAN on 14.04.20.
//  Copyright © 2020 ALI KIRAN. All rights reserved.
//

import Foundation

struct StockData: Equatable, Hashable, Codable {
    let name: String
    let symbol: String
    let isin: String
    var price: Decimal = 0.0
    var index: Int = -1
    let locale = NSLocale.current
    
    public init(name: String, isin: String, price: Decimal, index: Int) {
        self.name = name
        symbol = ""
        self.isin = isin
        self.price = price
        self.index = index
    }
    
    private enum CodingKeys: CodingKey {
        case name
        case isin
        case symbol
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        isin = try container.decode(String.self, forKey: .isin)
        symbol = try container.decode(String.self, forKey: .symbol)
    }
    
    lazy var formattedPrice: String = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = locale
        return formatter.string(from: price as NSDecimalNumber) ?? ""
    }()
}

func + (left: [StockData], right: StockData) -> [StockData] {
    return left + [right]
}
