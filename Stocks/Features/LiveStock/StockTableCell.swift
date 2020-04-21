//
//  StockTableCell.swift
//  Stocks
//
//  Created by ALI KIRAN on 18.04.20.
//  Copyright © 2020 ALI KIRAN. All rights reserved.
//

import UIKit

class StockTableCell: UITableViewCell {
    var data: StockData? {
        didSet {
            guard var data = data else {
                return
            }
            
            textLabel?.text = data.identity.name
            detailTextLabel?.text = data.formattedPrice
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: String(describing: StockTableCell.self))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
