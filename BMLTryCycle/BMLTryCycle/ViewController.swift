//
//  ViewController.swift
//  BMLTryCycle
//
//  Created by Mustafa Al-Hayali on 2015-11-17.
//  Copyright © 2015 Mustafa Al-Hayali. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        let data = NSData(contentsOfURL: endpoint!)
        
        do{
            if let json = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as? NSDictionary{
                
                var station = Station(json: json)
                print(station)

                
//                if let bikehareStations = json["stationBeanList"] as? NSArray {
//                    
//                    let bikeShareData = bikeShareStations[0] as? NSDictionary
//                    
//                    if let bikeShare = bikeShareData {
//                        print(bikeShare["availableBikes"]!)
//                        print(bikeShare["availableDocks"]!)
//                        print(bikeShare["latitude"]!)
//                        print(bikeShare["longitude"]!)
//                        print(bikeShare["stationName"]!)
//                    }
//                }
            }
        }catch let error{
            print(error)
        }
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

