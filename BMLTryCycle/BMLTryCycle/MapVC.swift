//
//  ViewController.swift
//  BMLTryCycle
//
//  Created by Mustafa Al-Hayali on 2015-11-17.
//  Copyright © 2015 Mustafa Al-Hayali. All rights reserved.
//
// Fareed & Adam
// Implemented the UITextFieldDelegate to manage the search bar outlet
// Initialed delegate in view did load

import UIKit
import MapKit

class MapVC: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate, UITextFieldDelegate {
    
    //View Objects Controls
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var btmCV: UIView!
    @IBOutlet weak var topCV: UIView!
    @IBOutlet weak var searchBar: UITextField!
    @IBOutlet weak var lblDetails: UILabel!
    
    //View Annimation Contraints
    @IBOutlet weak var btmToSuperViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var topToSuperViewConstraint: NSLayoutConstraint!
    
    //Managers
    let locationManager = CLLocationManager()
    let station = Station()
    
    //
    var btmCVHeight:CGFloat = 152.0
    var topCVHeight:CGFloat = 67.0
    var btmCVReveiled = false
    var stageIsSet = false
    let regionRadius :CLLocationDistance = 300
    
    weak var btmContainerVC: BottomContainerVC?
    weak var topContainerVC: TopContainerVC?
    
    //Standard UIViewController function
    override func viewDidLoad() {
        super.viewDidLoad()

        searchBar.delegate = self
        mapView.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        for pins in station.mapPins {
            guard let myPins = pins as? Annotations else {return }
            mapView.addAnnotation(myPins)
        }
        
        if CLLocationManager.locationServicesEnabled(){
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        if (locationManager.location != nil){
            centerMapOnLocation(locationManager.location!)
        }
        
    }
    
    func centerMapOnLocation(location : CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius * 2, regionRadius * 2)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        if stageIsSet == false {
            stageIsSet = !stageIsSet
            setStage()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //UI controllers and delegate commands
    @IBAction func SearchButton(sender: AnyObject) {
        guard let appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate else {return}
        appDelegate.geocodeController.executeGeocode(self.searchBar, myVC: self)
    }
    
    func textFieldDidEndEditing(textField: UITextField){
        guard let appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate else {return}
        appDelegate.geocodeController.executeGeocode(self.searchBar, myVC: self)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let _ = touches.first {
            self.view.endEditing(true)
        }
        super.touchesBegan(touches, withEvent: event)
    }
    
    //MapView Functions
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation is MKUserLocation {
            return nil
        }
        
        var pinView : MKAnnotationView?
        let reuseID : String = pinID
        if reuseID  == "bikePin"{
            var bikePinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseID) as MKAnnotationView!
            if bikePinView == nil {
                bikePinView = MKAnnotationView(annotation: annotation, reuseIdentifier: "bikePin")
                let availableBikesKeysArray = [((bikePinView.annotation?.title)!)!]
                for key in availableBikesKeysArray{
                    if station.parsedAvailableBikes[key] as! Int > 10 {
                       // print(station.parsedAvailableBikes[key] as! Int)
                        bikePinView.image = UIImage(named: "bikeicon")
                    }else{
                        bikePinView.image = UIImage(named: "bikeicon1")
                    }
                }
                bikePinView.bounds = CGRectMake(0, 0, 25.0, 25.0)
            } else {
                bikePinView.annotation = annotation
            }
            pinView =  bikePinView
        }else if reuseID == "dockPin" {
            var dockPinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseID) as MKAnnotationView!
            if dockPinView == nil {
                dockPinView = MKAnnotationView(annotation: annotation, reuseIdentifier: "dockPin")
                let availableDocksKeysArray = [((dockPinView.annotation?.title)!)!]
                for key in availableDocksKeysArray{
                    if station.parsedAvailableDocks[key] as! Int > 10 {
                       // print(station.parsedAvailableDocks[key] as! Int)
                        dockPinView.image = UIImage(named: "dockicon")
                    }else{
                        dockPinView.image = UIImage(named: "dockicon1")
                    }
                }
                dockPinView.bounds = CGRectMake(0, 0, 25.0, 25.0)
            } else {
                
                dockPinView.annotation = annotation
            }
            pinView =  dockPinView
        }
        return pinView
    }
    
    
    func setStage() {
        btmToSuperViewConstraint.constant = -btmCVHeight
        topToSuperViewConstraint.constant = -topCVHeight
        view.layoutIfNeeded()
    }
    
    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {
        toggleUpBtmCV { (complete) -> () in
            print("annotation selected - open container")
        }
        
        guard let anny = view.annotation else { return }
        guard let title = anny.title else { return }
        
        // Access the number of bikes and available Docks info put inside container labels:
        if let annotationTitle = title {
            topContainerVC?.bikeDockLocationLabel.text = title
            
            if let numBikes = station.parsedAvailableBikes.valueForKey(annotationTitle) {
                btmContainerVC?.bottomContainerBikeLabel.text = "\(numBikes)"
            }
            if let numDocks = station.parsedAvailableDocks.valueForKey(annotationTitle) {
                btmContainerVC?.bottomContainerDockLabel.text = "\(numDocks)"
            }
        }
    }
    
    func mapView(mapView: MKMapView, didDeselectAnnotationView view: MKAnnotationView) {
        toggleUpBtmCV { (complete) -> () in
           print("annotation deselected - close container")
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


    
}

