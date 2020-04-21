//
//  LiveStockViewController.swift
//  Stocks
//
//  Created by ALI KIRAN on 11.04.20.
//  Copyright © 2020 ALI KIRAN. All rights reserved.
//

import RxCocoa
import RxFlow
import RxSwift
import UIKit

class LiveStockViewController: UITableViewController {
    // MARK: Properties
    
    private let disposeBag = DisposeBag()
    
    let viewModel: LiveStockViewModel
    lazy var tableBuilder: StockTableUIBuilder = StockTableUIBuilder(tableview: tableView)
    
    // MARK: Life Cycle
    
    init(viewModel: LiveStockViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    deinit {
        print()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        tableBuilder.subscribe(to: viewModel.viewState)
        
        tableBuilder.viewAction
            .bind { [unowned self] action in
                switch action {
                case let .willDisplay(identity: identity):
                    self.viewModel.resumeSubscription(identity: identity)
                    
                case let .didEndDisplaying(identity: identity):
                    self.viewModel.pauseSubscription(identity: identity)
                }
            }
            .disposed(by: disposeBag)
        
        viewModel.subscribe()
    }
}
