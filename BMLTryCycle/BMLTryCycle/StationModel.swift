//
//  StationModel.swift
//  BMLTryCycle
//
//  Created by Mustafa Al-Hayali on 2015-11-17.
//  Copyright © 2015 Mustafa Al-Hayali. All rights reserved.
//

import Foundation


struct Station {
    
    
    init(json:NSDictionary) {
        if let bikeShareStations = json["stationBeanList"] as? NSArray {
            let bikeShareDepots = bikeShareStations
            for var i = 0; i < bikeShareDepots.count; i++ {
                
                var availableBikes:Int?
                var availableDocks:Int?
                var latitude:Float?
                var longitude:Float?
                var stationName:String?
                
                let bikeShareData = bikeShareDepots[i] as? NSDictionary
                if let bikeShare = bikeShareData {
                    if let bike = bikeShare["availableBikes"] as? Int {
                        availableBikes = bike as Int
                        print(availableBikes!)
                    }
                    if let dock = bikeShare["availableDocks"] as? Int {
                        availableDocks = dock as Int
                        print(availableDocks!)
                    }
                    if let lat = bikeShare["latitude"] as? Float {
                        latitude = lat as Float
                        print(latitude!)
                    }
                    if let long = bikeShare["longitude"] as? Float {
                        longitude = long
                        print(longitude!)
                    }
                    if let station = bikeShare["stationName"] as? String {
                        stationName = station
                        print(stationName!)
                    }
                }
            }
        }
    }
}