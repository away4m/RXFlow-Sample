//
//  DataSource.swift
//  Stocks
//
//  Created by ALI KIRAN on 11.04.20.
//  Copyright © 2020 ALI KIRAN. All rights reserved.
//

import Foundation
import NeedleFoundation



class InteractorDIComponent: Component<EmptyDependency>, LiveStockInteractorDependency {
    var liveStockInteractor: LiveStockInteractor {
        return shared { TradeRepublicStockInteractor() }
    }
}
