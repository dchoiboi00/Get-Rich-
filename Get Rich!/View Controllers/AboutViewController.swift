//
//  AboutViewController.swift
//  Minders
//
//  Created by CSC214 Instructor on 11/1/19.
//  Copyright © 2018 University of Rochester. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {

    @IBOutlet weak var appNameLabel: UILabel!
    @IBOutlet weak var appVersionLabel: UILabel!
    @IBOutlet weak var buildLabel: UILabel!
    @IBOutlet weak var copyrightLabel: UILabel!
    @IBOutlet weak var doneBtn: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        appNameLabel.text = NSLocalizedString("str_bundleName", comment: "")
        appVersionLabel.text = Bundle.main.version
        buildLabel.text = Bundle.main.build
        copyrightLabel.text = Bundle.main.copyright

        doneBtn.setTitle(NSLocalizedString("str_done", comment: ""), for: .normal)
    }
   
    @IBAction func onDoneBtn(_ sender: UIButton) {
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
}
