/*
 CurrentUser.swift
 Project Vino
 
 Created by Vladimir Kisselev on 03/04/18
 Copyright © 2018 Matias Jow. All rights reserved.
 
 This class file describes an object of type Current User. Handles a pull from database, and assigns relevant variables.
 */

import Foundation
import Firebase
import FBSDKCoreKit


class CurrentUser {
    
    
    //Creating root reference for Database
    let rootRef = Database.database().reference()
    
    //Creating an authentication reference
    let rootAuth = Auth.auth().currentUser
    
    //Variable used for storing user ID
    var userID = String()
    
    //Variable used for storing User Age
    var userAge = String()
    
    //Variable for storing user occupation
    var userOccupation = String()
    
    let sampleImageReference = Storage.storage().reference().child("sampleImages").child("blankProfile.png")
    
    //Variable for current user age min, age max
    var userAgeRange = Dictionary<String, Int>()
    
    //Variable used to store minimum age preference
    var userAgeMin = Int()
    
    //Variable used to store maximum age preference
    var userAgeMax = Int()
    
    //Variable used to store an array of bar IDs that user is a member of
    var userBarMember = [String]()
    
    //Variable used to store user gender
    var userGender = String()
    
    //Variable used to store user free days
    var userDayActual = String()
    
    //Variable used to store user name
    var userName = String()
    
    var userFullName = String()
    
    //Variable used to store an array of image location to convert to storage references
    var imageLocations = [String]()
    
    //Variable used to store opposite gender
    var oppositeGender = String()
    
    var imageReferencesArray = [StorageReference]()
    
    static let sharedInstance = CurrentUser()

    var userDayActualInArray = [0, 0, 0, 0, 0, 0, 0]
    
    var questionAnswerArray = [QuestionAnswer]()
    
    private init(){
    }
    
}


extension CurrentUser {
    
