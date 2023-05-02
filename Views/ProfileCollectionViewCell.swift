//
//  ProfileCollectionViewCell.swift
//  project18
//
//  Created by Vladimir Kisselev on 2018-04-14.
//  Copyright © 2018 Matias Jow. All rights reserved.
//

import UIKit

protocol deletePhoto: class{
    
    func deleteCellAtIndex(indexPath: IndexPath)
    
}

class ProfileCollectionViewCell: UICollectionViewCell {
    
    lazy var imageView: UIImageView = {
        let image = UIImageView()
        image.backgroundColor = .white
        image.layer.cornerRadius = self.frame.height / 2
        image.layer.borderWidth = 3
        image.layer.borderColor = UIColor.black.cgColor
        image.contentMode = .scaleAspectFill
        image.tag = 10
        image.layer.masksToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    lazy var deleteButton: UIButton = {
        let button = UIButton(type: UIButtonType.roundedRect)
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 15
        button.backgroundColor = ColorSelector.SELECTED_COLOR
        button.setTitle("X", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isHidden = true
        button.addTarget(self, action: #selector(deleteButtonPressed), for: .touchUpInside)
        return button
    }()
    
    var deletePhotoDelegate: deletePhoto?
    
    var currentIndexPath: IndexPath?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("Could not instantiate ProfileCollectionViewCell")
    }
    
    func setupCell() {
        backgroundColor = .white
        
        addSubview(imageView)
        addSubview(deleteButton)
        
        imageView.anchorToTop(topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor)
        
        _ = deleteButton.anchor(nil, left: nil, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 30, heightConstant: 30)
    }
    
    @objc func deleteButtonPressed() {
        self.deletePhotoDelegate?.deleteCellAtIndex(indexPath: currentIndexPath!)
        print("delete pressed")
    }
    
}
