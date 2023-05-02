//
//  CardsViewController.swift
//  
//
//  Created by Matias Jow on 2018-02-10.
//  Copyright © 2018 Happy Hour Labs Inc. All rights reserved.
//

import UIKit
import Foundation
import Firebase
import CoreData


class CardsViewController: UIViewController {
    

    lazy var functions = Functions.functions()
    
    private var imageTracker = 0
    

    var timerBetweenSwipes: Timer?
    
    var time = 0.0
    
    
    lazy var photoView: UIImageView = {
        let image = UIImageView()
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        image.isUserInteractionEnabled = true
        image.addGestureRecognizer(tapGestureRecognizer)
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        return image
    }()
    
    
//    let blackBarTopView: UIView = {
//        let view = UIView()
//        view.backgroundColor = .black
//        view.translatesAutoresizingMaskIntoConstraints = false
//        return view
//    }()
//
//    let blackBarBottomView: UIView = {
//        let view = UIView()
//        view.backgroundColor = .black
//        view.translatesAutoresizingMaskIntoConstraints = false
//        return view
//    }()
    
    let userInformationView: UIView = {
        let view = UIView()
        view.backgroundColor = ColorSelector.SELECTED_COLOR
        view.layer.borderWidth = 1
        view.layer.borderColor = ColorSelector.BUTTON_BORDER_COLOR.cgColor
        view.layer.cornerRadius = 25
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let dateInformationView: UIView = {
        let view = UIView()
        view.backgroundColor = ColorSelector.SELECTED_COLOR
        view.layer.cornerRadius = 25
//        view.layer.borderWidth = 1
//        view.layer.borderColor = ColorSelector.BUTTON_BORDER_COLOR.cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    // date in this label
    let dayTimeTextView: UITextView = {
        let text = UITextView()
        text.translatesAutoresizingMaskIntoConstraints = false
        text.isEditable = false
        text.backgroundColor = .clear
        text.textColor = ColorSelector.BUTTON_COLOR
        return text
    }()
    
    // time picker element
    let timePicker: UIDatePicker = {
        let timeView = UIDatePicker()
        timeView.datePickerMode = .time
        timeView.minuteInterval = 15
        timeView.backgroundColor = .clear
        timeView.translatesAutoresizingMaskIntoConstraints = false
        timeView.subviews[0].subviews[1].isHidden = true
        timeView.subviews[0].subviews[2].isHidden = true
        //timeView.addTarget(self, action: #selector(timePickerChanged), for: UIControlEvents.valueChanged)
        return timeView
    }()
 
    
    // scroll to change time label
    let scrollmessageLabel: UILabel = {
        let labelView = UILabel()
        labelView.font = UIFont.boldSystemFont(ofSize: 10)
        labelView.textAlignment = .center
        labelView.text = "scroll to change time"
        labelView.backgroundColor = .clear
        labelView.translatesAutoresizingMaskIntoConstraints = false
        
        return labelView
    }()

    
    // name label
    let nameLabel: UILabel = {
        let labelView = UILabel()
        labelView.font = UIFont.boldSystemFont(ofSize: 22)
        labelView.translatesAutoresizingMaskIntoConstraints = false
        labelView.textAlignment = .left
        labelView.adjustsFontSizeToFitWidth = true
        
        return labelView
    }()
    
    // age label
    let ageDisplayedLabel: UILabel = {
        let labelView = UILabel()
        labelView.font = UIFont.boldSystemFont(ofSize: 20)
        labelView.translatesAutoresizingMaskIntoConstraints = false
        labelView.textAlignment = .right
        labelView.adjustsFontSizeToFitWidth = true
        
        return labelView
    }()
    
    // occupation label
    let occupationLabel: UILabel = {
        let labelView = UILabel()
        labelView.font = UIFont.boldSystemFont(ofSize: 16)
        labelView.translatesAutoresizingMaskIntoConstraints = false
        labelView.textAlignment = .center
        labelView.adjustsFontSizeToFitWidth = false
        
        return labelView
    }()

    // no button
    let nopeButton: UIButton = {
        let buttonView = UIButton()
        buttonView.setImage(UIImage(named: "no-button"), for: .normal)
        buttonView.imageView?.contentMode = .scaleAspectFill
        buttonView.layer.cornerRadius = 25
        buttonView.layer.borderWidth = 1
        buttonView.layer.borderColor = ColorSelector.BUTTON_BORDER_COLOR.cgColor
        buttonView.backgroundColor = ColorSelector.SELECTED_COLOR
        buttonView.translatesAutoresizingMaskIntoConstraints = false
        buttonView.addTarget(self, action: #selector(noButton), for: .touchUpInside)
        buttonView.setImage(UIImage(named: "no-button-pressed.png"), for: .highlighted)
        
        return buttonView
    }()
    
    // yes button
    let yupButton: UIButton = {
        let buttonView = UIButton()
        buttonView.setImage( #imageLiteral(resourceName: "yes button three dots"), for: .normal)
        buttonView.imageView?.contentMode = .scaleAspectFill
        buttonView.layer.cornerRadius = 25
        buttonView.layer.borderWidth = 1
        buttonView.layer.borderColor = ColorSelector.BUTTON_BORDER_COLOR.cgColor
        buttonView.backgroundColor = ColorSelector.SELECTED_COLOR
        buttonView.translatesAutoresizingMaskIntoConstraints = false
        buttonView.addTarget(self, action: #selector(yesButton), for: .touchUpInside)
        buttonView.setImage(UIImage(named: "yes-button-pressed.png"), for: .highlighted)
        
        return buttonView
    }()
    
    let reportButton: UIButton = {
        let buttonView = UIButton()

        buttonView.layer.cornerRadius = 3
        buttonView.layer.borderWidth = 1
        buttonView.layer.borderColor = UIColor.black.cgColor
        
        buttonView.setTitle("Report", for: .normal)
        buttonView.setTitleColor(.black, for: .normal)
        //buttonView.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 2)
        
        buttonView.translatesAutoresizingMaskIntoConstraints = false
        buttonView.addTarget(self, action: #selector(reportButtonSender), for: .touchUpInside)
        //buttonView.setImage(UIImage(named: "reportButton"), for: .normal)
        buttonView.alpha = 0.2
        return buttonView
    }()
    
    // no user text label - Hey, Its just one drink...
    let heyButton: UIButton = {
        let buttonView = UIButton()

        buttonView.setImage(UIImage(named: "hey"), for: .normal)
        buttonView.imageView?.contentMode = .scaleAspectFit

        return buttonView
    }()
    
    let questionsView: UIView = {
        let view = UIView()
        view.backgroundColor = ColorSelector.SELECTED_COLOR
        view.layer.cornerRadius = 15
        view.layer.borderWidth = 2
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isUserInteractionEnabled = false
        view.isHidden = true
        
        return view
    }()
    
    let questionsTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "About Me:"
        label.textAlignment = .center
        return label
    }()
    
    let questionAnswerPairTextView: UITextView = {
        let view = UITextView()
        view.layer.cornerRadius = 15
        view.layer.borderWidth = 2
        view.isEditable = false
        view.isUserInteractionEnabled = false
        view.isSelectable = false
        return view
    }()
    
    //array of users to show
    var users = [User]()
    
    var currentUser: CurrentUser!
    

    var firstPerson: ShownUser!
    
    
   
    //used to track the phot being showed for the noUser: User object
    var imagerTrackingVariable = 1
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        //holder for logo on top navigation bar
        let imageView = UIImageView(frame: CGRect(x: 0, y: 10, width: 75, height: 44))
        imageView.contentMode = .scaleAspectFit
        let image = UIImage(named: "profile-header")
        imageView.image = image
        
        // navigation bar item initialization - header & side buttons
        navigationItem.titleView = imageView
       
        // Right Navigation bar button
        let rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "matches-empty"), style: .plain, target: self, action: #selector(goToThree))
        navigationItem.setRightBarButton(rightBarButtonItem, animated: true)
        
        // Left Navigation bar button
        let leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "profile-button"), style: .plain, target: self, action: #selector(goToOne))
        navigationItem.setLeftBarButton(leftBarButtonItem, animated: true)
        
        displayUser()
    }
    
    
    override func viewDidLoad() {

        super.viewDidLoad()

        assignbackground()
        
        addSubviews()

        setupLayout()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    // set background image - commented out - this code not in use
    func assignbackground(){
        view.backgroundColor = UIColor(patternImage: UIImage(named: "Background")!).withAlphaComponent(0.1)
    }
    fileprivate func addSubviews(){
        photoView.addSubview(reportButton)
        
        //dateInformationView.addSubview(timePicker)
        dateInformationView.addSubview(dayTimeTextView)
//        dateInformationView.addSubview(scrollmessageLabel)
//        dateInformationView.addSubview(blackBarTopView)
//        dateInformationView.addSubview(blackBarBottomView)
        
        userInformationView.addSubview(nameLabel)
        userInformationView.addSubview(ageDisplayedLabel)
        userInformationView.addSubview(occupationLabel)
        userInformationView.addSubview(dateInformationView)
        
        photoView.addSubview(questionsView)
        
        questionsView.addSubview(questionsTitleLabel)
        questionsView.addSubview(questionAnswerPairTextView)
        
        view.addSubview(yupButton)
        view.addSubview(nopeButton)
        
        view.addSubview(userInformationView)
        view.addSubview(photoView)
        view.addSubview(heyButton)

        
    }
    
    // set ui element constraints
    fileprivate func setupLayout(){
        
        _ = dateInformationView.anchor(userInformationView.topAnchor, left: userInformationView.leftAnchor, bottom: nil, right: userInformationView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 55)
        
        
//        _ = blackBarTopView.anchor(dateInformationView.topAnchor, left: dateInformationView.leftAnchor, bottom: nil, right: dateInformationView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 2, rightConstant: 0, widthConstant: 0, heightConstant: 1)
//
//        _ = blackBarBottomView.anchor(nil, left: dateInformationView.leftAnchor, bottom: dateInformationView.bottomAnchor, right: dateInformationView.rightAnchor, topConstant: 5, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 1)
        
        
//        _ = timePicker.anchor(blackBarTopView.bottomAnchor, left: nil, bottom: blackBarBottomView.topAnchor, right: dateInformationView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 140, heightConstant: 0)
        
        dayTimeTextView.anchorWithConstantsToTop(dateInformationView.topAnchor, left: dateInformationView.leftAnchor, bottom: dateInformationView.bottomAnchor, right: dateInformationView.rightAnchor, topConstant: 2, leftConstant: 5, bottomConstant: 0, rightConstant: 5)
        
//        scrollmessageLabel.anchorWithConstantsToTop(nil, left: timePicker.subviews[0].subviews[0].leftAnchor, bottom: blackBarBottomView.topAnchor, right: dateInformationView.rightAnchor, topConstant: 0, leftConstant: 6, bottomConstant: 2, rightConstant: 4)

        userInformationView.anchorWithConstantsToTop(photoView.bottomAnchor, left: view.leftAnchor, bottom: yupButton.topAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 8, bottomConstant: 15, rightConstant: 8)
        
        nameLabel.anchorWithConstantsToTop(dateInformationView.bottomAnchor, left: userInformationView.leftAnchor, bottom: userInformationView.centerYAnchor, right: nil, topConstant: 10, leftConstant: 16, bottomConstant: 0, rightConstant: 0)
        
        ageDisplayedLabel.anchorWithConstantsToTop(dateInformationView.bottomAnchor, left: nil, bottom: userInformationView.centerYAnchor, right: userInformationView.rightAnchor, topConstant: 10, leftConstant: 0, bottomConstant: 0, rightConstant: 16)
        
        occupationLabel.anchorWithConstantsToTop(userInformationView.centerYAnchor, left: userInformationView.leftAnchor, bottom: nil, right: userInformationView.rightAnchor, topConstant: 10, leftConstant: 16, bottomConstant: 0, rightConstant: 16)
        
        _ = heyButton.anchor(nil, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 60, bottomConstant: 65, rightConstant: 60, widthConstant: 0, heightConstant: 45)
        
        _ = yupButton.anchor(nil, left: view.centerXAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 8, bottomConstant: 12, rightConstant: 8, widthConstant: 0, heightConstant: 50)
        
        _ = nopeButton.anchor(nil, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.centerXAnchor, topConstant: 0, leftConstant: 8, bottomConstant: 12, rightConstant: 8, widthConstant: 0, heightConstant: 50)
        
        _ = reportButton.anchor(nil, left: photoView.leftAnchor, bottom: photoView.bottomAnchor, right: nil, topConstant: 0, leftConstant: 5, bottomConstant: 5, rightConstant: 0, widthConstant: 80, heightConstant: 20)

        _ = photoView.anchor(view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: view.frame.size.width)
        
        //questionsView.anchorToTop(photoView.topAnchor, left: photoView.leftAnchor, bottom: photoView.bottomAnchor, right: photoView.rightAnchor)
        questionsView.anchorWithConstantsToTop(photoView.topAnchor, left: photoView.leftAnchor, bottom: photoView.bottomAnchor, right: photoView.rightAnchor, topConstant: 16, leftConstant: 40, bottomConstant: 16, rightConstant: 40)
        
        questionsTitleLabel.anchorWithConstantsToTop(questionsView.topAnchor, left: questionsView.leftAnchor, bottom: nil, right: questionsView.rightAnchor, topConstant: 12, leftConstant: 0, bottomConstant: 0, rightConstant: 0)
        
        questionAnswerPairTextView.anchorWithConstantsToTop(questionsTitleLabel.bottomAnchor, left: questionsView.leftAnchor, bottom: questionsView.bottomAnchor, right: questionsView.rightAnchor, topConstant: 16, leftConstant: 4, bottomConstant: 4, rightConstant: 4)
    }
    
    
    @objc func timePickerChanged(datePicker: UIDatePicker){
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "hh:mm a"
        let timeString = timeFormatter.string(from: datePicker.date)
        print(timeString)
    }
    
    @objc func incrementTimer(){
        time += 0.1
    }
    
    //Display the correct user
    func displayUser(){
        self.questionsView.isHidden = true
        
        timerBetweenSwipes = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(incrementTimer), userInfo: nil, repeats: false)
        
        
        
        let nextUserFromBarMember = CardsViewData.sharedInstance.next()
        
        if !CardsViewData.sharedInstance.recievedOffersFromDatabase.isEmpty {
            

            self.firstPerson = CardsViewData.sharedInstance.recievedOffersFromDatabase.first
            
            DispatchQueue.main.async {
                if self.firstPerson.imageLocations.isEmpty {
                    self.photoView.sd_setImage(with: CurrentUser.sharedInstance.sampleImageReference)
                } else {
                    self.photoView.sd_setImage(with: (self.firstPerson?.imageLocations[0])!)
                }
                let dateInformationString = (self.firstPerson?.dayActual)! + "\n\(BarMaster.sharedInstance.getBarNameForID(barID: self.firstPerson.barID))"
                let color = UIColor.black
                //let strokeColor = ColorSelector.BACKGROUND_COLOR
                
                let attributedText = NSMutableAttributedString(string: dateInformationString, attributes: [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 14, weight: .bold), NSAttributedStringKey.foregroundColor : color])
                
                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.alignment = .center
                paragraphStyle.lineSpacing = 1
                paragraphStyle.minimumLineHeight = 1
                
                let length = attributedText.string.count
                
                
                attributedText.addAttribute(NSAttributedStringKey.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: length))
                
                self.dayTimeTextView.attributedText = attributedText
                self.nameLabel.text = self.firstPerson?.name
                self.questionsTitleLabel.text = "About"
                self.occupationLabel.text = self.firstPerson?.occupation
                self.ageDisplayedLabel.text = self.firstPerson?.age
                let timeFormatter = DateFormatter()
                timeFormatter.dateFormat = "hh:mm a"
                let time = timeFormatter.date(from: (self.firstPerson?.time)!)
//                self.timePicker.setDate(time!, animated: false)
//                self.timePicker.isHidden = false
                self.yupButton.isHidden = false
                self.nopeButton.isHidden = false
                self.nameLabel.isHidden = false
                self.occupationLabel.isHidden = false
                self.heyButton.isHidden = true
                self.occupationLabel.textAlignment = .center
                
//                self.scrollmessageLabel.isHidden = false
            }
            
            
            
        } else if nextUserFromBarMember != nil {
 
            self.firstPerson = nextUserFromBarMember
            
            if self.firstPerson.imageLocations.isEmpty {
                self.photoView.sd_setImage(with: CurrentUser.sharedInstance.sampleImageReference)
            } else {
                self.photoView.sd_setImage(with: (self.firstPerson?.imageLocations[0])!)
            }
            let dateInformationString = (self.firstPerson?.dayActual)! + "\n\(BarMaster.sharedInstance.getBarNameForID(barID: self.firstPerson.barID))"
            let color = UIColor.black
            //let strokeColor = ColorSelector.BACKGROUND_COLOR
            
            let attributedText = NSMutableAttributedString(string: dateInformationString, attributes: [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 14, weight: .medium), NSAttributedStringKey.foregroundColor : color])
            
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center
            paragraphStyle.lineSpacing = 1
            paragraphStyle.minimumLineHeight = 1
            
            let length = attributedText.string.count
            
            
            attributedText.addAttribute(NSAttributedStringKey.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: length))
            
