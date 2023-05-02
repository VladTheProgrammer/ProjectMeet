//
//  oneViewController.swift
//  project18
//
//  Created by Matias Jow on 2017-10-19.
//  Copyright © 2018 Happy Hour Labs Inc. All rights reserved.
//

//this is the profile/setting VC (furthest left)

//to do list
//on startup: verify all the displayed info with firbase info
//-avaliable days, age, profile sync

import UIKit

import FBSDKLoginKit
import SDWebImage
import Firebase
import MessageUI
import FirebaseStorageUI
import CoreData

class oneViewController: UIViewController, MFMessageComposeViewControllerDelegate  {
    
 
    var currentProfileImage: Int?
    
    //
    // below is the setup for the UI elements on the oneViewController Page
    // In order from top of screen to bottom
    //
    
    // "This time i have time"
    let avaliableLabel: UILabel = {
        let labelView = UILabel()
        labelView.text = "I want to meet on:"
        labelView.font = UIFont.boldSystemFont(ofSize: 18)
        labelView.translatesAutoresizingMaskIntoConstraints = false
        labelView.textAlignment = .center

        return labelView
    }()
    
    let dayControl: DayControl = {
        let control = DayControl()
        control.distribution = .equalSpacing
        control.spacing = 8
        return control
    }()
    
    lazy var flushCoreDataButton: UIButton = {
        let button = UIButton()
        button.setTitle("Beta Only: Reset Viewed Users", for: .normal)
        button.backgroundColor = .red
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.cornerRadius = 3
        button.layer.borderWidth = 1
        button.setTitleColor(.black, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(flushCoreData), for: .touchUpInside)
        button.isHidden = false
        return button
    }()

    
    //daycontrol stack view setup in storyboard
 

    // "I am able to meet in this Area:"
    let areaLabel: UILabel = {
        let labelView = UILabel()
        labelView.text = "At one of these Bars:"
        labelView.font = UIFont.boldSystemFont(ofSize: 18)
        labelView.translatesAutoresizingMaskIntoConstraints = false
        labelView.textAlignment = .center
        
        return labelView
    }()
    

    // location button
    lazy var locationButton: UIButton = {
        let buttonView = UIButton()
        buttonView.setTitle("Touch to Open Bar Map", for: .normal)
        buttonView.setTitleColor(.black, for: .normal)
        buttonView.backgroundColor = ColorSelector.SELECTED_COLOR
        buttonView.layer.cornerRadius = 3
        buttonView.layer.borderWidth = 1
        buttonView.layer.borderColor = UIColor.black.cgColor
        buttonView.translatesAutoresizingMaskIntoConstraints = false
        buttonView.addTarget(self, action: #selector(btnProfileClicked), for: .touchUpInside)

        return buttonView
    }()
    
    // white background between the two black bars (behind profile photo)
    let containterBackgroundLabel: UILabel = {
        let labelView = UILabel()
        labelView.font = UIFont.boldSystemFont(ofSize: 1)
        labelView.text = "o"
        //labelView.backgroundColor = ColorSelector.BACKGROUND_COLOR
        labelView.backgroundColor = UIColor(patternImage: UIImage(named: "Background")!).withAlphaComponent(0.1)
        labelView.translatesAutoresizingMaskIntoConstraints = false
        
        return labelView
    }()
    
    // black bar abve the profilePhoto
    let blackBarAbovePhotoLabel: UILabel = {
        let labelView = UILabel()
        labelView.font = UIFont.boldSystemFont(ofSize: 1)
        labelView.backgroundColor = .black
        labelView.text = "black abel"
        labelView.translatesAutoresizingMaskIntoConstraints = false
        labelView.adjustsFontSizeToFitWidth = true
        
        return labelView
    }()
    
    // profile photo
    lazy var profilePhoto: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        imageView.layer.masksToBounds = true
        
        imageView.contentMode = .scaleAspectFill
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tapGestureRecognizer)
        
