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
    // MARK: Properties
    
    let viewAction = PublishSubject<ViewAction>()
    
    enum ViewAction {
        case willDisplay(identity: StockIdentity)
        case didEndDisplaying(identity: StockIdentity)
    }
    
    private let tableview: UITableView
    private var items: [StockData] = []
    private let disposeBag = DisposeBag()
    
    // MARK: Life Cycle
    
    init(tableview: UITableView) {
        self.tableview = tableview
        
        super.init()
        self.tableview.register(StockTableCell.self, forCellReuseIdentifier: String(describing: StockTableCell.self))
        self.tableview.dataSource = self
        self.tableview.delegate = self
    }
    
    deinit {
        print()
    }
}

// MARK: Public

extension StockTableUIBuilder {
    func subscribe(to stream: Observable<DataSourceChange<StockData>>) {
        stream
            .bind { [unowned self] change in
                switch change {
                case let .insert(index: index, items: items):
                    self.items = items
                    self.tableview.insertRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
                    
                case let .update(index: index, items: items):
                    self.items = items
                    let data = items[index]
                    guard let cell = self.tableview.cellForRow(at: IndexPath(row: index, section: 0)) as? StockTableCell else {
                        return
                    }
                    
                    cell.data = data
                }
            }
            .disposed(by: disposeBag)
    }
}

// MARK: Table Delegate

extension StockTableUIBuilder: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let stockCell = cell as? StockTableCell, let identity = stockCell.data?.identity else {
            return
        }
        
        //Resume stock subsription
        viewAction.onNext(.willDisplay(identity: identity))
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let stockCell = cell as? StockTableCell, let identity = stockCell.data?.identity else {
            return
        }
        
        //Pause stock subsription
        viewAction.onNext(.didEndDisplaying(identity: identity))
    }
}

// MARK: Table Datasource

extension StockTableUIBuilder: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = items[indexPath.row]
        let identifier = String(describing: StockTableCell.self)
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? StockTableCell else {
            assertionFailure()
            return UITableViewCell()
        }
        cell.data = data
        
        return cell
    }
}

// MARK: Private

extension StockTableUIBuilder {}
