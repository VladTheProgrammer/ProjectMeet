//
//  MapViewController.swift
//  project18
//
//  Created by Matias Jow on 2018-01-27.
//  Copyright © 2018 Happy Hour Labs Inc. All rights reserved.
//

// VC for maps

import UIKit
import Foundation
import MapKit
import FBSDKLoginKit
import Firebase

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    //used for mkmapview assotations (pins on screen)
    var locationManager: CLLocationManager = CLLocationManager()
    
    //hold the array of bars that are in the map when user pressed "select locations"
    var selectedbars = [BarLocation]()
    
    //obsolete - sets the first location for the map to display
    var initialLocation = CLLocation(latitude: 49.275701900 as CLLocationDegrees, longitude: -123.119906500 as CLLocationDegrees)

    let barAnnotationId = "barLocation"
   
    //MARK: Properties
    @IBOutlet weak var mapView: MKMapView!
    lazy var selectButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = ColorSelector.SELECTED_COLOR
        button.setTitle("Set this range", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 4
        button.layer.borderColor = UIColor.black.cgColor
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(selectLocation), for: .touchUpInside)
        return button
    }()
    
//    let annotationsView: BarView = {
//        let annotations = BarView()
//        return annotations
//    }()
    
    let circleView: MKCircleView = {
        let circle = MKCircleView()
        circle.translatesAutoresizingMaskIntoConstraints = false
        circle.backgroundColor = UIColor(red: 1, green: 0, blue: 1, alpha: 0.25)
        circle.isUserInteractionEnabled = false
        circle.layer.borderColor = UIColor.black.cgColor
        circle.layer.borderWidth = 4
        return circle
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // cancel button
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(self.cancelTapped))
        
        // Mapview setup
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startMonitoringSignificantLocationChanges()
        mapView.delegate = self
        
        // mapview setup
        mapView.isScrollEnabled = true
        mapView.isZoomEnabled = true
        
        
        
        //set map center
        centerMapOnLocation(location: initialLocation)
        
        //self.mapView.addSubview(annotationsArray)
        self.mapView.addAnnotations(BarMaster.sharedInstance.masterBarArray)
        BarMaster.sharedInstance.masterBarArray.forEach { (bar) in
            print("Bar Name Loaded: ", bar.barID ?? "nil")
        }
        
        DispatchQueue.main.async {
            self.circleView.layer.cornerRadius = self.circleView.frame.width / 2
        }
        
        mapView.addSubview(circleView)
        
        view.addSubview(mapView)
        view.addSubview(selectButton)
        
        mapView.anchorWithConstantsToTop(view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0)
        
        _ = selectButton.anchor(nil, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 16, bottomConstant: 10, rightConstant: 16, widthConstant: 0, heightConstant: 50)
        
        
        circleView.anchorWithConstantsToTop(nil, left: mapView.leftAnchor, bottom: nil, right: mapView.rightAnchor, topConstant: 0, leftConstant: 16, bottomConstant: 0, rightConstant: 16)
        circleView.heightAnchor.constraint(equalTo: circleView.widthAnchor).isActive = true
        circleView.centerYAnchor.constraint(equalTo: mapView.centerYAnchor, constant: -40).isActive = true
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        // determine users location to center map on
        determineMyCurrentLocation()
        
        
        //holds the logo on the top navigation bar
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 44))
        imageView.contentMode = .scaleAspectFit
        let image = UIImage(named: "profile-header")
        imageView.image = image
        
        //view.backgroundColor = ColorSelector.SELECTED_COLOR
        
        // navigation bar items
        navigationItem.titleView = imageView
        
        
    }
    
    // to be updated below with code to get rid or warning - i have the code written already
    func dismissWithConfig() {
        UIApplication.shared.open(NSURL(string:UIApplicationOpenSettingsURLString)! as URL, options: [:], completionHandler: nil)
    }
    
    //navigation bar left button
    @objc func cancelTapped()
    {
        self.dismiss(animated: true, completion: nil)
        
    }
    
    //set zoom range on users location
    let regionRadius: CLLocationDistance = 10000
    
    //sets map first location
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    // returns a list of the annotations (pins) visable on the screen
    @objc func selectLocation() {
   
        
        
        // pulls the viable barIDs to an array
         let visiblepins  = mapView.annotations(in: mapView.visibleMapRect).filter {$0 is BarLocation}
        
         if let visible = Array(visiblepins) as? [BarLocation]
        {
            
            selectedbars = visible
        }
        
//        // creates a string with the visable barID's
//        var selectedannotationtitles = ""
//        for loc in selectedbars
//        {
//            selectedannotationtitles.append(loc.barID!)
//            selectedannotationtitles.append(",")
//        }
        
        
        // No bars located in the screen - user not allowed to proceded
        if selectedbars.count == 0
        {
            let alertController: UIAlertController = UIAlertController(title:"No Locations in your range!", message:"try zooming the map out",  preferredStyle: .alert)
            let continueAction: UIAlertAction = UIAlertAction(title: "Okay", style: .default) { action -> Void in
                self.dismiss(animated: true, completion: nil)

            }
            
            
            alertController.addAction(continueAction)
            self.present(alertController, animated: true, completion: nil)
            return
        }
        
        // >= 1 bar in the screen - saves the bars to firebase then returns to the profileVC
        else
        {
            self.uploadBars()
            print("hit")
        }
        //dismiss the view controller - unwind segue
       self.dismiss(animated: true, completion: nil)
        
    }


    func uploadBars(){
        
        Analytics.logEvent("barsChanged", parameters: ["userID": CurrentUser.sharedInstance.userID])
        
        let daysActual = (CurrentUser.sharedInstance.userDayActual)
        let gender = (CurrentUser.sharedInstance.userGender)
        let age = (CurrentUser.sharedInstance.userAge)
        let userID = (CurrentUser.sharedInstance.userID)
        
        let ageDaysActual = "\(age)_\(daysActual)"
        let userPersonalInformation = ["Age_DaysActual": ageDaysActual] as [String : Any]
        
        //Remove current member from database pool
        CurrentUser.sharedInstance.userBarMember.forEach{
            bar in
            let databaseDeleteReferences = Database.database().reference().child("Bars").child(bar).child(CurrentUser.sharedInstance.userGender).child(CurrentUser.sharedInstance.userID)
            databaseDeleteReferences.removeValue()
        }
        
        //Remove all bars from user/barMember in database
        Database.database().reference().child("user").child(userID).child("BarMember").child("Bars").removeValue { (error, reference) in
            if error != nil {
                print(error?.localizedDescription as Any)
            } else {
                CurrentUser.sharedInstance.userBarMember.removeAll()
                print("DELETED BARS:", CurrentUser.sharedInstance.userBarMember)
                
            
                self.selectedbars.forEach {
                    bar in
                    print("Selected Bars:", bar.barID ?? "nil")
                    CurrentUser.sharedInstance.userBarMember.append(bar.barID!)
                    Database.database().reference().child("Bars").child(bar.barID!).child(gender).child(userID).updateChildValues(userPersonalInformation)
                    
                }
                print(CurrentUser.sharedInstance.userBarMember)
                Database.database().reference().child("user").child(userID).child("BarMember").child("Bars").setValue(CurrentUser.sharedInstance.userBarMember)
            }
        }
    
    }
    
    
    // MARK:- Location Handling below
    func determineMyCurrentLocation() {
        
        if CLLocationManager.locationServicesEnabled() {
            switch(CLLocationManager.authorizationStatus())
            {
            case .notDetermined:
                print("No access")
            
                locationManager.requestWhenInUseAuthorization()
                break
            case .restricted:
                promptForOsSetting()
                // restricted by e.g. parental controls. User can't enable Location Services
                break
                
            case .denied:
                promptForOsSetting()
                // user denied your app access to Location Services, but can grant access from Settings.app
                break
                
                
            case .authorizedAlways, .authorizedWhenInUse:
                print("Access")
                locationManager.startUpdatingLocation()
            }
            
            
        }
        else
        {
            promptForOsSetting()
        }
        
    }
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
            break
        case .authorizedAlways:
            locationManager.startUpdatingLocation()
            break
            
        case .notDetermined:
            break
        case .restricted:
            promptForOsSetting()
            // restricted by e.g. parental controls. User can't enable Location Services
            break
            
        case .denied:
            // user denied your app access to Location Services, but can grant access from Settings.app
            break
            
        }
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        // self.locationManager.stopUpdatingLocation()
        
        if  let location = locations.last,location != initialLocation
        {
         initialLocation = location
            self.centerMapOnLocation(location: initialLocation)
            self.locationManager.stopUpdatingLocation()
        }
      
        
    }
    
    func promptForOsSetting(){
        let alerttitle = "Enable Location"
        let alertmsg = "Change setting to Turn On Location"
        let actionSheetController: UIAlertController = UIAlertController(title:alerttitle, message:alertmsg,  preferredStyle: .alert)
        
        
        let continueAction: UIAlertAction = UIAlertAction(title: "OK", style: .default) { action -> Void in
            
            self.dismissWithConfig()
            
        }
        actionSheetController.addAction(continueAction)
        
        self.present(actionSheetController, animated: true, completion: nil)
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        selectedbars.removeAll()
        print("removed all selected:", selectedbars)
    }
}

class BarView: MKMarkerAnnotationView {
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var annotation: MKAnnotation? {
        willSet {
            if newValue as? BarLocation != nil {
                clusteringIdentifier = nil
            }
        }
    }
}
