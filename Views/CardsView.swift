//
//  CardsView.swift
//  project18
//
//  Created by Matias Jow on 2017-10-19.
//  Copyright © 2018 HAppy Hour Labs Inc. All rights reserved.
//

//NONE OF THIS CODE IS USED
// there is a function in here to place code over an image which could be good to use if we want a user description


import Foundation
import UIKit

class CardsView: UIView {

    private let imageView: UIImageView = UIImageView()
    
    var image: UIImage? {
        didSet {
            if let image = image {
                imageView.image = image
            }
        }
    }
/*
    //implemented until this point
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    private func initialize() {
        imageView.setTranslatesAutoresizingMaskIntoConstraints(false)
        imageView.backgroundColor = UIColor.clearColor()
        addSubview(imageView)
        
        
        backgroundColor = UIColor.whiteColor()
        layer.borderWidth = 0.5
        layer.borderColor = UIColor.lightGrayColor().CGColor // converts UIColor to correct type
        layer.cornerRadius = 5
        layer.masksToBounds = true // things cannot exceed the cardview's bounds
        
        setConstraints()
    }
    
    private func setConstraints() {
        // imageView Constraints
        addConstraint(NSLayoutConstraint(item: imageView, attribute: .Top, relatedBy: .Equal, toItem: self, attribute: .Top, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: imageView, attribute: .Leading, relatedBy: .Equal, toItem: self, attribute: .Leading, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: imageView, attribute: .Width, relatedBy: .Equal, toItem: self, attribute: .Width, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: imageView, attribute: .Height, relatedBy: .Equal, toItem: self, attribute: .Height, multiplier: 1.0, constant: 0))
        
    }
    */
}