        imageView.layer.borderColor = UIColor.black.cgColor
        imageView.layer.borderWidth = 2
        return imageView
    }()
    
    // black bar below the profilePhoto
    let blackBarBelowPhotoLabel: UILabel = {
        let labelView = UILabel()
        labelView.font = UIFont.boldSystemFont(ofSize: 1)
        labelView.backgroundColor = .black
        labelView.text = "black abel"
        labelView.translatesAutoresizingMaskIntoConstraints = false
        labelView.adjustsFontSizeToFitWidth = true
        
        return labelView
    }()
    
    // name label
    let nameLabel: UILabel = {
        let labelView = UILabel()
        labelView.font = UIFont.boldSystemFont(ofSize: 32)
        labelView.translatesAutoresizingMaskIntoConstraints = false
        labelView.textAlignment = .right
        labelView.adjustsFontSizeToFitWidth = true

        return labelView
    }()
    
    // occupation label
    let occupationLabel: UILabel = {
        let labelView = UILabel()
        labelView.font = UIFont.boldSystemFont(ofSize: 15)
        labelView.numberOfLines = 3
        labelView.translatesAutoresizingMaskIntoConstraints = false
        labelView.textAlignment = .right
        
        return labelView
    }()
    
    // edit button
    lazy var editButton: UIButton = {
        let buttonView = UIButton(type: UIButtonType.system)
        buttonView.setTitle("Edit My Profile", for: .normal)
        buttonView.setTitleColor(.black, for: .normal)
        buttonView.layer.cornerRadius = 3
        buttonView.layer.borderWidth = 1
        buttonView.layer.borderColor = UIColor.black.cgColor
        //buttonView.backgroundColor = .white
        buttonView.backgroundColor = ColorSelector.SELECTED_COLOR
        buttonView.translatesAutoresizingMaskIntoConstraints = false
        buttonView.addTarget(self, action: #selector(editProfile), for: .touchUpInside)

        return buttonView
    }()
    
    //invite button
    lazy var inviteButton: UIButton = {
        let buttonView = UIButton()
        buttonView.setTitle("Invite Friends!", for: .normal)
        buttonView.setTitleColor(.black, for: .normal)
        buttonView.layer.cornerRadius = 3
        buttonView.layer.borderWidth = 1
        buttonView.layer.borderColor = UIColor.black.cgColor
        buttonView.translatesAutoresizingMaskIntoConstraints = false
        buttonView.layer.cornerRadius = 3
        buttonView.layer.borderWidth = 1
        buttonView.layer.borderColor = UIColor.black.cgColor
        buttonView.backgroundColor = .white
        buttonView.addTarget(self, action: #selector(inviteFriends), for: .touchUpInside)
        
        return buttonView
    }()
    
    lazy var questionsButton: UIButton = {
        let button = UIButton(type: UIButtonType.system)
        button.setTitle("Edit: About Me", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.layer.cornerRadius = 3
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.black.cgColor
        button.backgroundColor = ColorSelector.SELECTED_COLOR
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(goToQuestionaire), for: .touchUpInside)
        button.isHidden = true

        return button
    }()
    
    //
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        switch (result.rawValue) {
        case MessageComposeResult.cancelled.rawValue:
            print("Message was cancelled")
            self.dismiss(animated: true, completion: nil)
        case MessageComposeResult.failed.rawValue:
            print("Message failed")
            self.dismiss(animated: true, completion: nil)
        case MessageComposeResult.sent.rawValue:
            print("Message was sent")
            self.dismiss(animated: true, completion: nil)
        default:
            break;
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {

        super.viewWillAppear(animated)
        currentProfileImage = 0
        setupUI()
        //view.backgroundColor = ColorSelector.PINK_COLOR
     
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        // add subviews
        
        view.addSubview(avaliableLabel)
        view.addSubview(dayControl)
        view.addSubview(areaLabel)
        
        view.addSubview(locationButton)

        view.addSubview(inviteButton)
        
        view.addSubview(flushCoreDataButton)

        // set layout constraints
        setupLayout()
        
    }
    
    @objc func flushCoreData() {
        print("Flush Core Data")
        //delete all data
        let flushLoadingOverlay = LoadingOverlay()
        flushLoadingOverlay.activityIndicator.color = .red
        flushLoadingOverlay.showOverlay(view: view)
        view.isUserInteractionEnabled = false
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "ViewedUser")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        
        do {
            try context.execute(deleteRequest)
            try context.save()
            view.isUserInteractionEnabled = true
            flushLoadingOverlay.hideOverlayView()
            print("Successful delete of entries from CoreData")
        } catch {
            print ("There was an error on deletion from CoreData")
            view.isUserInteractionEnabled = true
            flushLoadingOverlay.hideOverlayView()
            print("Successful delete of entries from CoreData")
        }
    }
    
    // sets up navigaation bar items and profilePhoto constraints
    private func setupUI(){
        //holds the logo on the top navgation bar
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 44))
        imageView.contentMode = .scaleAspectFit
        let image = UIImage(named: "profile-header")
        imageView.image = image
        
        // navigation bar items
        navigationItem.titleView = imageView
        let rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "nav-back-button"), style: .plain, target: self, action: #selector(goToTwo))
        navigationItem.setRightBarButton(rightBarButtonItem, animated: true)
        
        //profilephoto constraints
        
        
        DispatchQueue.main.async {
            if CurrentUser.sharedInstance.imageReferencesArray.isEmpty {
                self.profilePhoto.sd_setImage(with: CurrentUser.sharedInstance.sampleImageReference)
            } else {
                self.profilePhoto.sd_setImage(with: CurrentUser.sharedInstance.imageReferencesArray[self.currentProfileImage!])
            }
            self.profilePhoto.layer.cornerRadius = self.profilePhoto.frame.size.height / 2.0
        }
        
        
       
        
        //profilePhoto.translatesAutoresizingMaskIntoConstraints = false
        
      
        nameLabel.text = CurrentUser.sharedInstance.userName
        occupationLabel.text = CurrentUser.sharedInstance.userOccupation
       
    }
    
    // sets the background
    func assignbackground(){
        let background = UIImage(named: "Background")
        
        var imageView : UIImageView!
        imageView = UIImageView(frame: view.bounds)
        imageView.contentMode =  UIViewContentMode.scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = background
        imageView.alpha = 0.1
        imageView.center = view.center
        view.addSubview(imageView)
        self.view.sendSubview(toBack: imageView)
    }
    
    
    // set layout constraints
    private func setupLayout() {
        
        // topImageContainer View is used to space the user info correctly (proilePhoto, name, ccupation, edit)
        let topImageContainerView = UIView()
        //topImageContainerView.backgroundColor = .blue
        view.addSubview(topImageContainerView)
        
        topImageContainerView.translatesAutoresizingMaskIntoConstraints = false
        topImageContainerView.bottomAnchor.constraint(equalTo: inviteButton.topAnchor).isActive = true
        //topImageContainerView.bottomAnchor.constraint(equalTo: inviteButton.topAnchor).isActive = true
        topImageContainerView.topAnchor.constraint(equalTo: locationButton.bottomAnchor).isActive = true
        topImageContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        topImageContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        

        topImageContainerView.addSubview(containterBackgroundLabel)
        topImageContainerView.addSubview(blackBarAbovePhotoLabel)
        topImageContainerView.addSubview(profilePhoto)
        topImageContainerView.addSubview(blackBarBelowPhotoLabel)
        topImageContainerView.addSubview(nameLabel)
        topImageContainerView.addSubview(occupationLabel)
        topImageContainerView.addSubview(editButton)
        topImageContainerView.addSubview(questionsButton)
        
        // layout spacing constarints below
        // in order of layout appearence from top to bottom
        blackBarAbovePhotoLabel.topAnchor.constraint(equalTo: profilePhoto.topAnchor, constant: -8).isActive = true
        blackBarAbovePhotoLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        blackBarAbovePhotoLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        //
        blackBarAbovePhotoLabel.heightAnchor.constraint(equalToConstant: 1).isActive = false
        
        _ = dayControl.anchor(avaliableLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 4, leftConstant: 16, bottomConstant: 0, rightConstant: 16, widthConstant: 0, heightConstant: 0)
        
        
        blackBarBelowPhotoLabel.bottomAnchor.constraint(equalTo: questionsButton.bottomAnchor, constant: 8).isActive = true
        blackBarBelowPhotoLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        blackBarBelowPhotoLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        //
        blackBarBelowPhotoLabel.heightAnchor.constraint(equalToConstant: 2).isActive = false

        containterBackgroundLabel.topAnchor.constraint(equalTo: profilePhoto.topAnchor, constant: -8).isActive = true
        containterBackgroundLabel.bottomAnchor.constraint(equalTo: questionsButton.bottomAnchor, constant: 8).isActive = true
        containterBackgroundLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: -8).isActive = true
        containterBackgroundLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 8).isActive = true
        
        
        profilePhoto.rightAnchor.constraint(equalTo: nameLabel.leftAnchor).isActive = true
        //profilePhoto.widthAnchor.constraint(equalTo: profilePhoto.heightAnchor).isActive = true
        profilePhoto.heightAnchor.constraint(equalTo: profilePhoto.widthAnchor).isActive = true
        profilePhoto.centerYAnchor.constraint(equalTo: topImageContainerView.centerYAnchor).isActive = true
        profilePhoto.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        
        
        avaliableLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        avaliableLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32).isActive = true
        
        
        areaLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        areaLabel.topAnchor.constraint(equalTo: dayControl.bottomAnchor, constant: 32).isActive = true
        
        
        locationButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        locationButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16).isActive = true
        locationButton.topAnchor.constraint(equalTo: areaLabel.bottomAnchor, constant: 8).isActive = true
        locationButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        nameLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16).isActive = true
        nameLabel.bottomAnchor.constraint(equalTo: occupationLabel.topAnchor, constant: 0).isActive = true
        //
        nameLabel.widthAnchor.constraint(equalToConstant: 140).isActive = true

        occupationLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16).isActive = true
        occupationLabel.bottomAnchor.constraint(equalTo: editButton.topAnchor, constant: -32).isActive = true
        //
        occupationLabel.widthAnchor.constraint(equalToConstant: 140).isActive = true
        
        editButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16).isActive = true
        editButton.bottomAnchor.constraint(equalTo: profilePhoto.bottomAnchor, constant: -10).isActive = true
        editButton.widthAnchor.constraint(equalToConstant: 120).isActive = true
        editButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        _ = questionsButton.anchor(nil, left: nil, bottom: profilePhoto.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 16, widthConstant: 120, heightConstant: 30)

        inviteButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16).isActive = true
        inviteButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        inviteButton.bottomAnchor.constraint(equalTo: flushCoreDataButton.topAnchor, constant: -16).isActive = true
        inviteButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        _ = flushCoreDataButton.anchor(nil, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, topConstant: 30, leftConstant: 16, bottomConstant: 16, rightConstant: 16, widthConstant: 0, heightConstant: 40)
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    // edit profile button - shows the ProfileVC
    @objc func editProfile() {
        if let Profile = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProfileVC") as? ProfileVC{
            let nav = UINavigationController(rootViewController: Profile)
            self.present(nav, animated: true, completion: nil)
        }
    }
   
    
    // Ref 7
    // invite friends button
    @objc func inviteFriends() {
        if(MFMessageComposeViewController.canSendText()){
            let messageVC = MFMessageComposeViewController()
            messageVC.messageComposeDelegate = self
            messageVC.body = "Can I be honest with you... I love Vino       Vinotheapp.com"
            messageVC.messageComposeDelegate = self
            
            self.present(messageVC, animated: true, completion: nil)
        } else {
            print("Cant Send")
        }
        
    }
    
    @objc func goToQuestionaire() {
        let questionsView = QuestionsViewController()
        self.present(questionsView, animated: true, completion: nil)
    }
    
    // MAP button - shows the MapViewController
    @objc func btnProfileClicked() {

        let map = self.storyboard?.instantiateViewController(withIdentifier: "MapViewController") as! MapViewController
        let nav = UINavigationController(rootViewController: map)
        self.present(nav, animated: true, completion: nil)
        
    }
    
    // User image button
    // when this is tapped it should cycle through users images
    @objc func imageTapped()
    {
        // to be updated such that it cycles through the users photos
        print("UIimage pressed")
        
        var nextReference: StorageReference?
        if CurrentUser.sharedInstance.imageReferencesArray.isEmpty {
            return
        } else {
            if (CurrentUser.sharedInstance.imageReferencesArray.count - 1) > currentProfileImage!{
                
                nextReference = CurrentUser.sharedInstance.imageReferencesArray[self.currentProfileImage! + 1]
                
                self.currentProfileImage = currentProfileImage! + 1
                print(currentProfileImage!)
                
                
            } else {
                nextReference = CurrentUser.sharedInstance.imageReferencesArray[0]
                
                self.currentProfileImage = 0
                print("something: ", currentProfileImage as Any)
                
            }
            
            DispatchQueue.main.async {
                self.profilePhoto.sd_setImage(with: nextReference!)
            }
        }
    }
    
    
    // MARK: Navigation
    @objc func goToTwo(button: UIBarButtonItem) {
        // comment by lokesh
        
        //check if var pageController is initialized or not
        if  pageController != nil
        {
            let loadingOverlay = LoadingOverlay()

            loadingOverlay.activityIndicator.color = .black
            //loadingOverlay.overlayView.backgroundColor = .black
            //loadingOverlay.overlayView.layer.borderColor = UIColor.white.cgColor
            //loadingOverlay.overlayView.layer.borderWidth = 1

            loadingOverlay.showOverlay(view: view)
            CardsViewData.sharedInstance.getShownUsersFromBarMember(completionHandler: {
                print("Got Users from Bars")
                loadingOverlay.hideOverlayView()
                pageController!.goToNextVC()
            })
        }
    }
    
    
}
