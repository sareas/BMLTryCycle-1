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
    
    override func viewDidLayoutSubviews() {
        if stageIsSet == false {
            stageIsSet = !stageIsSet
            setStage()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "topContainerSegue" {
            guard let tempVC = segue.destinationViewController as? TopContainerVC else {return}
            tempVC.mapVC = self
            self.topContainerVC = tempVC
        }
        if segue.identifier == "bottomContainerSegue" {
            guard let tempVC = segue.destinationViewController as? BottomContainerVC else {return}
            tempVC.mapVC = self
            self.btmContainerVC = tempVC
        }
    }
    
    //UI controllers and delegate commands
    @IBAction func SearchButton(sender: AnyObject) {
        searchBar.resignFirstResponder()
        executeGeocode(self.searchBar)
    }
    
    func textFieldDidEndEditing(textField: UITextField){
        executeGeocode(self.searchBar)
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
                        bikePinView.image = UIImage(named: "bikeicon")
                    }else{
                        bikePinView.image = UIImage(named: "bikeicon1")
                    }
                }
                bikePinView.bounds = CGRectMake(0, 0, 40.0, 40.0)
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
                        dockPinView.image = UIImage(named: "dockicon")
                    }else{
                        dockPinView.image = UIImage(named: "dockicon1")
                    }
                }
                dockPinView.bounds = CGRectMake(0, 0, 40.0, 40.0)
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
        navigationItem.backBarButtonItem?.tintColor = UIColor.blackColor()
    }
    
    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {
        toggleUpBtmCV { (complete) -> () in
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
    
    func executeGeocode(searchBar:UITextField) {
        guard let appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate else {return}
        guard let searchString = searchBar.text where searchString.characters.count > 0 else { return }
        
        appDelegate.geocodeController.geocodeUserLocation(searchString + " " + CURRENT_CITY_STRING) { (foundLocation) -> () in
            
            //locations returned with the long and lat of (0,0) are returned as errors
            if(foundLocation.coordinate.latitude == 0){
                self.alertMessage("The location provided did not map to a place in Toronto. Please try specifying the street's direction.")
                return
            }
            
            self.centerMapOnLocation(foundLocation)
        }
    }
    
    func alertMessage(message:String){
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .Alert)
        let okay = UIAlertAction(title: "Okay", style: .Default) { (UIAlertAction) -> Void in
        }
        alert.addAction(okay)
        presentViewController(alert, animated: true, completion: nil)
    }
    
    func centerMapOnLocation(location : CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius * 2, regionRadius * 2)
        mapView.setRegion(coordinateRegion, animated: true)
    }
}

