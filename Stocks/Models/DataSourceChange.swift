//
//  DataSourceChange.swift
//  Stocks
//
//  Created by ALI KIRAN on 17.04.20.
//  Copyright © 2020 ALI KIRAN. All rights reserved.
//

import Foundation
enum DataSourceChange<T> {
    case insert(index: Int, items: [T])
    case update(index: Int, items: [T])
}
