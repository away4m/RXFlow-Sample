//
//  DataSource.swift
//  Stocks
//
//  Created by ALI KIRAN on 11.04.20.
//  Copyright © 2020 ALI KIRAN. All rights reserved.
//

import Foundation
import NeedleFoundation

// MARK: Interactors

class InteractorDIComponent: Component<EmptyDependency>, LiveStockConfiguration {
    var stockInteractor: StockChangesInteractor {
        return shared { TradeRepublicSocketInteractor() }
    }
}
