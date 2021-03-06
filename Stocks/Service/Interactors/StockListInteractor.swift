//
//  CompanyWatchListInteractor.swift
//  Stocks
//
//  Created by ALI KIRAN on 18.04.20.
//  Copyright © 2020 ALI KIRAN. All rights reserved.
//

import Foundation
protocol StockListInteractor {
    func getStockList() -> [StockIdentity]
}

class BundleStockListInteractor: StockListInteractor {
    func getStockList() -> [StockIdentity] {
        if let path = Bundle.main.path(forResource: "isin", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                
                let decoder = JSONDecoder()
                return try decoder.decode([StockIdentity].self, from: data)
            } catch {
                print(error)
                return []
            }
        }
        
        return []
    }
}
