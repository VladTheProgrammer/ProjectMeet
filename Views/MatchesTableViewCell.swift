//
//  MatchesTableViewCell.swift
//  project18
//
//  Created by Matias Jow on 2017-10-19
//  Copyright © 2018 Happy Hour Labs Inc. All rights reserved.
//

// view for matchesbiewcontroller
// shouldent need any code function changes

import UIKit
import Foundation
import PureLayout
import Firebase

protocol alerts: class{
    
    func presentAlert(alert: UIAlertController)
    
}

protocol deleteUser: class{
    
    func deleteCellAtIndex(indexPath: IndexPath)
    
}

protocol messaging: class {
    
    func goToMessages(indexPath: IndexPath)
}

class MatchesTableViewCell: UITableViewCell {

    
    //MARK: Properties
    let dayandtimeLabel: UITextView = {
        let textView = UITextView()
        textView.isEditable = false
        textView.isScrollEnabled = false
        return textView
    }()
    lazy var avatarView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.layer.borderColor = UIColor.black.cgColor
        imageView.layer.borderWidth = 2
        imageView.isUserInteractionEnabled = true
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    let nameLabel: UITextView = {
        let textView = UITextView()
        textView.isEditable = false
        textView.isScrollEnabled = false
        return textView
        }()
    
    lazy var messageButtonLabel: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 3
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.black.cgColor
        button.backgroundColor = ColorSelector.SELECTED_COLOR
        button.setTitle("Message", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(messageButtonTapped), for: .touchUpInside)
        return button
    }()
    lazy var cancelButtonLabel: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 3
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.black.cgColor
        button.setTitle("X", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(cancelButton), for: .touchUpInside)
        return button
    }()
    let blackBar: UIView = {
       let view = UIView()
        view.backgroundColor = .black
        return view
    }()
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
    }
    
    
    
    var alertsDelegate : alerts?
    var currentUserID: String?
    var shownUserID: String?
    
    var deleteDelegate: deleteUser?
    
    var date: String?
    
    var time: String?
    
    var currentImage = 0
    
    var currentIndex: IndexPath?
    
    var messagingDelegate: messaging?
    
    var height: NSLayoutConstraint?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        
    }
    
    func setupViews() {

        addSubview(dayandtimeLabel)
        
        addSubview(nameLabel)
        
        addSubview(avatarView)
        
        addSubview(cancelButtonLabel)
        
        addSubview(messageButtonLabel)
        
        addSubview(blackBar)

        dayandtimeLabel.anchorWithConstantsToTop(topAnchor, left: leftAnchor, bottom: cancelButtonLabel.bottomAnchor, right: cancelButtonLabel.leftAnchor, topConstant: 0, leftConstant: 5, bottomConstant: 0, rightConstant: 5)
        
        _ = nameLabel.anchor(centerYAnchor, left: avatarView.rightAnchor, bottom: messageButtonLabel.topAnchor, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 10)
        
        
        avatarView.topAnchor.constraint(equalTo: dayandtimeLabel.bottomAnchor, constant: 0).isActive = true
        avatarView.widthAnchor.constraint(equalTo: avatarView.heightAnchor).isActive = true
        avatarView.leftAnchor.constraint(equalTo: leftAnchor, constant: 30).isActive = true
        avatarView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16).isActive = true
        
        _ = cancelButtonLabel.anchor(topAnchor, left: nil, bottom: nil, right: rightAnchor, topConstant: 10, leftConstant: 0, bottomConstant: 0, rightConstant: 10, widthConstant: 45, heightConstant: 45)
        
        _ = messageButtonLabel.anchor(nil, left: avatarView.rightAnchor, bottom: blackBar.topAnchor, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 10, rightConstant: 10, heightConstant: 40)
        
        blackBar.anchorWithConstantsToTop(nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0)
        blackBar.heightAnchor.constraint(equalToConstant: 2).isActive = true

        DispatchQueue.main.async {
            self.avatarView.layer.cornerRadius = self.avatarView.frame.size.height / 2
            
        }
    }

    
    @objc func messageButtonTapped() {
        print("Button tapped")
        
        let todaysDate = Date()
        
        let dateFormatter = DateFormatter()
        let calendar = Calendar.current
        let year = calendar.component(.year, from: todaysDate)
        
        dateFormatter.dateFormat = "yyyy, EEEE, MMMM d HH:mm a"
        
        let dayOfDate = dateFormatter.date(from: String(year) + ", " + self.date! + " " + self.time!)
        let dayOfDateWithHourAdded = calendar.date(byAdding: .hour, value: -1, to: dayOfDate!, wrappingComponents: false)
        
        if dayOfDateWithHourAdded?.compare(todaysDate) == .orderedAscending {
            //if 0 == 0 {
            messagingDelegate?.goToMessages(indexPath: self.currentIndex!)
        } else {
            //message when the message button is pressed
            let alertController: UIAlertController = UIAlertController(title:"Ooops!", message:"Messaging will be avaliable 1 hour before meeting",  preferredStyle: .alert)
            let continueAction: UIAlertAction = UIAlertAction(title: "Okay", style: .default) { action -> Void in
            }
            alertController.addAction(continueAction)
            alertsDelegate?.presentAlert(alert: alertController)
        }
    }
    
    
    @objc func cancelButton() {
        
        let alertController: UIAlertController = UIAlertController(title:"Cancel Date?", message:"Are you sure you would like to cancel this date?",  preferredStyle: .alert)
        let yesAction: UIAlertAction = UIAlertAction(title: "Yes", style: .default) { action -> Void in
            
            self.deleteDelegate?.deleteCellAtIndex(indexPath: self.currentIndex!)
            
            
        }
        let noAction: UIAlertAction = UIAlertAction(title: "No", style: .default) { action -> Void in
        }
        alertController.addAction(yesAction)
        alertController.addAction(noAction)
        alertsDelegate?.presentAlert(alert: alertController)

    }

}
