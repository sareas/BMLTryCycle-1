//
//  StationModel.swift
//  BMLTryCycle
//
//  Created by Mustafa Al-Hayali on 2015-11-17.
//  Copyright © 2015 Mustafa Al-Hayali. All rights reserved.
//

import Foundation
import MapKit

class Station:NSObject {

    var mapPins:NSMutableArray = []
    var array = [String]()
    let data = NSData(contentsOfURL: BIKESHARE_API_URL!)
    
    var json : NSDictionary = [:]
    var parsedAvailableBikes: NSMutableDictionary = [:]
    var parsedAvailableDocks: NSMutableDictionary = [:]
    
    override init() {
        super.init()

        do {
            if let  jsonToBeParsed = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as? NSDictionary {
                json = jsonToBeParsed
            }
        } catch {
            
        }
        if let bikeShareStations = json["stationBeanList"] as? NSArray {
            let bikeShareDepots = bikeShareStations
            for var i = 0; i < bikeShareDepots.count; i++ {
                
                let bikeShareData = bikeShareDepots[i] as? NSDictionary
                if let bikeShare = bikeShareData {
                    guard let availableBikes = bikeShare["availableBikes"] as? Int else { return }
                    guard let availableDocks = bikeShare["availableDocks"] as? Int else { return }
                    guard let latitude = bikeShare["latitude"] as? Float else { return }
                    guard let longitude = bikeShare["longitude"] as? Float else { return }
                    guard let stationName = bikeShare["stationName"] as? String else { return }
                    
                    parsedAvailableBikes.setObject(availableBikes, forKey: stationName)
                    parsedAvailableDocks.setObject(availableDocks, forKey: stationName)
                    
                    let pin = Annotations(coordinate: CLLocationCoordinate2D(latitude: CLLocationDegrees(latitude), longitude: CLLocationDegrees(longitude)), title: stationName, subtitle: "Bikes Available \(availableBikes)")
                
                    
                    mapPins.addObject(pin)
                    
                }
            }
        }
    }
}