//
//  TutorialPageCell.swift
//  project18
//
//  Created by Vladimir Kisselev on 2018-04-10.
//  Copyright © 2018 Matias Jow. All rights reserved.
//

import UIKit

class TutorialPageCell: UICollectionViewCell {
    
    var tutorialPage: TutorialPage? {
        didSet {
            guard let tPage = tutorialPage else {
                return
            }
            
            imageView.image = UIImage(named: tPage.imageName)
            imageView.contentMode = .scaleAspectFit
            
            let color = UIColor.black
            //let strokeColor = ColorSelector.BACKGROUND_COLOR
            
            let attributedText = NSMutableAttributedString(string: tPage.title, attributes: [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 22, weight: .medium), NSAttributedStringKey.foregroundColor : color])
            
            attributedText.append(NSAttributedString(string: "\n\n\(tPage.message)", attributes: [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 22, weight: .medium), NSAttributedStringKey.foregroundColor : color]))
            
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center
            
            let length = attributedText.string.count
            
            
            attributedText.addAttribute(NSAttributedStringKey.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: length))
            
            textView.attributedText = attributedText
        }
    }
    
    let imageView: UIImageView = {
        let image = UIImageView()
        image.backgroundColor = ColorSelector.PINK_COLOR
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        return image
    }()
    
    let textView: UITextView = {
        let text = UITextView()
        text.isEditable = false
        text.contentInset = UIEdgeInsetsMake(24, 0, 0, 0)
        text.backgroundColor = ColorSelector.SELECTED_COLOR
        return text
    }()
    
    let separator: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.9, alpha: 1)
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    func setupViews() {
        backgroundColor = ColorSelector.SELECTED_COLOR
        
        addSubview(imageView)
        addSubview(textView)
        addSubview(separator)
        
        
        //textView.anchorToTop(top: nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor)
        textView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.3).isActive = true
        textView.anchorWithConstantsToTop(nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 16, bottomConstant: 0, rightConstant: 16)
        
        imageView.anchorToTop(topAnchor, left: leftAnchor, bottom: textView.topAnchor, right: rightAnchor)
        
        separator.anchorToTop(nil, left: leftAnchor, bottom: textView.topAnchor, right: rightAnchor)
        separator.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
