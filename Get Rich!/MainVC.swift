//
//  ViewController.swift
//  Get Rich!
//
//  Created by Daniel Choi on 11/25/19.
//  Copyright © 2019 Daniel Choi. All rights reserved.
//

import UIKit

class MainVC: UIViewController {
    
    var didInit = false
    
    // MARK: - Outlets
    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var investmentsLabel: UILabel!
    @IBOutlet weak var billSizeLabel: UILabel!
    @IBOutlet weak var mottoLabel: UILabel!
    @IBOutlet weak var multiplierButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if !didInit {
            CoreDataStack.shared.clearContext()
            CoreDataStack.shared.initGame(balance: 0, billSize: 1, multiplier: 2, investments: 0, motto: "That man is richest whose pleasures are cheapest.")
            didInit = true
        }
        
        refreshLabels()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "BusinessSegue":
            if let vc = segue.destination as? BusinessTVC {
                //vc.delegate = self
            }
        case "InvestSegue":
            print("Invest")
        default:
            fatalError("Invalid segue identifier")
        }
    }
    
    func refreshLabels() {
        print("count: \(CoreDataStack.shared.Game.count)")
        if let game = CoreDataStack.shared.Game.last as? Game {
            balanceLabel.text = formatAsCurrency(Double(game.balance))
            investmentsLabel.text = "\(formatAsCurrency(Double(game.investments)))/s"
            billSizeLabel.text = formatAsCurrency(Double(game.billSize))
            mottoLabel.text = "Motto:   \(game.motto ?? "")"
            multiplierButton.setTitle("x\(game.multiplier.description)", for: .normal)
        }
    }
    
    // MARK: - Actions
    
    @IBAction func onTap(_ sender: UITapGestureRecognizer) {
        if let game = CoreDataStack.shared.Game.last as? Game {
            game.balance += game.billSize
        }
        refreshLabels()
    }
}

