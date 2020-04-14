//
//  StockData.swift
//  Stocks
//
//  Created by ALI KIRAN on 14.04.20.
//  Copyright © 2020 ALI KIRAN. All rights reserved.
//

import Foundation

struct StockData: Equatable, Hashable {
    let isin: String
    let price: Decimal
}
