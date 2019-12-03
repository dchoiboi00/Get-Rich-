//
//  BusinessTVC.swift
//  Get Rich!
//
//  Created by Daniel Choi on 11/26/19.
//  Copyright © 2019 Daniel Choi. All rights reserved.
//

import UIKit

protocol requiresRefreshDelegate: class {
    func refresh()
}

class BusinessTVC: UITableViewController {
    
    weak var delegate: requiresRefreshDelegate?
    
    // MARK: - Businesses
    let lemonade_stand = Business(perSwipe: 1, purchaseCost: 0)
    let massage_station = Business(perSwipe: 5, purchaseCost: 50)
    let pasta_bar = Business(perSwipe: 10, purchaseCost: 300)
    let beauty_salon = Business(perSwipe: 20, purchaseCost: 500)
    let jersey_shop = Business(perSwipe: 50, purchaseCost: 1000)
    let luxury_jewelry = Business(perSwipe: 100, purchaseCost: 5000)
    
    // MARK: - Outlets
    @IBOutlet weak var lemonadeBtn: UIButton!
    @IBOutlet weak var massageBtn: UIButton!
    @IBOutlet weak var pastaBtn: UIButton!
    @IBOutlet weak var salonBtn: UIButton!
    @IBOutlet weak var jerseyBtn: UIButton!
    @IBOutlet weak var jewelryBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        determineBtns()
    }
    
    // MARK: - Buttons
    
    func determineBtns() {
        if let game = CoreDataStack.shared.Game.first as? Game {
            disableBtn(button: lemonadeBtn)
            
            if game.billSize < massage_station.perSwipe {
                massageBtn.setTitle(formatAsCurrency(Double(massage_station.purchaseCost)), for: .normal)
            } else {
                disableBtn(button: massageBtn)
            }
            
            if game.billSize < pasta_bar.perSwipe {
                pastaBtn.setTitle(formatAsCurrency(Double(pasta_bar.purchaseCost)), for: .normal)
            } else {
                disableBtn(button: pastaBtn)
            }
            
            if game.billSize < beauty_salon.perSwipe {
                salonBtn.setTitle(formatAsCurrency(Double(beauty_salon.purchaseCost)), for: .normal)
            } else {
                disableBtn(button: salonBtn)
            }
            
            if game.billSize < jersey_shop.perSwipe {
                jerseyBtn.setTitle("$1K", for: .normal)
            } else {
                disableBtn(button: jerseyBtn)
            }
            
            if game.billSize < luxury_jewelry.perSwipe {
                jewelryBtn.setTitle("$5K", for: .normal)
            } else {
                disableBtn(button: jewelryBtn)
            }
        }
    }
    
    func disableBtn(button: UIButton) {
        button.setImage(UIImage(named: "checkmark"), for: .normal)
        button.isUserInteractionEnabled = false
    }
    
    // MARK: - Actions
    
    @IBAction func onMassageBtn(_ sender: UIButton) {
        if let game = CoreDataStack.shared.Game.first as? Game {
            if game.balance >= massage_station.purchaseCost {
                game.balance -= Int64(massage_station.purchaseCost)
                game.billSize = Int16(massage_station.perSwipe)
                disableBtn(button: massageBtn)
                delegate?.refresh()
            } else {
                noMoneyAlert()
            }
        }
    }
    
    @IBAction func onPastaBtn(_ sender: UIButton) {
        if let game = CoreDataStack.shared.Game.first as? Game {
            if game.balance >= pasta_bar.purchaseCost {
                game.balance -= Int64(pasta_bar.purchaseCost)
                game.billSize = Int16(pasta_bar.perSwipe)
                disableBtn(button: pastaBtn)
                delegate?.refresh()
            } else {
                noMoneyAlert()
            }
        }
    }
    
    @IBAction func onSalonBtn(_ sender: UIButton) {
        if let game = CoreDataStack.shared.Game.first as? Game {
            if game.balance >= beauty_salon.purchaseCost {
                game.balance -= Int64(beauty_salon.purchaseCost)
                game.billSize = Int16(beauty_salon.perSwipe)
                disableBtn(button: salonBtn)
                delegate?.refresh()
            } else {
                noMoneyAlert()
            }
        }
    }
    
    @IBAction func onJerseyBtn(_ sender: UIButton) {
        if let game = CoreDataStack.shared.Game.first as? Game {
            if game.balance >= jersey_shop.purchaseCost {
                game.balance -= Int64(jersey_shop.purchaseCost)
                game.billSize = Int16(jersey_shop.perSwipe)
                disableBtn(button: jerseyBtn)
                delegate?.refresh()
            } else {
                noMoneyAlert()
            }
        }
    }
    
    @IBAction func onJewelryBtn(_ sender: UIButton) {
        if let game = CoreDataStack.shared.Game.first as? Game {
            if game.balance >= luxury_jewelry.purchaseCost {
                game.balance -= Int64(luxury_jewelry.purchaseCost)
                game.billSize = Int16(luxury_jewelry.perSwipe)
                disableBtn(button: jewelryBtn)
                delegate?.refresh()
            } else {
                noMoneyAlert()
            }
        }
    }
    
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
