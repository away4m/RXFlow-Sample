//
//  StockEvent.swift
//  Stocks
//
//  Created by ALI KIRAN on 15.04.20.
//  Copyright © 2020 ALI KIRAN. All rights reserved.
//

import Foundation
import W
enum SocketMessage {
    case message(J)
    case failure(StockError)
}
