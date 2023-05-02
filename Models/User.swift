/*
 User.swift
 Project Vino
 
 Created by GOVIND on 2/7/18.
 Edited by Vladimir Kisselev on 02/28/18
 Copyright © 2018 Matias Jow. All rights reserved.
 
 This class file describes methods used by the "User Profile" screen.
 Contains functions used to pull data from Facebook, calculate years between two dates,
 summon an iOS alert screen, read data from a Database snapshot, write child data to the
 database, tableview setup used as input from the user for the "Occupation" and "About me" sections.
 Contains handlers for loading main view, cancel button tapped,
 logout tapped, did recieve memory warning, textfield(Occupation) state,
 textview(About me) state, toolbar, done with section, section cancelled,
 and textfield should return.
 */
import UIKit
import Foundation


//user info
class User {
    //let id: String
    var dayandtime: String
    var location: String
    var imageLocations: [UIImage]?
    var photo1: UIImage?
    var photo2: UIImage?
    var photo3: UIImage?
    var name: String
    var occupation: String
    
    //MARK: Initialization
    init?(dayandtime: String, location: String, photo1: UIImage?, photo2: UIImage?, photo3: UIImage?, name: String, occupation: String){
        
        guard !dayandtime.isEmpty else{
            return nil
        }
        guard !location.isEmpty else{
            return nil
        }
        guard !name.isEmpty else{
            return nil
        }
        guard !occupation.isEmpty else{
            return nil
        }
        
        self.dayandtime = dayandtime
        self.location = location
        self.photo1 = photo1
        self.photo2 = photo2
        self.photo3 = photo3
        self.imageLocations = [photo1, photo2, photo3] as? [UIImage]
        self.name = name
        self.occupation = occupation
    }
}
