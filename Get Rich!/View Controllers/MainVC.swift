//
//  ViewController.swift
//  Get Rich!
//
//  Created by Daniel Choi on 11/25/19.
//  Copyright © 2019 Daniel Choi. All rights reserved.
//

import UIKit
import AVFoundation

class MainVC: UIViewController, UIPopoverPresentationControllerDelegate, requiresRefreshDelegate {
    
    var gameTimer: Timer?
    
    var flippedOn10000 = false
    
    
    
    var audioPlayer: AVAudioPlayer?
    
    var tooManyCount: Bool = {
        return CoreDataStack.shared.Game.count > 1
    }()
    
    // MARK: - Outlets
    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var investmentsLabel: UILabel!
    @IBOutlet weak var billSizeLabel: UILabel!
    @IBOutlet weak var mottoLabel: UILabel!
    @IBOutlet weak var multiplierButton: UIButton!
    @IBOutlet weak var fallingStackTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var fallingStackLeftConstraint: NSLayoutConstraint!
    @IBOutlet weak var jackpotImage: UIImageView!
    @IBOutlet weak var balanceView: UIView!
    @IBOutlet weak var billView: UIView!
    @IBOutlet var tapGestureRecognizer: UITapGestureRecognizer!
    
    // MARK: - View Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if tooManyCount {
            CoreDataStack.shared.deleteLast()
        }
        
        refreshLabels()
        
        if UserDefaults.standard.bool(forKey: "color") {
            self.view.backgroundColor = UIColor.init(red: 249.0/255.0, green: 191.0/255.0, blue: 255.0/255.0, alpha: 1.0)
        } else {
            self.view.backgroundColor = UIColor.init(red: 143.0/255.0, green: 194.0/255.0, blue: 255.0/255.0, alpha: 1.0)
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        gameTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateFrame), userInfo: nil, repeats: true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        gameTimer?.invalidate()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "BusinessSegue":
            if let vc = segue.destination as? BusinessTVC {
                vc.delegate = self
                vc.modalPresentationStyle = .popover
                vc.popoverPresentationController!.delegate = self
            }
        case "InvestSegue":
            if let vc = segue.destination as? InvestTVC {
                vc.delegate = self
                vc.modalPresentationStyle = .popover
                vc.popoverPresentationController!.delegate = self
            }
        case "SettingsSegue":
            if let vc = segue.destination as? SettingsVC {
                vc.delegate = self
                vc.modalPresentationStyle = .popover
                vc.popoverPresentationController?.delegate = self
            }
        case "InfoSegue":
            let _ = false  //executable
        case "MultiplierSegue":
            if let vc = segue.destination as? MultiplierTVC {
                vc.delegate = self
                vc.modalPresentationStyle = .popover
                vc.popoverPresentationController!.delegate = self
            }
        default:
            fatalError("Invalid segue identifier")
        }
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    // MARK: - UI Functions
    
    func refreshLabels() {
        if let game = CoreDataStack.shared.Game.first as? Game {
            balanceLabel.text = formatAsCurrency(Double(game.balance))
            investmentsLabel.text = "\(formatAsCurrency(Double(game.income))) / s"
            billSizeLabel.text = formatAsCurrency(Double(game.billSize))
            mottoLabel.text = game.motto
            multiplierButton.setTitle("x\(game.multiplier.description)", for: .normal)
            CoreDataStack.shared.saveContext()
        }
    }
    
    @objc func updateFrame(){
        if let game = CoreDataStack.shared.Game.first as? Game {
            
            if game.income != 0 {
                game.balance += Int64(game.income)
                refreshLabels()
            }
            
            if game.multiplier != 1 {
                let number = Int.random(in: 1...40)
                if number == 1 {
                    game.balance = game.balance * Int64(game.multiplier)
                    
                    UIView.animate(withDuration: 1.5, animations: {
                        self.jackpotImage.alpha = 1.0
                    }, completion: { _ in
                        UIView.animate(withDuration: 1.0, animations: {
                            self.jackpotImage.alpha = 0.0
                        })
                    })
                    
                    flipBills()
                    
                    refreshLabels()
                }
            }
            
            if game.balance >= 10000 && !flippedOn10000 {
                flipLabel()
                
                flippedOn10000 = true
            }
            
            
        }
        
        if UserDefaults.standard.bool(forKey: "color") {
            self.view.backgroundColor = UIColor.init(red: 249.0/255.0, green: 191.0/255.0, blue: 255.0/255.0, alpha: 1.0)
        } else {
            self.view.backgroundColor = UIColor.init(red: 143.0/255.0, green: 194.0/255.0, blue: 255.0/255.0, alpha: 1.0)
        }
        refreshLabels()
    }
    
    // MARK: - Animations
    
    func stackFallingAnimation() {
        let leftNum = Int.random(in: 50...(Int(self.view.frame.width) - 50))
        fallingStackLeftConstraint.constant = CGFloat(leftNum)
        UIView.animate(withDuration: 0.3, delay: 0.0, options: [.curveEaseInOut], animations: {
            self.fallingStackTopConstraint?.constant += (self.view.frame.height + 200)
            self.view.layoutIfNeeded()
            
        }, completion: { _ in
            UIView.animate(withDuration: 0.0, delay: 0.0, options: [.curveEaseInOut], animations: {
                self.fallingStackTopConstraint.constant -= (self.view.frame.height + 200)
                self.view.layoutIfNeeded()
                })
        })
    }
    
    func flipLabel() {
        UIView.transition(
            with: balanceView,
            duration: 2.0,
            options: [.transitionFlipFromLeft],
            animations: nil)
    }
    
    func flipBills(){
        UIView.transition(
            with: billView,
            duration: 1.0,
            options: [.transitionFlipFromTop],
            animations: nil)
    }
    
    // MARK: - Delegate
    
    func refresh() {
        refreshLabels()
    }
    
    // MARK: - Actions
    
    @IBAction func onTap(_ sender: UITapGestureRecognizer) {
        if let game = CoreDataStack.shared.Game.first as? Game {
            game.balance += Int64(game.billSize)
        }
        stackFallingAnimation()

        if (UserDefaults.standard.bool(forKey: "sound")){
            playWhoosh()
        }
        
        refreshLabels()
    }
    
    @IBAction func onLongPress(_ sender: UILongPressGestureRecognizer) {
        if sender.state == .began {
            for _ in 1...10 {
                onTap(tapGestureRecognizer)
            }
            flipBills()
        }
    }
    
    @IBAction func onChangeMotto(_ sender: UIButton) {
        changeMottoActionSheet(chooseCompletion: { _ in
            let alert = UIAlertController(title: "Choose a motto", message: "Whose quote would you like to use?", preferredStyle: .actionSheet)
            
            let quote1 = UIAlertAction(title: "Warren Buffett", style: .default) { [unowned self] action in
                if let game = CoreDataStack.shared.Game.first as? Game {
                    game.motto = "You try to be greedy when others are fearful. And you try to be fearful when others are greedy."
                }
                self.refreshLabels()
            }
            let quote2 = UIAlertAction(title: "Will Rogers", style: .default) { [unowned self] action in
                if let game = CoreDataStack.shared.Game.first as? Game {
                    game.motto = "Too many people spend money they earned, to buy things they don't want, to impress people that they don't like."
                }
                self.refreshLabels()
            }
            let quote3 = UIAlertAction(title: "Jonathan Swift", style: .default) { [unowned self] action in
                if let game = CoreDataStack.shared.Game.first as? Game {
                    game.motto = "A wise person should have money in their head, but not in their heart."
                }
                self.refreshLabels()
            }
            let quote4 = UIAlertAction(title: "Benjamin Franklin", style: .default) { [unowned self] action in
                if let game = CoreDataStack.shared.Game.first as? Game {
                    game.motto = "An investment in knowledge pays the best interest."
                }
                self.refreshLabels()
            }
            let quote5 = UIAlertAction(title: "Thomas Edison", style: .default) { [unowned self] action in
                if let game = CoreDataStack.shared.Game.first as? Game {
                    game.motto = "Opportunity is missed by most people because it is dressed in overalls and looks like work."
                }
                self.refreshLabels()
            }
            
            alert.addAction(quote1)
            alert.addAction(quote2)
            alert.addAction(quote3)
            alert.addAction(quote4)
            alert.addAction(quote5)
            
            self.present(alert, animated: true)
        }, typeCompletion: { _ in
            let alert = UIAlertController(title: "My motto", message: "What do you have to say about wealth?", preferredStyle: .alert)
            
            let saveAction = UIAlertAction(title: "Save", style: .default) { [unowned self] action in
                guard let mottoTextField = alert.textFields?[0],
                    let motto = mottoTextField.text else { return }
                if let game = CoreDataStack.shared.Game.first as? Game {
                    game.motto = motto
                }
                self.refreshLabels()
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
            
            alert.addTextField(configurationHandler: { textField in
                textField.placeholder = "My motto"
            })
            
            alert.addAction(saveAction)
            alert.addAction(cancelAction)
            
            self.present(alert, animated: true)
        })
        
    }
    
    
    // MARK: - Audio
    
    func playWhoosh() {
        
        if let audioPlayer = audioPlayer, audioPlayer.isPlaying { audioPlayer.stop() }
        
        guard let soundURL = Bundle.main.url(forResource: "whoosh", withExtension: "mp3") else {
            print("ERROR: Couldn't find SOUND FILE")
            return
        }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
            audioPlayer?.play()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    // MARK: - Action Sheet
    
    func changeMottoActionSheet(chooseCompletion: @escaping (UIAlertAction) -> Void, typeCompletion: @escaping (UIAlertAction) -> Void){
        
        let alertMsg = "Choose a motto or type in your own!"
        let alert = UIAlertController(title: "Change Motto", message: alertMsg, preferredStyle: .actionSheet)
        
        let chooseAction = UIAlertAction(title: "Choose a motto", style: .default, handler: chooseCompletion)
        let typeAction = UIAlertAction(title: "My own motto", style: .default, handler: typeCompletion)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(chooseAction)
        alert.addAction(typeAction)
        alert.addAction(cancelAction)
        
        alert.popoverPresentationController?.permittedArrowDirections = []
        alert.popoverPresentationController?.sourceView = self.view
        alert.popoverPresentationController?.sourceRect = CGRect.init(x: self.view.frame.midX, y: self.view.frame.midY, width: 0, height: 0)
        
        present(alert, animated: true, completion: nil)
    }
    
}

