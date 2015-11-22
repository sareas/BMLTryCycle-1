//
//  BottomContainerVC.swift
//  BMLTryCycle
//
//  Created by Spencer Alderson on 2015-11-18.
//  Copyright © 2015 Mustafa Al-Hayali. All rights reserved.
//

import UIKit

class BottomContainerVC: UIViewController {

    @IBOutlet weak var bottomContainerBikeLabel: UILabel!
    
    @IBOutlet weak var bottomContainerDockLabel: UILabel!
    weak var mapVC: MapVC?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
