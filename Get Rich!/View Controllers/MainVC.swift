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
    
    var tooManyCount: Bool = {
        return CoreDataStack.shared.Game.count > 1
    }()
    
    var gameTimer: Timer?
    
    var flippedOn10000 = false
    
    let defaults = UserDefaults.standard
    
    
    var audioPlayer: AVAudioPlayer?
    
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
            print("Invest")
            if let vc = segue.destination as? InvestTVC {
                vc.delegate = self
                vc.modalPresentationStyle = .popover
                vc.popoverPresentationController!.delegate = self
            }
        case "SettingsSegue":
            print("Settings")
            if let vc = segue.destination as? SettingsVC {
                vc.delegate = self
                vc.modalPresentationStyle = .popover
                vc.popoverPresentationController?.delegate = self
            }
        case "InfoSegue":
            print("Show info screen")
        case "MultiplierSegue":
            print("MultiplierVC")
            if let vc = segue.destination as? MultiplierTVC {
                vc.delegate = self
                vc.modalPresentationStyle = .popover
                vc.popoverPresentationController!.delegate = self
            }
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
    
    // MARK: - UI Functions
    
    func refreshLabels() {
        if let game = CoreDataStack.shared.Game.first as? Game {
            balanceLabel.text = formatAsCurrency(Double(game.balance))
            investmentsLabel.text = "\(formatAsCurrency(Double(game.income))) / s"
            billSizeLabel.text = formatAsCurrency(Double(game.billSize))
            mottoLabel.text = "Motto:   \(game.motto ?? "")"
            multiplierButton.setTitle("x\(game.multiplier.description)", for: .normal)
            CoreDataStack.shared.saveContext()
        }
    }
    
    @objc func updateFrame(){
        print("updated frame")
        if let game = CoreDataStack.shared.Game.first as? Game {
            
            if game.income != 0 {
                game.balance += Int64(game.income)
                refreshLabels()
            }
            
            if game.multiplier != 1 {
                let number = Int.random(in: 1...5)
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

        if (true){
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
    
}

