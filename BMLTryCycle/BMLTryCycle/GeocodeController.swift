//
//  GeocodeController.swift
//  BMLTryCycle
//
// This object was created by Fareed and Adam

//

import UIKit
import CoreLocation

class GeocodeController: NSObject {

    
    //This function is to allow a text feild to search a location
    func executeGeocode(searchBar:UITextField, myVC:MapVC) {
        searchBar.resignFirstResponder()
        
        guard var searchingString = searchBar.text where searchingString.characters.count > 0 else { return }
        searchingString = searchingString + " Toronto Ontario"
        
        geocodeUserLocation(searchingString) { (foundLocation) -> () in
            if(foundLocation.coordinate.latitude == 0){
                let alert = UIAlertController(title: "Error", message: "The location provided does not map to a place in Toronto", preferredStyle: .Alert)
                let okay = UIAlertAction(title: "Okay", style: .Default) { (UIAlertAction) -> Void in
                }
                alert.addAction(okay)
                myVC.presentViewController(alert, animated: true, completion: nil)
                return
            }
            let pin = Annotations(coordinate: (foundLocation.coordinate), title: "", subtitle: "")
            
            myVC.mapView.addAnnotation(pin)
            myVC.centerMapOnLocation(foundLocation)
        }
    }
    
    // This will execute the in the in code
    func geocodeUserLocation(addressString:String, returnClosure:(CLLocation)->()) {
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(addressString) { (possiblePlacemarks, possibleError) -> Void in
            if let error = possibleError {
                print(error.localizedDescription)
                returnClosure(CLLocation())
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
    
    //Geocode API
    func geocodeAPI(address:String) throws -> CLLocation {
        
        //Preparing the data
        let formmatedURL = generateURL(address)
        guard let url = NSURL(string: formmatedURL), data = NSData(contentsOfURL: url) else {return CLLocation()}
        var returnJSON: AnyObject!
        var returnCoordinates = CLLocation()
        
        //Executing API Request
        do {
            let json = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers)
            returnJSON = json
            
        } catch let error as NSError {
            throw error
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
    
    //function to create the URL
    func generateURL(address:String) -> String {
        let result = "address=" + convertStringToURL(address) + "&key="
        return REVERSE_GEOLOCATION_API_URL_STRING + result + REVERSE_GEOLOCATION_API_KEY
    }
    
    

}
