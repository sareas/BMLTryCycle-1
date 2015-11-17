//
//  ProfileModel.swift
//  BMLTryCycle
//
//  Created by Spencer Alderson on 2015-11-17.
//  Copyright © 2015 Mustafa Al-Hayali. All rights reserved.
//

import Foundation

struct Profile {
    
    var name:String?
    
    let defaults = NSUserDefaults.standardUserDefaults()
    
    func save(){
        if name == nil { return }
        defaults.setValue(name, forKey: "name")
        defaults.synchronize()
    }
    
    func load() -> String {
        guard let name = defaults.stringForKey("name") else { return "" }
        return name
    }
}