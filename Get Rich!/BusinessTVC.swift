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
    let luxury_salon = Business(perSwipe: 20, purchaseCost: 500)
    
    
    // MARK: - Outlets
    @IBOutlet weak var lemonadeBtn: UIButton!
    @IBOutlet weak var massageBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        determineBtns()
    }

    // MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 1
//    }
//
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        return 5
//    }

//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: "BusinessCell", for: indexPath) as? BusinessTVCell else {
//            fatalError("Expected BusinessCell")
//        }
//
//        // Configure the cell...
//
//        return cell
//    }

    func determineBtns() {
        if let game = CoreDataStack.shared.Game.first as? Game {
            if game.billSize == lemonade_stand.perSwipe {
                disableBtn(button: lemonadeBtn)
                massageBtn.setTitle(formatAsCurrency(Double(massage_station.purchaseCost)), for: .normal)
            } else if game.billSize == massage_station.perSwipe {
                disableBtn(button: lemonadeBtn)
                disableBtn(button: massageBtn)
            } else {
                fatalError("Unknown bill size")
            }
        }
    }
    
    func disableBtn(button: UIButton) {
        button.setImage(UIImage(named: "checkmark"), for: .normal)
        button.isUserInteractionEnabled = false
    }
    
    @IBAction func onMassageBtn(_ sender: UIButton) {
        print("Pressed massage button")
        if let game = CoreDataStack.shared.Game.first as? Game {
            if game.balance >= massage_station.purchaseCost {
                game.balance -= Int16(massage_station.purchaseCost)
                game.billSize = Int16(massage_station.perSwipe)
                disableBtn(button: massageBtn)
                delegate?.refresh()
            } else {
                print("Not enough money!")
                //ADD an alert saying "Not enough money!"
            }
        }
    }
    
}
