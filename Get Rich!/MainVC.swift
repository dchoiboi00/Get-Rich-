//
//  ViewController.swift
//  Get Rich!
//
//  Created by Daniel Choi on 11/25/19.
//  Copyright © 2019 Daniel Choi. All rights reserved.
//

import UIKit

class MainVC: UIViewController, UIPopoverPresentationControllerDelegate, requiresRefreshDelegate {
    
    var tooManyCount: Bool = {
        return CoreDataStack.shared.Game.count > 1
    }()
    
    // MARK: - Outlets
    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var investmentsLabel: UILabel!
    @IBOutlet weak var billSizeLabel: UILabel!
    @IBOutlet weak var mottoLabel: UILabel!
    @IBOutlet weak var multiplierButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if tooManyCount {
            CoreDataStack.shared.deleteLast()
        }
        
        refreshLabels()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "BusinessSegue":
            if let vc = segue.destination as? BusinessTVC {
                vc.delegate = self
                vc.modalPresentationStyle = .popover
                vc.popoverPresentationController!.delegate = self
                vc.preferredContentSize = CGSize(width: 300, height: 500)
                
            }
        case "InvestSegue":
            print("Invest")
        default:
            fatalError("Invalid segue identifier")
        }
    }
    
    func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {
        print("Did dismiss popover")
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    func refreshLabels() {
        print("count: \(CoreDataStack.shared.Game.count)")
        if let game = CoreDataStack.shared.Game.first as? Game {
            balanceLabel.text = formatAsCurrency(Double(game.balance))
            investmentsLabel.text = "\(formatAsCurrency(Double(game.investments)))/s"
            billSizeLabel.text = formatAsCurrency(Double(game.billSize))
            mottoLabel.text = "Motto:   \(game.motto ?? "")"
            multiplierButton.setTitle("x\(game.multiplier.description)", for: .normal)
            CoreDataStack.shared.saveContext()
        }
    }
    
    // MARK: - Delegate
    
    func refresh() {
        refreshLabels()
    }
    
    // MARK: - Actions
    
    @IBAction func onTap(_ sender: UITapGestureRecognizer) {
        if let game = CoreDataStack.shared.Game.first as? Game {
            game.balance += game.billSize
        }
        refreshLabels()
    }
}

