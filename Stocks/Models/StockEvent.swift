//
//  StockEvent.swift
//  Stocks
//
//  Created by ALI KIRAN on 15.04.20.
//  Copyright © 2020 ALI KIRAN. All rights reserved.
//

import Foundation
enum SocketMessage {
    case message([String: Any])
    case failure(StockError)
}
