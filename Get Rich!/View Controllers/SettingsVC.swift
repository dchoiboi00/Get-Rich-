//
//  SettingsVC.swift
//  Get Rich!
//
//  Created by Daniel Choi on 11/29/19.
//  Copyright © 2019 Daniel Choi. All rights reserved.
//

import UIKit

class SettingsVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    weak var delegate: requiresRefreshDelegate?
    
    var selected: Int {
        return UserDefaults.standard.integer(forKey: "selected")
    }
    
    // MARK: - Outlets
    @IBOutlet weak var soundSwitch: UISwitch!
    @IBOutlet weak var colorSwitch: UISwitch!
    @IBOutlet weak var currencyPicker: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        determineSwitches()
    }
    
    // MARK: - Functions
    
    func determineSwitches() {
        if UserDefaults.standard.bool(forKey: "sound") {
            soundSwitch.setOn(true, animated: false)
        } else {
            soundSwitch.setOn(false, animated: false)
        }
        
        if UserDefaults.standard.bool(forKey: "color") {
            colorSwitch.setOn(true, animated: false)
        } else {
            colorSwitch.setOn(false, animated: false)
        }
        
        currencyPicker.selectRow(selected, inComponent: 0, animated: false)
    }
    
    // MARK: - Actions
    
    @IBAction func onReset(_ sender: UIButton) {
        resetAlert() {_ in
            CoreDataStack.shared.clearContext()
            CoreDataStack.shared.initAfterReset()
            self.delegate?.refresh()
        }
    }
    
    @IBAction func onSoundSwitch(_ sender: UISwitch) {
        UserDefaults.standard.set(sender.isOn, forKey: "sound")
    }
    
    @IBAction func onColorSwitch(_ sender: UISwitch) {
        UserDefaults.standard.set(sender.isOn, forKey: "color")
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
    
    // MARK: - PickerView
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return CurrencyType.allValues.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return CurrencyType(rawValue: row)?.title()
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if row == 0 {
            UserDefaults.standard.set("en_US", forKey: "currency")
        } else if row == 1 {
            UserDefaults.standard.set("zh_CN", forKey: "currency")
        } else if row == 2 {
            UserDefaults.standard.set("en_GB", forKey: "currency")
        }
        
        UserDefaults.standard.set(row, forKey: "selected")
        
    }

}
