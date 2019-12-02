//
//  MultiplierTVC.swift
//  Get Rich!
//
//  Created by Daniel Choi on 12/2/19.
//  Copyright © 2019 Daniel Choi. All rights reserved.
//

import UIKit

class MultiplierTVC: UITableViewController {

    weak var delegate: requiresRefreshDelegate?
    
    // MARK: - Outlets
    @IBOutlet weak var x2Btn: UIButton!
    @IBOutlet weak var x3Btn: UIButton!
    @IBOutlet weak var x4Btn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        determineBtns()
    }

    // MARK: - Buttons
    
    func determineBtns() {
        if let game = CoreDataStack.shared.Game.first as? Game {
            
            if game.multiplier < 2 {
                x2Btn.setTitle("$200", for: .normal)
            } else {
                disableBtn(button: x2Btn)
            }
            if game.multiplier < 3 {
                x3Btn.setTitle("$500", for: .normal)
            } else {
                disableBtn(button: x3Btn)
            }
            if game.multiplier < 4 {
                x4Btn.setTitle("$1000", for: .normal)
            } else {
                disableBtn(button: x4Btn)
            }
        }
    }
    
    func disableBtn(button: UIButton) {
        button.setImage(UIImage(named: "checkmark"), for: .normal)
        button.isUserInteractionEnabled = false
    }
    
    // MARK: - Actions
    
    @IBAction func onX2Btn(_ sender: UIButton) {
        if let game = CoreDataStack.shared.Game.first as? Game {
            if game.balance >= 200 {
                game.balance -= 200
                game.multiplier = 2
                disableBtn(button: x2Btn)
                delegate?.refresh()
            } else {
                noMoneyAlert()
            }
        }
    }
    
    @IBAction func onX3Btn(_ sender: UIButton) {
        if let game = CoreDataStack.shared.Game.first as? Game {
            if game.balance >= 500 {
                game.balance -= 500
                game.multiplier = 3
                disableBtn(button: x3Btn)
                delegate?.refresh()
            } else {
                noMoneyAlert()
            }
        }
    }
    
    @IBAction func onX4Btn(_ sender: UIButton) {
        if let game = CoreDataStack.shared.Game.first as? Game {
            if game.balance >= 1000 {
                game.balance -= 1000
                game.multiplier = 4
                disableBtn(button: x4Btn)
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
