//
//  Message.swift
//  project18
//
//  Created by Vladimir Kisselev on 2018-03-15.
//  Copyright © 2018 Matias Jow. All rights reserved.
//

import UIKit

class Message: NSObject {

    var toID: String?
    var fromID: String?
    var timeStamp: NSNumber?
    var message: String?
    
    
    init(messageDictionary : Dictionary<String, AnyObject>) {
        self.toID = messageDictionary["toID"] as? String
        self.fromID = messageDictionary["fromID"] as? String
        self.timeStamp = messageDictionary["timeStamp"] as? NSNumber
        self.message = messageDictionary["Message"] as? String
    }
}
