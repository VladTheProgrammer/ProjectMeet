//
//  AnswerCell.swift
//  Vino
//
//  Created by Vladimir Kisselev on 2018-05-02.
//  Copyright © 2018 Matias Jow. All rights reserved.
//

import Foundation

class AnswerCell: UICollectionViewCell {
    
    let answerView: UITextView = {
        let view = UITextView()
        view.isUserInteractionEnabled = true
        view.backgroundColor = .white
        view.font = UIFont.systemFont(ofSize: 14)
        view.layer.borderColor = UIColor.black.cgColor
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 8
        view.backgroundColor = ColorSelector.PINK_COLOR.withAlphaComponent(0.6)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.keyboardType = .default
        view.returnKeyType = .done
        return view
    }()
    
    var replacingIndex: Int?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(answerView)
        
        answerView.anchorWithConstantsToTop(topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: -4, leftConstant: 50, bottomConstant: 4, rightConstant: 24)
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("Failed to init AnswerCell")
    }
    
}
