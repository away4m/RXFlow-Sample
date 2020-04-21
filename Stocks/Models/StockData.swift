//
//  StockData.swift
//  Stocks
//
//  Created by ALI KIRAN on 14.04.20.
//  Copyright © 2020 ALI KIRAN. All rights reserved.
//

import Foundation
import RxSwift

struct StockIdentity: Codable, Hashable, Equatable {
    let name: String
    let symbol: String
    let isin: String
    var index: Int = -1
    
    private enum CodingKeys: String, CodingKey {
        case name, symbol, isin
    }
}

struct StockData: Equatable, Hashable, Codable {
    var identity: StockIdentity
    var price: Decimal = 0.0
    let locale = NSLocale.current
    
    lazy var formattedPrice: String = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = locale
        return formatter.string(from: price as NSDecimalNumber) ?? ""
    }()
}

extension StockData: ObservableConvertibleType {
    func asObservable() -> Observable<StockData> {
        Observable.just(self)
    }
    
    typealias Element = StockData
}

func + (left: [StockData], right: StockData) -> [StockData] {
    return left + [right]
}
