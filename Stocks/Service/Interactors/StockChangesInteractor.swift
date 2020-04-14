//
//  RepublicSocketInteracotr.swift
//  Stocks
//
//  Created by ALI KIRAN on 11.04.20.
//  Copyright © 2020 ALI KIRAN. All rights reserved.
//

import Foundation
import RxSwift

protocol StockChangesInteractor {
    var event: Observable<StockEvent> { get }
    var status: Observable<Bool> { get }
    var isConnected: Bool { get }
    
    func connect()
    func disconnect()
    func send(command: StockCommand)
}
