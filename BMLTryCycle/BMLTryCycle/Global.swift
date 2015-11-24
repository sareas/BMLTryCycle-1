//
//  CONSTANT.swift
//  BMLTryCycle
//
//  Created by Mustafa Al-Hayali on 2015-11-17.
//  Copyright © 2015 Mustafa Al-Hayali. All rights reserved.
//

import Foundation

var pinID = String()

let BIKESHARE_API_URL = NSURL(string: "http://www.bikesharetoronto.com/stations/json")
let REVERSE_GEOLOCATION_API_URL_STRING = "https://maps.googleapis.com/maps/api/geocode/json?"
let REVERSE_GEOLOCATION_API_KEY = "AIzaSyBLSAZDGXxNs4MCBSthSPU4ndLeXZDOrSc"


// Helper Function: Given a dictornary of parameters/
// and convert a string for url
func convertStringToURL(var parameter:String) -> String {
    
    parameter = parameter.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
    parameter = parameter.stringByReplacingOccurrencesOfString(" ", withString: "+", options: NSStringCompareOptions.LiteralSearch, range: nil)
    
    return parameter
}