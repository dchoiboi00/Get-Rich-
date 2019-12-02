//
//  InvestTVC.swift
//  Get Rich!
//
//  Created by Daniel Choi on 11/29/19.
//  Copyright © 2019 Daniel Choi. All rights reserved.
//

import UIKit

class InvestTVC: UITableViewController {
    
    weak var delegate: requiresRefreshDelegate?
    
    var stockQuoteHelper = StockQuoteHelper()
    
    var stocks = [Stock?](repeating: nil, count: 6)
    
    let session: URLSession = {
        let config = URLSessionConfiguration.default
        return URLSession(configuration: config)
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("loading request for all 6 stocks")
        let group = DispatchGroup()
        group.enter()
        self.loadRequest(symbolString: "MSFT", stockIndex: 0) {
            group.leave()
        }
        group.enter()
        self.loadRequest(symbolString: "FB", stockIndex: 1){
            group.leave()
        }
        group.enter()
        self.loadRequest(symbolString: "AAPL", stockIndex: 2){
            group.leave()
        }
        group.enter()
        self.loadRequest(symbolString: "NFLX", stockIndex: 3){
            group.leave()
        }
        group.enter()
        self.loadRequest(symbolString: "GOOG", stockIndex: 4){
            group.leave()
        }
        group.enter()
        self.loadRequest(symbolString: "AMZN", stockIndex: 5){
            group.leave()
        }
        
        group.notify(queue: .main){
            self.updateUI()
        }
    }

    // MARK: - Stocks
    
    func loadRequest(symbolString: String, stockIndex: Int, completionHandler: @escaping() -> Void) {
        stockQuoteHelper.fetchStock(for: symbolString) { result in
            switch result {
            case let .Success(stock):
                self.stocks[stockIndex] = stock
                completionHandler()
            case let .Failure(error):
                print("Error: \(error)")
                completionHandler()
            }
        }
    }
    
    func updateUI() {
        print("Ran updateUI")
        MSFT_Income.text = "$\(Int(stocks[0]?.profile?.price ?? 0.0) / 20) / s"
        FB_Income.text = "$\(Int(stocks[1]?.profile?.price ?? 0.0) / 20) / s"
        AAPL_Income.text = "$\(Int(stocks[2]?.profile?.price ?? 0.0) / 20) / s"
        NFLX_Income.text = "$\(Int(stocks[3]?.profile?.price ?? 0.0) / 20) / s"
        GOOG_Income.text = "$\(Int(stocks[4]?.profile?.price ?? 0.0) / 20) / s"
        AMZN_Income.text = "$\(Int(stocks[5]?.profile?.price ?? 0.0) / 20) / s"
    }
    
    // MARK: - Buttons
    
    func disableBtn(button: UIButton) {
        button.setImage(UIImage(named: "checkmark"), for: .normal)
        button.isUserInteractionEnabled = false
    }
    
    // MARK: - Actions

    
    // MARK: - Outlets
    
    @IBOutlet weak var MSFT_Income: UILabel!
    @IBOutlet weak var MSFT_Price: UIButton!
    
    @IBOutlet weak var FB_Income: UILabel!
    @IBOutlet weak var FB_Price: UIButton!
    
    @IBOutlet weak var AAPL_Income: UILabel!
    @IBOutlet weak var AAPL_Price: UIButton!
    
    @IBOutlet weak var NFLX_Income: UILabel!
    @IBOutlet weak var NFLX_Price: UIButton!
    
    @IBOutlet weak var GOOG_Income: UILabel!
    @IBOutlet weak var GOOG_Price: UIButton!
    
    @IBOutlet weak var AMZN_Income: UILabel!
    @IBOutlet weak var AMZN_Price: UIButton!
    
}
