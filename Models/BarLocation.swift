/*
 Locations.swift
 Project Vino
 
 Edited by Vladimir Kisselev on 03/13/18
 Copyright © 2018 Matias Jow. All rights reserved.
 
 This class file describes an object of type Locations used for bars. Contains initializer as well as local variables for an identifier, bar ID, bar street address, bar name, and bar coordinates.
 */

import UIKit
import MapKit

class BarLocation: NSObject, MKAnnotation{
    
    //Default identifier
    var identifier = "Locations identifier"
    
    //Variable used as bar ID
    var barID: String?
    
    //Variable used as bar street address
    var streetAdress: String?
    
    //Variable used as bar name
    var title: String?
    
    //Variable used to store the coorinated(lat, long) for bar
    var coordinate: CLLocationCoordinate2D
    
    //Default initializer
    init(ID:String,adress:String,name:String,lat:CLLocationDegrees,long:CLLocationDegrees){
        
        barID = ID
        streetAdress = adress
        title = name
        coordinate = CLLocationCoordinate2DMake(lat, long)
    }
}

