//
//  BarMaster.swift
//  project18
//
//  Created by Vladimir Kisselev on 2018-03-19.
//  Copyright © 2018 Matias Jow. All rights reserved.
//

import Foundation
import Firebase
import MapKit

class BarMaster {
    
    static let sharedInstance = BarMaster()
    
    var masterBarArray = [BarLocation]()
    
    private init(){}
    
    
    
    // load [Bar Locations] from Firebase
    func getMasterBarList(completionHandler: @escaping () -> ()){
        
        let databaseReferenceWithoutChildren = Database.database().reference()
        
        databaseReferenceWithoutChildren.child("BarLocation").observeSingleEvent(of: .value, with: { (snapshot) in
            
            if snapshot.exists(){
                
                self.masterBarArray.removeAll()
                for rest in snapshot.children.allObjects as! [DataSnapshot] {
                    
                    guard let restDict = rest.value as? [String: Any] else { continue }
                    
                    
                    
                    //print(restDict)
                    let barID = restDict["ID"] as? String
                    let barAdress = restDict["adress"] as? String
                    let barLat = restDict["lat"] as? String
                    let barLong = restDict["long"] as? String
                    let barName = restDict["name"] as? String
                    
                    
                    let lat: CLLocationDegrees = Double(barLat!)!
                    let long: CLLocationDegrees = Double(barLong!)!
                    self.masterBarArray.append(BarLocation(ID:barID!,adress:barAdress!,name:barName!,lat:lat,long:long))
                }
           
            } else {
                print("No bars available")
            }
        
        completionHandler()
        })
        
    }
    
    func getBarNameForID(barID: String) -> String {
    
        let barIndex = BarMaster.sharedInstance.masterBarArray.index { (bar) -> Bool in
            bar.barID == barID
            
        }
        let barName = BarMaster.sharedInstance.masterBarArray[barIndex!].title
        return barName!
    }
}
