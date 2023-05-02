//
//  QuestionAnswer.swift
//  Vino
//
//  Created by Vladimir Kisselev on 2018-05-02.
//  Copyright © 2018 Matias Jow. All rights reserved.
//

import Foundation

struct QuestionAnswer {
    
    var question: String!
    
    var answer: String?
    
    init(question: String, answer: String?) {
        self.question = question
        if answer != nil {
            self.answer = answer
        } else {
            self.answer = nil
        }
    }
}
