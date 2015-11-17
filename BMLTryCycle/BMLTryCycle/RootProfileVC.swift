//
//  LaunchScreenVC.swift
//  BMLTryCycle
//
//  Created by Spencer Alderson on 2015-11-17.
//  Copyright © 2015 Mustafa Al-Hayali. All rights reserved.
//

import UIKit

class RootProfileVC: UIViewController {
    
    @IBOutlet weak var welcomeMessage: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate else {
            return
        }
        welcomeMessage.text = "Welcome \(appDelegate.profile.load())"
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

