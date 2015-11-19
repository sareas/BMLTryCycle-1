//
//  ReverseGeocodeController.swift
//  BMLTryCycle
//
//  Created by FareedQ on 2015-11-19.
//  Copyright © 2015 Mustafa Al-Hayali. All rights reserved.
//

import UIKit
import CoreLocation

class ReverseGeocodeController: NSObject {

    //Reverse Geocode
    func reverseGeocode(address:String) -> CLLocation {
        
        //Preparing the data
        let formattedAddress = generateURL(address)
        let formmatedURL = REVERSE_GEOLOCATION_API_URL_STRING + formattedAddress + REVERSE_GEOLOCATION_API_KEY
        guard let url = NSURL(string: formmatedURL), data = NSData(contentsOfURL: url) else {return CLLocation()}
        var returnJSON: AnyObject!
        var returnCoordinates = CLLocation()
        
        //Executing API Request
        do {
            let json = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers)
            returnJSON = json
            
        } catch let error as NSError {
            print("Had an error loading the reverse geolocation data: \(error)")
            abort()
        }
        
        //Extracting Json
        if let jsonArray0 = returnJSON["results"], jsonLevel1 = jsonArray0?[0] as? NSDictionary {
            if let jsonLevel2 = jsonLevel1.valueForKey("geometry") as? NSDictionary {
                if let jsonLevel3 = jsonLevel2.valueForKey("location") as? NSDictionary {
                    guard let latitude = jsonLevel3.valueForKey("lat") as? Double else { return CLLocation() }
                    guard let longitude = jsonLevel3.valueForKey("lng") as? Double else { return CLLocation() }
                    returnCoordinates = CLLocation(latitude: latitude,longitude: longitude)
                    
                }
            }
        }
        
        //returning the results
        return returnCoordinates
    }
    
    
    func generateURL(address:String) -> String {
        let result = "address=" + convertStringToURL(address) + "&key="
        return result
    }
    
}
