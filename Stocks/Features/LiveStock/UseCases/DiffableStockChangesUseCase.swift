//
//  SubscribingTopStocksUseCase.swift
//  Stocks
//
//  Created by ALI KIRAN on 11.04.20.
//  Copyright © 2020 ALI KIRAN. All rights reserved.
//

import DiffableDataSources
import Foundation
import RxRelay
import RxSwift

enum DiffableStockChangesUseCaseSection: String {
    case main
}

typealias SnapShot = DiffableDataSourceSnapshot<DiffableStockChangesUseCaseSection, StockData>
class DiffableStockChangesUseCase {
    // MARK: Properties
    
    lazy var diffRelay = BehaviorRelay<SnapShot>(value: SnapShot())
    
    private let stockInteractor: StockChangesInteractor
    private var isinMap = [String: Int]()
    private let disposebag = DisposeBag()
    
    // MARK: Life Cycle
    
    init(stockInteractor: StockChangesInteractor) {
        self.stockInteractor = stockInteractor
        
        monitor()
    }
}

// MARK: Public

extension DiffableStockChangesUseCase {
    func subscribe(isin: String) {
        whenReady { [unowned self] in
            self.stockInteractor.send(command: StockSubscribeCommand(subscribe: isin))
        }
    }
}

// MARK: Private

private extension DiffableStockChangesUseCase {
    func whenReady(callback: @escaping () -> Void) {
        if stockInteractor.isConnected {
            callback()
        } else {
            stockInteractor.status
                .filter({ $0 == true })
                .map({ _ in () })
                .take(1)
                .bind { () in
                    callback()
                }
                .disposed(by: disposebag)
        }
    }
    
    func monitor() {
        stockInteractor.connect()
        
        stockInteractor.event
            .bind { event in
                switch event {
                case .message:
                    break
                    
                case .failure:
                    break
                }
            }
            .disposed(by: disposebag)
    }
}
