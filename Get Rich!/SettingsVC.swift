//
//  SettingsVC.swift
//  Get Rich!
//
//  Created by Daniel Choi on 11/29/19.
//  Copyright © 2019 Daniel Choi. All rights reserved.
//

import UIKit

class SettingsVC: UIViewController {
    
    weak var delegate: requiresRefreshDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // MARK: - Actions
    
    @IBAction func onReset(_ sender: UIButton) {
        resetAlert() {_ in
            CoreDataStack.shared.clearContext()
            CoreDataStack.shared.initAfterReset()
            self.delegate?.refresh()
        }
    }
    
    // MARK: - Alerts
    
    func resetAlert(completion: @escaping (UIAlertAction) -> Void) {
        
        let alertMsg = "This will erase all of your progress."
        let alert = UIAlertController(title: "Warning!", message: alertMsg, preferredStyle: .alert)
        
        let resetAction = UIAlertAction(title: "Reset", style: .destructive, handler: completion)
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        
        alert.addAction(resetAction)
        alert.addAction(cancelAction)
        
        alert.popoverPresentationController?.permittedArrowDirections = []
        alert.popoverPresentationController?.sourceView = self.view
        alert.popoverPresentationController?.sourceRect = CGRect(x: self.view.frame.midX, y: self.view.frame.midY, width: 0, height: 0)
        
        present(alert, animated: true, completion: nil)
    }

}