    func getCurrentUser(completionHandler: @escaping (Bool) -> ()){
        
        self.userID = (rootAuth?.uid)!
        
        
        
        //Taking a snapshot of Database
        self.rootRef.child("user").child(self.userID).observeSingleEvent(of: .value, with: {
            snapshot in
            
            //Checking if snapshot exists
            if snapshot.exists(){
                
                self.handleUserSetupFromSnapshot(snapshot: snapshot, completionHandler: {(success) in
                    
                    completionHandler(success)
                })
                
            } else {
                self.handleGetUserFromFacebook(completionHandler: {
                    completionHandler(true)
                })
                
            }
            
        })
    }
    /*
     Method used to calculate Years between two dates.
     Returns Int: _
     */
    func handleYearsBetween(date1: Date, date2: Date) -> Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([Calendar.Component.year], from: date1, to: date2)
        return components.year ?? 0
    }
    
    func handleUserSetupFromSnapshot(snapshot: DataSnapshot, completionHandler: @escaping (Bool) -> ()){
        
        //print(snapshot)
        
        let valuesDictionary = snapshot.value as? Dictionary<String, Any>
        //self.userID = snapshot.key
        
        let complete = handleUserDictionaryAssessment(valuesDictionary: valuesDictionary!)
        
       
        
        completionHandler(complete)
    }
    
    func handleGetUserFromFacebook(completionHandler: @escaping () -> ()){
        
        //Date Formatter object used in date calculations
        let dateFormatter = DateFormatter()
        
        //Sending a request to Facebook Graph API for user information
        FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, email, age_range, "
            + "updated_time,birthday,work,gender "]).start(completionHandler: {
                (connection, result, error) -> Void in
                
                if (error != nil) {
                    print("Login error: ", (error?.localizedDescription)!)
                    //self.alertwith(message: errors.localizedDescription, alerttitle: "Login error")
                    
                    return
                } else {
                    //Storing results as a NSDictionary Array
                    if let fbDATA = result as? NSDictionary {
                        
                        
                        //Storing local Name variable
                        if let fbName = fbDATA["name"] as? String {
                            
                            self.userFullName = fbName
                            self.userName = fbName.components(separatedBy: " ").first!
                        }
                        
                        //Storing local Birthday variable
                        if let birthday = fbDATA["birthday"] as? String {
                            //birthday = "12/01/1990";
                            
                            //Setting Date Formatter
                            dateFormatter.dateFormat = "MM/dd/yyyy"
                            
                            //Setting user birthday
                            if let date1 = dateFormatter.date(from: birthday) {
                                
                                let date2 = Date()
                                
                                //Determining age
                                let agevalue  = self.handleYearsBetween(date1:date1, date2:date2)
                                
                                //Setting local Age variable
                                self.userAge = "\(agevalue)"
                            }
                        } else  if let agerange = fbDATA["age_range"]
                            as? [String:Any],let minrange = agerange["min"] as? Int {
                            
                            //Setting local Age variable
                            self.userAge = "\(minrange)"
                        }
                        
                        //Extracting user occupation from Facebook, storing in local Array
                        if let workarray = fbDATA["work"] as? [Dictionary<String, Any>],workarray.count > 0 {
                            
                            //Testing
                            //print(workarray.first!)
                            
                            if let employer = workarray.first!["employer"] as? [String:Any],let profession = employer["name"] as? String {
                                
                                //Setting local Occupation variable
                                self.userOccupation = profession
                            }
                        }
                        
                        //Storing gender information to a local variable
                        if let fbGender = fbDATA["gender"] as? String {
                            self.userGender = fbGender
                            self.setOppositeGender(gender: fbGender)
                        }
                        
                        self.userBarMember = [String]()
                        self.userAgeMin = 19
                        self.userAgeMax = 40
                        //Assigning age range to a local variable
                        self.userAgeRange = ["MinimumAge" : self.userAgeMin, "MaximumAge": self.userAgeMax]
                        
                        self.imageLocations = [String]()
                        
                        self.imageReferencesArray = [StorageReference]()
                        self.userDayActual = "0000000"
                    }
                }
                self.handleSaveCurrentUserToDatabase()
                completionHandler()
            })
    }
    
    func setOppositeGender(gender: String){
        //Checking curent gender
        if gender == "male" {
            
            //Assigning opposite gender to a local variable
            self.oppositeGender = "female"
        } else {
            
            //Assigning opposite gender to a local variable
            self.oppositeGender = "male"
        }
    }
    
    func handleUserDictionaryAssessment(valuesDictionary: Dictionary<String, Any>) -> Bool {
        
        
        if let questionAnswer = valuesDictionary["QuestionAnswer"] as! [Any]? {


            questionAnswer.forEach {
                questionAnswerPair in

                let valuesDictionary = questionAnswerPair as! Dictionary<String, Any>

                let question = valuesDictionary["Question"] as! String

                if let answer = valuesDictionary["Answer"] as! String? {
                    self.questionAnswerArray.append(QuestionAnswer(question: question, answer: answer))

                    print("Question Answer Updated")
                } else {
                    self.questionAnswerArray.append(QuestionAnswer(question: question, answer: nil))

                    print("Question Updated")
                }


            }
        } else {
            print("No Question Answer Pairs exist")
        }
        
        if let occupation = valuesDictionary["Occupation"] as! String? {
            self.userOccupation = occupation
        } else {
            self.userOccupation = ""
        }
        
        if let ageRange = valuesDictionary["AgeRange"] as! Dictionary<String, Int>? {
            //print("AGE RANGE:", ageRange)
            self.userAgeMin = ageRange["MinimumAge"]!
            //print(userAgeMin)
            self.userAgeMax = ageRange["MaximumAge"]!
            
            self.userAgeRange = ["MinimumAge" : ageRange["MinimumAge"]!, "MaximumAge": ageRange["MaximumAge"]!]
        } else {
            self.userAgeMin = 19
            self.userAgeMax = 40
            self.userAgeRange = ["MinimumAge" : self.userAgeMin, "MaximumAge": self.userAgeMax]
        }
        
        if let imageLocations = valuesDictionary["imageLocations"] as! [String]? {
            self.imageLocations = imageLocations
            self.handleCurrentReferencesToArray()
        } else {
            self.imageLocations = [String]()
            
            self.imageReferencesArray = [StorageReference]()
        }
        
        if let userName = valuesDictionary["Name"] as! String? {
            self.userName = userName
        } else {
            self.userName = ""
        }
        
        
        if let userAge = valuesDictionary["Age"] as! String? {
            self.userAge = userAge
        } else {
            self.userAge = ""
        }
        
        if let userBarMember = valuesDictionary["BarMember"] as! Dictionary<String, Any>? {
            self.userBarMember = userBarMember["Bars"] as! [String]
            
        } else {
            self.userBarMember = [String]()
        }
        
        if let userGender = valuesDictionary["Gender"] as! String? {
            self.userGender = userGender
            self.setOppositeGender(gender: userGender)
        } else {
            self.userGender = ""
            self.oppositeGender = ""
        }
        
        if let userDayActual = valuesDictionary["DaysActual"] as! String? {
            self.userDayActual = userDayActual
            handleDayActualToArray(dayString: userDayActual)
        } else {
            self.userDayActual = "0000000"
        }
        
        if let userFullName = valuesDictionary["fullName"] as! String? {
            self.userFullName = userFullName
        } else {
            self.userFullName = ""
        }
        return true
    }
    
    func handleDayActualToArray(dayString: String) {
        for (index, char) in dayString.enumerated(){
            
            self.userDayActualInArray[index] = Int(String(char))!
        }
    }
    
    func handleSaveCurrentUserToDatabase(){
        
        let databaseBarMemberLocation = ["Bars" : self.userBarMember]
        
        let currentUserInfo = ["Age" : self.userAge, "AgeRange" : self.userAgeRange, "BarMember" : databaseBarMemberLocation, "DaysActual" : self.userDayActual, "Gender" : self.userGender, "Name" : self.userName, "Occupation" : self.userOccupation, "fullName" : self.userFullName, "imageLocations" : self.imageLocations] as [String : Any]
        
        
        self.rootRef.child("user").child(CurrentUser.sharedInstance.userID).updateChildValues(currentUserInfo)
    }
    
    func handleSaveUserQuestionsToDatabase() {
        let questionsReference = Database.database().reference().child("user").child(CurrentUser.sharedInstance.userID).child("QuestionAnswer")
        
        var uploadDictionary = Dictionary<String, Any>()

        var counter = 0
        
        self.questionAnswerArray.forEach {
            questionAnswerPair in
            
            let unpackedPair = ["Question": questionAnswerPair.question, "Answer": questionAnswerPair.answer]
            
            uploadDictionary.updateValue(unpackedPair, forKey: "\(counter)")
            
            counter += 1
        }
        
        questionsReference.setValue(uploadDictionary)
        
        counter = 0
        
    }
    
    func handleCurrentReferencesToArray(){
        
       self.imageReferencesArray = [StorageReference]()
        
        let imageRootReference = Storage.storage().reference().child(self.userID)

        self.imageLocations.forEach {
            imageLocation in
            
            self.imageReferencesArray.append(imageRootReference.child(imageLocation))
        }
        
        handleImageDownloadToArray()
    }
    
    func handleImageDownloadToArray(){
        
        imageReferencesArray.forEach{
            imageReference in
            
            let image = UIImageView()
            
            image.sd_setImage(with: imageReference)
        }
    }
    
    func saveUserValuesToDatabase(value: [String: Any], forPath: String){
        let databaseReference = Database.database().reference().child("user").child(forPath)
        
        databaseReference.updateChildValues(value)
        
        
    }
    
    
}
