//
//  ProfileVCViewController.swift
//  BMLTryCycle
//
//  Spencer & Fareed initially create the VC that takes in a name and save it to NSUserDefaults
//

import UIKit

class ProfileVC: UIViewController {

    @IBOutlet weak var txtName: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func btnSave(sender: AnyObject) {
        guard let appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate else {return}
        appDelegate.profile.name = txtName.text
        appDelegate.profile.save()
    }
}
