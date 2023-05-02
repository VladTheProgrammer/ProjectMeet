//
//  File.swift
//  project18
//
//  Created by Vladimir Kisselev on 2018-03-23.
//  Copyright © 2018 Matias Jow. All rights reserved.
//

import Foundation
import Firebase
import CoreData

class CardsViewData {
    
    static let sharedInstance = CardsViewData()
    
    var shownUsersFromDatabaseQueryArray = [ShownUser]()
    
    var recievedOffersFromDatabase = [ShownUser]()
    
    var finalShownUserArray = [ShownUser]()
    
    var sampleUsers = [User]()

    var matchesnoUsers = [User]()
    
    private init(){
        loadSampleUsers()
    }
    
    func getShownUsersFromBarMember(completionHandler: @escaping () -> ()) {
        
        self.shownUsersFromDatabaseQueryArray.removeAll()
        print("ShownUsersDBQueryArray: ", self.shownUsersFromDatabaseQueryArray)
        
        CurrentUser.sharedInstance.userBarMember.forEach { (bar) in
            
            let queryRef = Database.database().reference().child("Bars").child(bar).child(CurrentUser.sharedInstance.oppositeGender)
            
            let query = queryRef.queryOrdered(byChild: "Age_DaysActual").queryStarting(atValue: "\(CurrentUser.sharedInstance.userAgeMin)_0000000").queryEnding(atValue: "\(CurrentUser.sharedInstance.userAgeMax)_1111112")
            
            query.observeSingleEvent(of: .value, with: {
                snapshot in
                
                if snapshot.exists(){
                    
                    
                    snapshot.children.forEach{
                        member in
                        let snap = member as! DataSnapshot
                        let shownUserID = snap.key
                        
                        ShownUser.handleTranslateIntoShownUsers(shownUserID: shownUserID, barID: bar, completionHandler: {
                            user in
                            let dayMatching = self.handleFindDaysThatWork(shownUser: user)
                            
                            
                            
                            if dayMatching.1 {
                                user.dayActual = dayMatching.0
                                self.shownUsersFromDatabaseQueryArray.append(user)
                                print("User Day Free: ", user.dayActual ?? "nil")
                                print("User Name: ", user.name)
                            }
                            
                        })
                    }
                }
                
            })
            
            
        }
        
        _ = Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: { (timer) in
            completionHandler()
            timer.invalidate()
        })
        
    }
    
    func next() -> ShownUser? {
        
        if self.shownUsersFromDatabaseQueryArray.isEmpty{
            return nil
        } else {
          
            while self.shownUsersFromDatabaseQueryArray.count > 0 && self.filterWithViewedUsers(shownUser: self.shownUsersFromDatabaseQueryArray.first!) {
                print(self.shownUsersFromDatabaseQueryArray.first?.name ?? "")
                self.shownUsersFromDatabaseQueryArray.removeFirst()
            }
            
            return self.shownUsersFromDatabaseQueryArray.first
        }
        
    }
    
    func filterWithViewedUsers(shownUser: ShownUser) -> Bool {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        let filter = shownUser.userID
        let predicate = NSPredicate(format: "userID = %@", filter)
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName:"ViewedUser")
        
        fetchRequest.predicate = predicate
        
        do{
            let fetchedUID = try managedContext.fetch(fetchRequest) as? [ViewedUser]
            
            if !(fetchedUID?.isEmpty)! {
                print(fetchedUID!)
                return true
            }
            //print("FETCHED UID:", fetchedUID.first?.userID!, "ALREADY VIEWED")
            
        } catch {
            
            print(error)
            
        }
        return false
    }
    
    func getRecievedOffers(completionHandler: @escaping () -> ()){
        
        let receivedOffersReference = Database.database().reference().child("user").child(CurrentUser.sharedInstance.userID).child("Received Offers")
        
        
        
        receivedOffersReference.observe(.value, with:{
            snapshot in
            if snapshot.exists(){
                let dictionary = snapshot.value as? Dictionary<String, Any>
                
                dictionary?.forEach{
                    offer in
                    let shownUserID = offer.key
                    
                    guard let recievedOfferTimeDateBar = offer.value as? Dictionary<String, Any> else {
                        return
                    }
                    ShownUser.handleTranslateIntoShownUsers(shownUserID: shownUserID, shownTimeDateBar: recievedOfferTimeDateBar, completionHandler: {
                        user in
                        if Int(user.age)! > CurrentUser.sharedInstance.userAgeMin || Int(user.age)! < CurrentUser.sharedInstance.userAgeMax {
                            self.recievedOffersFromDatabase.append(user)
                        }
                    })
                }
                
                
            } else {
                self.recievedOffersFromDatabase = [ShownUser]()
            }
            
            _ = Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: { (timer) in
                completionHandler()
                timer.invalidate()
            })
        })
    }
    
    fileprivate func handleFindDaysThatWork(shownUser: ShownUser) -> (String, Bool) {
        
        var currentUserDateArray = [Character]()
        var matchingDaysArray = [String]()
        
        //var iteratorOne = 0
        CurrentUser.sharedInstance.userDayActualInArray.forEach{
            int in
            let string = String(int)
            currentUserDateArray.append(string.first!)
            
        }
        
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MMMM d"
        
        let result = dateFormatter.string(from: date)
        print(result)
        var iterator = 0
        shownUser.dayActual?.forEach{
            char in
            if currentUserDateArray[iterator] == "1" && char == "1"{
                switch (iterator){
                case 0:
                    let dayOfWeek = dateFormatter.string(from: date.next(.monday))
                    matchingDaysArray.append(dayOfWeek)
                    break
                case 1:
                    let dayOfWeek = dateFormatter.string(from: date.next(.tuesday))
                    matchingDaysArray.append(dayOfWeek)
                    break
                case 2:
                    let dayOfWeek = dateFormatter.string(from: date.next(.wednesday))
                    matchingDaysArray.append(dayOfWeek)
                    break
                case 3:
                    let dayOfWeek = dateFormatter.string(from: date.next(.thursday))
                    matchingDaysArray.append(dayOfWeek)
                    break
                case 4:
                    let dayOfWeek = dateFormatter.string(from: date.next(.friday))
                    matchingDaysArray.append(dayOfWeek)
                    break
                case 5:
                    let dayOfWeek = dateFormatter.string(from: date.next(.saturday))
                    matchingDaysArray.append(dayOfWeek)
                    break
                case 6:
                    let dayOfWeek = dateFormatter.string(from: date.next(.sunday))
                    matchingDaysArray.append(dayOfWeek)
                    break
                default:
                    break
                }
            }
            iterator = iterator + 1
        }
        
        if !matchingDaysArray.isEmpty{
            return (matchingDaysArray.first!, true)
        }
        return ("", false)
    }
    
    
    //MARK: Sample data
    //firbase code here : get matches from backend
    fileprivate func loadSampleUsers(){
        var girl1image1: UIImage
        var girl1image2: UIImage
        var girl1image3: UIImage
        
        
        if CurrentUser.sharedInstance.userGender == "male" {
            girl1image1 = UIImage(named: "girl1image1")!
            girl1image2 = UIImage(named: "girl1image2")!
            girl1image3 = UIImage(named: "girl1image3")!

        } else {
            girl1image1 = UIImage(named: "male1image1")!
            girl1image2 = UIImage(named: "male1image2")!
            girl1image3 = UIImage(named: "male1image3")!
        }
        
        
        guard let match1 = User(dayandtime: "Location", location: "Date", photo1: girl1image1, photo2: girl1image2, photo3: girl1image3 ,name: "Update Where You Can Meet", occupation: "to see more people!") else{
            fatalError("Unable to intiiate")
        }
        
        guard let match3 = User(dayandtime: "No plans this week", location: "Start Matching!", photo1: UIImage(named: "quote1")!, photo2: UIImage(named: "quote2")!, photo3: UIImage(named: "quote3")! ,name: "Name", occupation: "Occupation") else{
            fatalError("Unable to intiiate")
        }
        
        self.sampleUsers = [match1]
        self.matchesnoUsers = [match3]
        print("loaded")
    }
    
}
