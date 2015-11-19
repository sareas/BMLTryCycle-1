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
    
    @IBOutlet weak var btmCV: UIView!
    @IBOutlet weak var topCV: UIView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var btmToSuperViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var topToSuperViewConstraint: NSLayoutConstraint!
    
    let locationManager = CLLocationManager()
    var btmCVHeight:CGFloat = 152.0
    var topCVHeight:CGFloat = 67.0
    var btmCVReveiled = false
    var stageIsSet = false
    
    weak var btmContainerVC: BottomContainerVC?
    weak var topContainerVC: TopContainerVC?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //setStage()
        self.locationManager.delegate = self
        self.mapView.delegate = self
        self.locationManager.startUpdatingLocation()
        self.locationManager.requestWhenInUseAuthorization()
        let data = NSData(contentsOfURL: ENDPOINT!)
        
        
        
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
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        let myView = MKAnnotationView()
        myView.image = UIImage(named: "EVVA")
        myView.canShowCallout = false
        return myView
    }
    
    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {
        toggleUpBtmCV { (complete) -> () in
            print("container open")
        }
        guard let anny = view.annotation,
            title = anny.title,
            subtitle = anny.subtitle else { return }
        
       //self.bottomContainerVC.bottomContainerBikeLabel.text = "\(title!) \(subtitle!)"
        

        
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
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

