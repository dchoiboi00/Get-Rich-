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
        MSFT_Income.text = "\(formatAsCurrencyNoCommas((stocks[0]?.profile?.price ?? 0.0) / 20)) / s"
        FB_Income.text = "\(formatAsCurrencyNoCommas((stocks[1]?.profile?.price ?? 0.0) / 20)) / s"
        AAPL_Income.text = "\(formatAsCurrencyNoCommas((stocks[2]?.profile?.price ?? 0.0) / 20)) / s"
        NFLX_Income.text = "\(formatAsCurrencyNoCommas((stocks[3]?.profile?.price ?? 0.0) / 20)) / s"
        GOOG_Income.text = "\(formatAsCurrencyNoCommas((stocks[4]?.profile?.price ?? 0.0) / 20)) / s"
        AMZN_Income.text = "\(formatAsCurrencyNoCommas((stocks[5]?.profile?.price ?? 0.0) / 20)) / s"
        
        if let game = CoreDataStack.shared.Game.first as? Game {
            let boolArray = determineInvestments(storedVal: Int(game.investments))
            
            if boolArray[0] {
                disableBtn(button: MSFT_Price)
            } else {
                MSFT_Price.setTitle(formatAsCurrencyNoCommas(stocks[0]?.profile?.price), for: .normal)
            }
            if boolArray[1] {
                disableBtn(button: FB_Price)
            } else {
                FB_Price.setTitle(formatAsCurrencyNoCommas(stocks[1]?.profile?.price), for: .normal)
            }
            if boolArray[2] {
                disableBtn(button: AAPL_Price)
            } else {
                AAPL_Price.setTitle(formatAsCurrencyNoCommas(stocks[2]?.profile?.price), for: .normal)
            }
            if boolArray[3] {
                disableBtn(button: NFLX_Price)
            } else {
                NFLX_Price.setTitle(formatAsCurrencyNoCommas(stocks[3]?.profile?.price), for: .normal)
            }
            if boolArray[4] {
                disableBtn(button: GOOG_Price)
            } else {
                GOOG_Price.setTitle(formatAsCurrencyNoCommas(stocks[4]?.profile?.price), for: .normal)
            }
            if boolArray[5] {
                disableBtn(button: AMZN_Price)
            } else {
                AMZN_Price.setTitle(formatAsCurrencyNoCommas(stocks[5]?.profile?.price), for: .normal)
            }
            
        }
    }
    
    // MARK: - Buttons
    
    func disableBtn(button: UIButton) {
        button.setImage(UIImage(named: "checkmark"), for: .normal)
        button.isUserInteractionEnabled = false
    }
    
    // MARK: - Actions

    @IBAction func onMSFTBtn(_ sender: UIButton) {
        if let game = CoreDataStack.shared.Game.first as? Game {
            if game.balance >= Int(stocks[0]?.profile?.price ?? 0.0) {
                game.balance -= Int64(stocks[0]?.profile?.price ?? 0.0)
                game.investments = (game.investments * 10) + 1
                game.income += Int16(stocks[0]?.profile?.price ?? 0.0) / 20
                disableBtn(button: MSFT_Price)
                delegate?.refresh()
            } else {
                noMoneyAlert()
            }
        }
    }
    
    @IBAction func onFBBtn(_ sender: UIButton) {
        if let game = CoreDataStack.shared.Game.first as? Game {
            if game.balance >= Int(stocks[1]?.profile?.price ?? 0.0) {
                game.balance -= Int64(stocks[1]?.profile?.price ?? 0.0)
                game.investments = (game.investments * 10) + 2
                game.income += Int16(stocks[1]?.profile?.price ?? 0.0) / 20
                disableBtn(button: FB_Price)
                delegate?.refresh()
            } else {
                noMoneyAlert()
            }
        }
    }
    
    @IBAction func onAAPLBtn(_ sender: UIButton) {
        if let game = CoreDataStack.shared.Game.first as? Game {
            if game.balance >= Int(stocks[2]?.profile?.price ?? 0.0) {
                game.balance -= Int64(stocks[2]?.profile?.price ?? 0.0)
                game.investments = (game.investments * 10) + 3
                game.income += Int16(stocks[2]?.profile?.price ?? 0.0) / 20
                disableBtn(button: AAPL_Price)
                delegate?.refresh()
            } else {
                noMoneyAlert()
            }
        }
    }
    
    @IBAction func onNFLXBtn(_ sender: UIButton) {
        if let game = CoreDataStack.shared.Game.first as? Game {
            if game.balance >= Int(stocks[3]?.profile?.price ?? 0.0) {
                game.balance -= Int64(stocks[3]?.profile?.price ?? 0.0)
                game.investments = (game.investments * 10) + 4
                game.income += Int16(stocks[3]?.profile?.price ?? 0.0) / 20
                disableBtn(button: NFLX_Price)
                delegate?.refresh()
            } else {
                noMoneyAlert()
            }
        }
    }
    
    @IBAction func onGOOGBtn(_ sender: UIButton) {
        if let game = CoreDataStack.shared.Game.first as? Game {
            if game.balance >= Int(stocks[4]?.profile?.price ?? 0.0) {
                game.balance -= Int64(stocks[4]?.profile?.price ?? 0.0)
                game.investments = (game.investments * 10) + 5
                game.income += Int16(stocks[4]?.profile?.price ?? 0.0) / 20
                disableBtn(button: GOOG_Price)
                delegate?.refresh()
            } else {
                noMoneyAlert()
            }
        }
    }
    
    @IBAction func onAMZNBtn(_ sender: UIButton) {
        if let game = CoreDataStack.shared.Game.first as? Game {
            if game.balance >= Int(stocks[5]?.profile?.price ?? 0.0) {
                game.balance -= Int64(stocks[5]?.profile?.price ?? 0.0)
                game.investments = (game.investments * 10) + 6
                game.income += Int16(stocks[5]?.profile?.price ?? 0.0) / 20
                disableBtn(button: AMZN_Price)
                delegate?.refresh()
            } else {
                noMoneyAlert()
            }
        }
    }
    
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
    
    // MARK: - Alerts
    
    func noMoneyAlert() {
        
        let alertMsg = "You don't have enough money!"
        let alert = UIAlertController(title: "Keep tapping", message: alertMsg, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Okay", style: .default, handler: nil)
        
        alert.addAction(okAction)
        
        alert.popoverPresentationController?.permittedArrowDirections = []
        alert.popoverPresentationController?.sourceView = self.view
        alert.popoverPresentationController?.sourceRect = CGRect(x: self.view.frame.midX, y: self.view.frame.midY, width: 0, height: 0)
        
        present(alert, animated: true, completion: nil)
    }
    
}
