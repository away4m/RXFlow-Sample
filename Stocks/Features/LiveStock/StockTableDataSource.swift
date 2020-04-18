//
//  StockTableDataSource.swift
//  Stocks
//
//  Created by ALI KIRAN on 18.04.20.
//  Copyright © 2020 ALI KIRAN. All rights reserved.
//

import Foundation
import RxSwift

class StockTableUIBuilder: NSObject {
    private let tableview: UITableView
    private let items: [StockData]
    private let disposeBag = DisposeBag()
    
    init(tableview: UITableView, items: [StockData]) {
        self.tableview = tableview
        self.items = items
        
        super.init()
        
        self.tableview.dataSource = self
        self.tableview.delegate = self
    }
}

extension StockTableUIBuilder {
    func bind(to: Observable<(DataSourceChange<StockData>, [StockData])>) {}
}

extension StockTableUIBuilder: UITableViewDelegate {}

extension StockTableUIBuilder: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        UITableViewCell()
    }
}
