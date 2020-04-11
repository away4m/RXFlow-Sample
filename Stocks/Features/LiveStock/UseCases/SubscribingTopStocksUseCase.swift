//
//  SubscribingTopStocksUseCase.swift
//  Stocks
//
//  Created by ALI KIRAN on 11.04.20.
//  Copyright © 2020 ALI KIRAN. All rights reserved.
//

import Foundation
class SubscribingTopStocksUseCase {
    let liveStock: LiveStockInteractor
    
    init(liveStock: LiveStockInteractor) {
        self.liveStock = liveStock
    }
}
