/*
 ShownUser.swift
 Project Vino
 
 Created by Vladimir Kisselev on 03/05/18
 Copyright © 2018 Matias Jow. All rights reserved.
 
 This class file describes an object of type Shown User. Converts array of Strings (image locarion references) to an array of StorageReferences, and assigns relevant variables.
 */

import Foundation
import Firebase

class ShownUser {
    
    //Variable to store free days of shown user
    var dayActual: String?
    
    //Variable to store the matching bar ID that ShownUser and CurrentUser are a part of
    var barID: String
    
    //Variable to store an array of Storage References that represent image locations on server
    var imageLocations: [StorageReference]
    
    //Variable to store the name of the shown user
    var name: String
    
    //Variable to store the occupation of shown user
    var occupation: String
    
    //Variable to store the user ID of shown user
    var userID: String
    
    //Variable to store the age of shown user
    var age: String
    
    //Variable to store the free time of the shown user
    let time: String?
    
    //Variable to store the free day of shown user
    let from: String?
    
    let questionsArray: [QuestionAnswer]?
    
    //Initializer
    init?(dayActual: String?, barID: String, imageLocationsString: [String], name: String, occupation: String, userID: String, age: String, time: String?, from: String?, questionsArray: [QuestionAnswer]?){
        
        
        var images = [StorageReference]()
        
        //MARK: Guard checks for empty parameters passed
        
        if !imageLocationsString.isEmpty {
            //Creating a root storage reference
            let reference = Storage.storage().reference().child(userID)
            //Looping through the images array
            imageLocationsString.forEach {
                location in
                
                //Appending the Storage Reference array with new references
                images.append(reference.child(location))
            }
        }
        
        //MARK: Assignment
        self.imageLocations = images
        self.age = age
        self.dayActual = dayActual
        self.barID = barID
        self.name = name
        self.occupation = occupation
        self.userID = userID
        self.time = time
        self.from = from
        self.questionsArray = questionsArray
        
    }
    
    
    
    static func handleTranslateIntoShownUsers(shownUserID: String, shownTimeDateBar: Dictionary<String, Any>, completionHandler: @escaping (ShownUser)->()) {
        
        let shownUserReference = Database.database().reference().child("user").child(shownUserID)
        
        let shownTime = shownTimeDateBar["Time Free"] as! String
        let shownDate = shownTimeDateBar["Day Free"] as! String
        let shownBar = shownTimeDateBar["Bar"] as! String
        
        
        shownUserReference.observeSingleEvent(of: .value) { (snapshot) in
            var name = ""
            var occupation = ""
            var age = ""
            var imageLocations = [String]()
            var questionAnswerArrayLocal = [QuestionAnswer]()
            
            if snapshot.exists(){
                
                let dictionary = snapshot.value as! Dictionary<String, Any>
                
                if let shownName = dictionary["Name"] as? String {
                    name = shownName
                }
                if let shownOccupation = dictionary["Occupation"] as? String {
                    occupation = shownOccupation
                }
                
                if let shownAge = dictionary["Age"] as? String {
                    age = shownAge
                }
                if let shownImageLocations = dictionary["imageLocations"] as? [String] {
                    imageLocations = shownImageLocations
                }
                
                if let shownQuestionAnswerArray = dictionary["QuestionAnswer"] as? [Any]{
                    shownQuestionAnswerArray.forEach({ (questionAnswerPair) in
                        let values = questionAnswerPair as! Dictionary<String, Any>
    
                        let question = values["Question"] as! String
                        if let answer = values["Answer"] as? String {
                            questionAnswerArrayLocal.append(QuestionAnswer(question: question, answer: answer))
                        } else {
                            questionAnswerArrayLocal.append(QuestionAnswer(question: question, answer: nil))
                        }
                        
                        
                    })
                }
                
                let shownUser = ShownUser(dayActual: shownDate, barID: shownBar, imageLocationsString: imageLocations, name: name, occupation: occupation, userID: shownUserID, age: age, time: shownTime, from: "receivedOffers", questionsArray: questionAnswerArrayLocal)
                completionHandler(shownUser!)
            } else {
                return
            }
        }
        
        
    }
    
    static func handleTranslateIntoShownUsers(shownUserID: String, barID: String, completionHandler: @escaping (ShownUser) -> ()) {
        let shownUserReference = Database.database().reference().child("user").child(shownUserID)
        
        
        shownUserReference.observeSingleEvent(of: .value) { (snapshot) in
            if snapshot.exists(){
    
                let shownName: String?
                let shownOccupation: String?
                let shownAge: String?
                let shownImageLocations: [String]?
                let shownDaysActual: String?
                var questionAnswerArrayLocal = [QuestionAnswer]()
                
                let dictionary = snapshot.value as! Dictionary<String, Any>
                
                if let guardedShownName = dictionary["Name"] as? String {
                    shownName = guardedShownName
                } else {
                    print("Could not observe shown user name as String")
                    shownName = ""
                }
                if let guardedShownOccupation = dictionary["Occupation"] as? String {
                    shownOccupation = guardedShownOccupation
                } else {
                    print("Could not observe shown user occupation as String")
                    shownOccupation = " "
                    
                }
                
                if let guardedShownAge = dictionary["Age"] as? String {
                    shownAge = guardedShownAge
                } else {
                    print("Could not observe shown user age as String")
                    shownAge = nil
                    
                }
                if let guardedShownImageLocations = dictionary["imageLocations"] as? [String] {
                    shownImageLocations = guardedShownImageLocations
                } else {
                    print("Could not observe shown user image locations as [String]")
                    shownImageLocations = [String]()
                    
                }
                if let guardedShownDaysActual = dictionary["DaysActual"] as? String {
                    shownDaysActual = guardedShownDaysActual
                } else {
                    print("Could not observe shown user days actual as String")
                    shownDaysActual = nil
                
                }
                
                if let shownQuestionAnswerArray = dictionary["QuestionAnswer"] as? [Any]{
                    shownQuestionAnswerArray.forEach({ (questionAnswerPair) in
                        let values = questionAnswerPair as! Dictionary<String, Any>
                        
                        let question = values["Question"] as! String
                        if let answer = values["Answer"] as? String {
                            questionAnswerArrayLocal.append(QuestionAnswer(question: question, answer: answer))
                        } else {
                            questionAnswerArrayLocal.append(QuestionAnswer(question: question, answer: nil))
                        }
                        
                        
                    })
                }
                
                
                
                
                let shownUser = ShownUser(dayActual: shownDaysActual, barID: barID, imageLocationsString: shownImageLocations!, name: shownName!, occupation: shownOccupation!, userID: shownUserID, age: shownAge!, time: nil, from: "barMembers", questionsArray: questionAnswerArrayLocal)
                completionHandler(shownUser!)
            } else {
                return
            }
        }
        
    }
}
