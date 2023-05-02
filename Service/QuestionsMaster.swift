//
//  QuestionsMaster.swift
//  Vino
//
//  Created by Vladimir Kisselev on 2018-05-04.
//  Copyright © 2018 Matias Jow. All rights reserved.
//

import Foundation
import Firebase

class QuestionsMaster {
    
    static let sharedInstance = QuestionsMaster()
    
    var questionsArray = [String]()
    
    private init(){}
    
    func getMasterQuestionsList() {
        
        let questionsDatabaseReference = Database.database().reference().child("QuestionsList")
        
        questionsDatabaseReference.observeSingleEvent(of: .value) { (snapshot) in
            if snapshot.exists() {
                print("Receiving Questions")
                
                if let valuesDictionary = snapshot.value as! [String]? {
                    print("Values: ", valuesDictionary)
                    self.questionsArray = valuesDictionary
                }
                print(self.questionsArray)
            }
        }
    }
    
    
}
