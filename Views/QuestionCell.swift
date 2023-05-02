//
//  QuestionCell.swift
//  Vino
//
//  Created by Vladimir Kisselev on 2018-05-02.
//  Copyright © 2018 Matias Jow. All rights reserved.
//

import Foundation

protocol GoToQuestions: class {
    func goToQuestionsList(replacingIndex: Int)
}

class QuestionCell: UICollectionViewCell {
    
    var questionsDelegate: GoToQuestions?
    
    var replacingIndex: Int?
    
    lazy var questionButton: UIButton = {
        let button = UIButton()
        button.isUserInteractionEnabled = true
        button.backgroundColor = .white
        button.setTitleColor(.black, for: .normal)
        button.contentHorizontalAlignment = .left
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 15
        button.backgroundColor = ColorSelector.SELECTED_COLOR
        button.addTarget(self, action: #selector(presentQuestions), for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(questionButton)
        
        
        questionButton.anchorWithConstantsToTop(topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 8, bottomConstant: 0, rightConstant: 8)
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("Failed to init QuestionCell")
    }
    
    @objc func presentQuestions() {
        
        questionsDelegate?.goToQuestionsList(replacingIndex: replacingIndex!)
        print("replacing index: (Question Cell)", replacingIndex)
        
    }
}
