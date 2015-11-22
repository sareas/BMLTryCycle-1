//
//  ReverseGeocodeController.swift
//  BMLTryCycle
//
//  Created by FareedQ on 2015-11-19.
//  Copyright © 2015 Mustafa Al-Hayali. All rights reserved.
//

import UIKit
import CoreLocation

class GeocodeController: NSObject {

    //Geocode API
    func geocodeAPI(address:String) -> CLLocation {
        
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
    
    func executeGeocode(searchBar:UITextField, myVC:MapVC) {
        searchBar.resignFirstResponder()
        
        guard var searchingString = searchBar.text where searchingString.characters.count > 0 else { return }
        searchingString = searchingString + " Toronto Ontario"
        
        geocodeUserLocation(searchingString) { (foundLocation) -> () in
            let pin = Annotations(coordinate: (foundLocation.coordinate), title: "", subtitle: "")
            myVC.mapView.addAnnotation(pin)
            myVC.centerMapOnLocation(foundLocation)
        }
    }
    
    
    func geocodeUserLocation(addressString:String, returnClosure:(CLLocation)->()) {
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(addressString) { (possiblePlacemarks, possibleError) -> Void in
            if let error = possibleError {
                print(error.localizedDescription)
            } else {
                guard let actualPlacemarks = possiblePlacemarks else {
                    returnClosure(CLLocation())
                    return
                }
                for placemark in actualPlacemarks {
                    guard let foundLocation = placemark.location else {
                        returnClosure(CLLocation())
                        return
                    }
                    returnClosure(foundLocation)
                }
            }
        }
        
    }
}
