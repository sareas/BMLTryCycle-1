//
//  StationModel.swift
//  BMLTryCycle
//
//  Created by Mustafa Al-Hayali on 2015-11-17.
//  Copyright © 2015 Mustafa Al-Hayali. All rights reserved.
//

import Foundation
import MapKit

struct Station {
    
    var mapPins:NSMutableArray = []
    var array = [String]()
    
    init(json:NSDictionary) {
        if let bikeShareStations = json["stationBeanList"] as? NSArray {
            let bikeShareDepots = bikeShareStations
            for var i = 0; i < bikeShareDepots.count; i++ {
                
                let bikeShareData = bikeShareDepots[i] as? NSDictionary
                if let bikeShare = bikeShareData {
                    guard let availableBikes = bikeShare["availableBikes"] as? Int else { return }
                    //guard let availableDocks = bikeShare["availableDocks"] as? Int else { return }
                    guard let latitude = bikeShare["latitude"] as? Float else { return }
                    guard let longitude = bikeShare["longitude"] as? Float else { return }
                    guard let stationName = bikeShare["stationName"] as? String else { return }
                    
                    let pin = Annotations(coordinate: CLLocationCoordinate2D(latitude: CLLocationDegrees(latitude), longitude: CLLocationDegrees(longitude)), title: stationName, subtitle: "Bikes Available \(availableBikes)")
                    
                    mapPins.addObject(pin)
                    
                }
            }
        }
    }
}