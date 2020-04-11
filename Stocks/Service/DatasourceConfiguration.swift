//
//  DataSource.swift
//  Stocks
//
//  Created by ALI KIRAN on 11.04.20.
//  Copyright © 2020 ALI KIRAN. All rights reserved.
//

import Foundation

enum DatasourceConfigurationType {
    case real
    case stub
}

class DatasourceConfiguration {
    // MARK: Life Cycle
    
    private var type: DatasourceConfigurationType
    
    init(type: DatasourceConfigurationType) {
        self.type = type
    }
    
    lazy var liveStockInteractor: LiveStockInteractor = {
        switch type {
        case .real:
            return TradeRepublicStockInteractor()
            
        case .stub:
            return StaticLiveStockInteractor()
        }
    }()
}
