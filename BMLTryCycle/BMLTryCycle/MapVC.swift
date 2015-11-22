//
//  ViewController.swift
//  BMLTryCycle
//
//  Created by Mustafa Al-Hayali on 2015-11-17.
//  Copyright © 2015 Mustafa Al-Hayali. All rights reserved.
//

import UIKit
import MapKit

class MapVC: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    //Controls
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var btmCV: UIView!
    @IBOutlet weak var topCV: UIView!
    @IBOutlet weak var searchBar: UITextField!
    
    //Manipulated Contraints
    @IBOutlet weak var btmToSuperViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var topToSuperViewConstraint: NSLayoutConstraint!
    
    //
    let locationManager = CLLocationManager()
    var btmCVHeight:CGFloat = 152.0
    var topCVHeight:CGFloat = 67.0
    var btmCVReveiled = false
    var stageIsSet = false
    
    weak var btmContainerVC: BottomContainerVC?
    weak var topContainerVC: TopContainerVC?
    
    //Standard UIViewController function
    override func viewDidLoad() {
        super.viewDidLoad()
        self.locationManager.delegate = self
        self.mapView.delegate = self
        self.locationManager.startUpdatingLocation()
        self.locationManager.requestWhenInUseAuthorization()
        
        guard let url = NSURL(string: BIKESHARE_API_URL_STRING),
            data = NSData(contentsOfURL: url) else {return}
        do {
            if let json = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers) as? NSDictionary {
                let station = Station(json: json)
                for pins in station.mapPins {
                    guard let myPins = pins as? Annotations else {return }
                    mapView.addAnnotation(myPins)
                }
            }
        } catch {
            
        }
    }
    
    //*** Code Implemented by Mustafa and Sabrina
    let regionRadius :CLLocationDistance = 300
    
    func centerMapOnLocation(location : CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius * 2, regionRadius * 2)
        mapView.setRegion(coordinateRegion, animated: true)
        
    }
    
    
    //*** Code Implemented by Spencer and Heather
    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {
        toggleUpBtmCV { (complete) -> () in
            print("container open")
        }
//        guard let anny = view.annotation,
//            title = anny.title,
//            subtitle = anny.subtitle else { return }
        let locationTitle = "Location Title"
        
        // Access the number of bikes and available Docks info and put here:
        //btmContainerVC?.bottomContainerBikeLabel.text =
        //btmContainerVC?.bottomContainerDockLabel.text =
        
        topContainerVC?.bikeDockLocationLabel.text = locationTitle
        
        
    }
    
    func mapView(mapView: MKMapView, didDeselectAnnotationView view: MKAnnotationView) {
        toggleUpBtmCV { (complete) -> () in
            print("container open")
        }
    }
    
    func toggleUpBtmCV(completion:(Bool) -> ()) {
        var topContainOffset: CGFloat = 0
        var bottomContainOffset: CGFloat = 0
        if btmCVReveiled {
            topContainOffset = -topCVHeight
            bottomContainOffset = -btmCVHeight
        }
        btmCVReveiled = !btmCVReveiled
        UIView.animateWithDuration(
            0.3,
            delay: 0.0,
            options:[.CurveEaseInOut, .BeginFromCurrentState],
            animations: { () -> Void in
                self.btmToSuperViewConstraint.constant = bottomContainOffset
                self.topToSuperViewConstraint.constant = topContainOffset
                self.view.layoutIfNeeded()
                
            })
            { (complete) -> Void in
                
        }
        
//        UIView.animateWithDuration(0.3, animations: { () -> Void in
//            self.btmToSuperViewConstraint.constant = containOffset
//            self.view.layoutIfNeeded()
//            }) { (complete) -> Void in
//                completion(complete)
//        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "topContainerSegue" {
            guard let mpvc = segue.destinationViewController as? TopContainerVC else {return}
            mpvc.mapVC = self
            topContainerVC = mpvc
            
        }
        if segue.identifier == "bottomContainerSegue" {
            guard let mpvc = segue.destinationViewController as? BottomContainerVC else {return}
            mpvc.mapVC = self
            btmContainerVC = mpvc
            
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Heather & Spencer Animations
    override func viewDidLayoutSubviews() {
        if stageIsSet == false {
            stageIsSet = !stageIsSet
            setStage()
        }
    }
    
    func setStage() {
        btmToSuperViewConstraint.constant = -btmCVHeight
        topToSuperViewConstraint.constant = -topCVHeight
        view.layoutIfNeeded()
    }
        
}