            self.dayTimeTextView.attributedText = attributedText
            self.nameLabel.text = self.firstPerson?.name
            self.questionsTitleLabel.text = "About"
            self.occupationLabel.text = self.firstPerson?.occupation
            self.ageDisplayedLabel.text = self.firstPerson?.age
//            self.timePicker.isHidden = false
            self.yupButton.isHidden = false
            self.nopeButton.isHidden = false
            self.nameLabel.isHidden = false
            self.occupationLabel.isHidden = false
            self.occupationLabel.textAlignment = .center
            self.heyButton.isHidden = true

//            scrollmessageLabel.isHidden = false
        } else {
            self.firstPerson = nil
            let noUsers = CardsViewData.sharedInstance.sampleUsers.first
            self.photoView.image = noUsers?.photo1
            self.dayTimeTextView.text = nil
            self.nameLabel.text = noUsers?.name
            self.occupationLabel.text = noUsers?.occupation
            self.ageDisplayedLabel.text = nil
//            self.timePicker.isHidden = true
            self.yupButton.isHidden = true
            self.nopeButton.isHidden = true
            self.nameLabel.isHidden = true
            self.occupationLabel.isHidden = true
            self.occupationLabel.textAlignment = .right
            self.heyButton.isHidden = false
//            self.scrollmessageLabel.isHidden = true
        }
        
    }
    
    
    // MARK : Actions
    // yes button
    @objc func noButton() {
        print("no button")
        
        Analytics.logEvent("photosViewed", parameters: ["numberOfPhotos" : (imageTracker + 1)])
        
        Analytics.logEvent("noButtonPressed", parameters: [
            "userID": CurrentUser.sharedInstance.userID,
            "timeBetweenSwipes": time
            ])
        timerBetweenSwipes?.invalidate()
        time = 0.0
        
        //remove the first user from the array of users to show
        if firstPerson == nil {
            let first = CardsViewData.sharedInstance.sampleUsers.first
            CardsViewData.sharedInstance.sampleUsers.append(first!)
            CardsViewData.sharedInstance.sampleUsers.removeFirst()
            self.displayUser()
        } else if firstPerson.from == "receivedOffers" {
            
            let removeFromReceivedReference = Database.database().reference().child("user").child(CurrentUser.sharedInstance.userID).child("Received Offers").child(firstPerson.userID)
            
            saveUserToViewed(userID: firstPerson.userID)
            removeFromReceivedReference.removeValue(completionBlock: {_,_ in
                self.displayUser()
            })
            CardsViewData.sharedInstance.recievedOffersFromDatabase.removeFirst()
        } else if firstPerson.from == "barMembers" {
            CardsViewData.sharedInstance.shownUsersFromDatabaseQueryArray.removeFirst()
            saveUserToViewed(userID: firstPerson.userID)
            self.displayUser()
        }
        //update which user is to be displayed
        
    }
    
    func saveUserToViewed(userID: String){
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let context = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "ViewedUser", in: context)!
        
        let newViewedUser = NSManagedObject(entity: entity, insertInto: context)
        
        newViewedUser.setValue(userID, forKey: "userID")
        
        do {
            try context.save()
            print("Saved")
        } catch {
            print("Failed saving")
        }
    }
    
    fileprivate func logAnalytics(){
        Analytics.logEvent("photosViewed", parameters: ["numberOfPhotos" : (imageTracker + 1)])
        
        Analytics.logEvent("yesButtonPressed", parameters: [
            "userID": CurrentUser.sharedInstance.userID,
            "timeBetweenSwipes": time
            ])
        timerBetweenSwipes?.invalidate()
        time = 0.0
    }
    
    fileprivate func sendNewMatchNotification(notificationPayloadArray: [String: Any]) {
        
        functions.httpsCallable("sendNewMatchNotification").call(notificationPayloadArray, completion: { (result, error) in
            if let error = error as NSError? {
                if error.domain == FunctionsErrorDomain {
                    let code = FIRFunctionsErrorCode(rawValue: error.code)
                    let message = error.localizedDescription
                    //let details = error.userInfo[FunctionsErrorDetailsKey]
                    print("Code: ", code!, "Message: ", message)
                }
                print(error)
            }
            if let text = result?.data as? [String: Any] {
                print(text)
            }
        })
    }
    
    fileprivate func uploadAcceptedOfferToUsers(currentUserPayload: [String: Any], shownUserPayload: [String: Any]) {
        let shownUserDatabaseReference = Database.database().reference().child("user").child(firstPerson.userID).child("Accepted Offers").child(CurrentUser.sharedInstance.userID)
        
        let currentUserDatabaseReference = Database.database().reference().child("user").child(CurrentUser.sharedInstance.userID).child("Accepted Offers").child(firstPerson.userID)
        
        shownUserDatabaseReference.setValue(currentUserPayload)
        currentUserDatabaseReference.setValue(shownUserPayload)
    }
    
    fileprivate func buildPayload(barPicked: String, dateFree: String, myTime: String) -> [String: Any] {
        let finalCurrentUserArray = ["Bar" : barPicked,
                                     "Day Free" : dateFree, "Time Free" : myTime] as [String : Any]
        return finalCurrentUserArray
    }
    
    fileprivate func buildPayload(barName: String, dateFree: String, myTime: String, shownUserID: String) -> [String: Any] {
        let notificationArray = ["bar": barName, "dayFree": dateFree, "timeFree": myTime, "withUser": CurrentUser.sharedInstance.userID, "toUser": shownUserID, "withUserName": CurrentUser.sharedInstance.userName]
        return notificationArray
    }
    
    fileprivate func handleUploadToDatabase(dateFree: String, barPicked: String, barName: String, myTime: String) {
        
        let payloadArray = buildPayload(barPicked: barPicked, dateFree: dateFree, myTime: myTime)
        
        uploadAcceptedOfferToUsers(currentUserPayload: payloadArray, shownUserPayload: payloadArray)
    }
    
    fileprivate func handleMatchNotification(barName: String, dateFree: String, myTime: String) {
        let notificationPayload = buildPayload(barName: barName, dateFree: dateFree, myTime: myTime, shownUserID: firstPerson.userID)
        
        sendNewMatchNotification(notificationPayloadArray: notificationPayload)
    }
    
    fileprivate func handleRemoveOfferFromDatabase(removeFromReceived: Bool?, removeFromReceiver: Bool?) {
        let removeFromReceivedReference = Database.database().reference().child("user").child(CurrentUser.sharedInstance.userID).child("Received Offers").child(firstPerson.userID)
        let removeFromReceiverReference = Database.database().reference().child("user").child(firstPerson.userID).child("Received Offers").child(CurrentUser.sharedInstance.userID)
        
        if removeFromReceiver! {
            removeFromReceiverReference.removeValue()
        }
        
        if removeFromReceived! {
            removeFromReceivedReference.removeValue()
        }
    }
    
    fileprivate func handleAcceptanceOfReceivedOffer() {

        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "hh:mm a"
        let myTime = timeFormatter.string(from: timePicker.clampedDate)
        
        if firstPerson.time == myTime {
            let dateFree = firstPerson.dayActual
            let barPicked = firstPerson.barID
            let barName = BarMaster.sharedInstance.getBarNameForID(barID: firstPerson.barID)
            
            saveUserToViewed(userID: firstPerson.userID)
            
            handleUploadToDatabase(dateFree: dateFree!, barPicked: barPicked, barName: barName, myTime: myTime)
            
            handleMatchNotification(barName: barName, dateFree: dateFree!, myTime: myTime)
            
            
            CardsViewData.sharedInstance.recievedOffersFromDatabase.removeFirst()
            
            handleRemoveOfferFromDatabase(removeFromReceived: true, removeFromReceiver: true)
            
            
            //goToThree()
            pushViewToAcceptedOffers()
            
        } else {
            
            handleRemoveOfferFromDatabase(removeFromReceived: true, removeFromReceiver: false)
            handlePushToReceivedOffers(from: self.firstPerson.from!)
            displayUser()
        }
    }
    
    fileprivate func pushViewToAcceptedOffers() {
        let loadingOverlay = LoadingOverlay()
        loadingOverlay.showOverlay(view: view)
        DispatchQueue.main.asyncAfter(deadline: .now() + Double(1.0)) {
            loadingOverlay.hideOverlayView()
            self.goToThree()
        }

    }
    
    // yes button
    @objc func yesButton() {
        print("yes button")
        //print(firstPerson.from)
        
        logAnalytics()
        
        if firstPerson == nil {
            let first = CardsViewData.sharedInstance.sampleUsers.first
            CardsViewData.sharedInstance.sampleUsers.append(first!)
            CardsViewData.sharedInstance.sampleUsers.removeFirst()
            
        } else if firstPerson.from == "barMembers" {
            
            handlePushToReceivedOffers(from: firstPerson.from!)
            
        } else if firstPerson.from == "receivedOffers"{
            
            handleAcceptanceOfReceivedOffer()
            
        }
        
    }
    
    func handlePushToReceivedOffers(from: String){
        
        let shownUserDatabaseReference = Database.database().reference().child("user").child(firstPerson.userID).child("Received Offers").child(CurrentUser.sharedInstance.userID)
        
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "hh:mm a"
        
        let time = timeFormatter.string(from: timePicker.clampedDate)
        let dateFree = firstPerson.dayActual
        let barPicked = firstPerson.barID
        
        
        
        let fianlArray = ["Bar" : barPicked,
                          "Day Free" : dateFree!, "Time Free" : time] as [String : Any]
        shownUserDatabaseReference.setValue(fianlArray)
        saveUserToViewed(userID: firstPerson.userID)
        
        if from == "barMembers" {
            CardsViewData.sharedInstance.shownUsersFromDatabaseQueryArray.removeFirst()
        } else if from == "receivedOffers" {
            CardsViewData.sharedInstance.recievedOffersFromDatabase.removeFirst()
        }
        
        displayUser()
    }
    
    // REF 5
    // UIImage Button - when this is tapped it should cycle through users images
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        var nextImageReference: StorageReference?
        
        if firstPerson != nil {
            if self.firstPerson.from == "receivedOffers" || self.firstPerson.from == "barMembers"{
                
                if self.firstPerson.imageLocations.isEmpty {
                    return
                } else {
                    if (firstPerson.imageLocations.count - 1) > (self.imageTracker){
                        nextImageReference = (firstPerson.imageLocations[self.imageTracker + 1])
                        print(firstPerson.imageLocations[self.imageTracker + 1] as Any)
                        self.imageTracker += 1
                        
                    } else if firstPerson.imageLocations.count - 1 == self.imageTracker {
                        nextImageReference = nil
                        self.imageTracker += 1
                        
                    } else {
                        nextImageReference = (firstPerson.imageLocations[0])
                        self.imageTracker = 0
                    }
                }
                
                if nextImageReference == nil {
                    firstPerson.questionsArray?.forEach({ (questionAnswerPair) in
                    
                        self.questionAnswerPairTextView.text.append("\n" + questionAnswerPair.question + "\n" + questionAnswerPair.answer! + "\n")
                    })
                    self.questionsView.isHidden = false
                } else {
                    DispatchQueue.main.async {
                        self.photoView.sd_setImage(with: nextImageReference!)
                        self.questionsView.isHidden = true
                        self.questionAnswerPairTextView.text = nil
                    }
                }
                
                print("UI Image Pressed")
            }
        
        } else {
            //logic for showing the next image is below
            questionsView.isHidden = true
            
            let noUsers = CardsViewData.sharedInstance.sampleUsers.first
            
            if imagerTrackingVariable == 1 {
                self.photoView.image = noUsers?.photo2
                print("UI Image Pressed: condiotion 1")
                imagerTrackingVariable = 2
            }
            else if imagerTrackingVariable == 2 {
                self.photoView.image = noUsers?.photo3
                print("UI Image Pressed: condiotion 2")
                imagerTrackingVariable = 0
            }
            else{
                self.photoView.image = noUsers?.photo1
                print("UI Image Pressed: condiotion 3")
                imagerTrackingVariable = 1
            }
        
        }
    }
    
    //report button function
    @objc func reportButtonSender(button: UIButton) {
        //message when the report button is pressed
        let alertController: UIAlertController = UIAlertController(title:"Report user?", message:"",  preferredStyle: .alert)
        
        let continueAction: UIAlertAction = UIAlertAction(title: "Report", style: .default) { action -> Void in
        }
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .default) { action -> Void in
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(continueAction)
        self.present(alertController, animated: true, completion: nil)

    }
    
    
    
    // MARK: Navigation
    @objc func goToOne() {
        //check if var pageController is initialized or not
        if pageController != nil
        {
            pageController!.goToPreviousVC()
        }
    }
    
    @objc func goToThree() {
        //check if var pageController is initialized or not
        if pageController != nil
        {
            pageController!.goToNextVC()
        }
    }
    
    
    

}


