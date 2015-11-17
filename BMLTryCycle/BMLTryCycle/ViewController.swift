//
//  ViewController.swift
//  BMLTryCycle
//
//  Created by Mustafa Al-Hayali on 2015-11-17.
//  Copyright © 2015 Mustafa Al-Hayali. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    
    @IBOutlet weak var mapView: MKMapView!
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.locationManager.delegate = self
        self.mapView.delegate = self
        self.locationManager.startUpdatingLocation()
        self.locationManager.requestWhenInUseAuthorization()
        let data = NSData(contentsOfURL: endpoint!)
        
        do {
            if let  json = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as? NSDictionary {
                let station = Station(json: json)
                
                for pins in station.mapPins {
                    guard let myPins = pins as? Annotations else {return }
                    mapView.addAnnotation(myPins)
                }
            }
        } catch {
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

