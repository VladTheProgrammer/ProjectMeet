//
//  AcceptedOffersAndMessages.swift
//  project18
//
//  Created by Vladimir Kisselev on 2018-03-23.
//  Copyright © 2018 Matias Jow. All rights reserved.
//

import Foundation
import Firebase

protocol refreshTable: class {
    func handleTableReload()
}
class AcceptedOffers {
    static let sharedInstance = AcceptedOffers()
    
    var acceptedOffersArray = [ShownUser]()
    
    var refreshDelegate: refreshTable?
    
    private init (){
        
    }
    
    func getAcceptedOfferAndMessages() {
        let acceptedOffersReference = Database.database().reference().child("user").child(CurrentUser.sharedInstance.userID).child("Accepted Offers")
        
        acceptedOffersReference.observe(.value, with: {
            snapshot in
            if snapshot.exists(){
                
                //print(snapshot)
                
                let acceptedOfferDictionary = snapshot.value as? Dictionary<String, Any>

                acceptedOfferDictionary?.forEach({ (key, value) in
                    
                    if self.acceptedOffersArray.contains(where: { (user) -> Bool in
                        if user.userID == key {
                            return true
                        }
                        return false
                    }) {
                        return
                    } else {
                        let dateDictionary = value as? Dictionary<String, Any>
                        let userID = key
                        ShownUser.handleTranslateIntoShownUsers(shownUserID: userID, shownTimeDateBar: dateDictionary!, completionHandler: { (user) in
                            let currentDate = Date()
                            
                            let calendar = Calendar.current
                            
                            let year = calendar.component(.year, from: currentDate)
                            
                            let dateFormatter = DateFormatter()
                            dateFormatter.dateFormat = "yyyy, EEEE, MMMM d"
                            let compareDate = dateFormatter.date(from: String(year) + ", " + user.dayActual!)
                            
                            
//                            Testing
//                            print("Compare Date: ", compareDate)
//                            print("Current Date: ", currentDate)
                            
                            if compareDate?.compare(currentDate) == .orderedAscending {
//                                Testing
//                                print(compareDate, " Date has passed")
                                let currentUserAcceptedReference = Database.database().reference().child("user").child(CurrentUser.sharedInstance.userID).child("Accepted Offers").child(user.userID)
                                let shownUserAcceptedReference = Database.database().reference().child("user").child(user.userID).child("Accepted Offers").child(CurrentUser.sharedInstance.userID)
                                currentUserAcceptedReference.removeValue()
                                shownUserAcceptedReference.removeValue(completionBlock: { (error, _) in
                                    if let error = error {
                                        print(error)
                                    }
                                })
                                
                            } else {
                               self.acceptedOffersArray.append(user)
                            }
                            
                            
                        })
                    }
                })
            }
         
        })
        
        acceptedOffersReference.observe(.childRemoved) { (snapshot) in
            
            var index = 0
            
            if self.acceptedOffersArray.contains(where: { (user) -> Bool in
                if user.userID == snapshot.key {
                    let nextIndex = self.acceptedOffersArray.index(where: { (userIndex) -> Bool in
                        if userIndex.userID == user.userID{
                            return true
                        }
                        return false
                    })
//                    Testing
//                    print("Index: ", nextIndex)
//                    print("User ID:", user.userID, snapshot.key)
                    index = nextIndex as! Int
                    return true
                }
                return false
            }) {
                self.acceptedOffersArray.remove(at: index)
                self.refreshDelegate?.handleTableReload()
            }
            
            print(snapshot)
        }
    }
    
    
}
