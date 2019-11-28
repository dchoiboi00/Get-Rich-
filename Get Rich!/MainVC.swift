//
//  ViewController.swift
//  Get Rich!
//
//  Created by Daniel Choi on 11/25/19.
//  Copyright © 2019 Daniel Choi. All rights reserved.
//

import UIKit

class MainVC: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var investmentsLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        CoreDataStack.shared.initGame(balance: 0, billSize: 1, multiplier: 0, investments: 0, motto: "")
        
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
        if let game = CoreDataStack.shared.Game[0] as? Game {
            balanceLabel.text = formatAsCurrency(Double(game.balance))
            investmentsLabel.text = "\(formatAsCurrency(Double(game.investments)))/s"
        }
    }
    
    // MARK: - Actions
    
    @IBAction func onTap(_ sender: UITapGestureRecognizer) {
        print("Tapped")
        if let game = CoreDataStack.shared.Game[0] as? Game {
            print("Changed balance from \(game.balance)")
            game.balance += game.billSize
            print("to \(game.balance), billsize: \(game.billSize)")
        }
        refreshLabels()
    }
}

