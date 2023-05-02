//
//  LoadingViewController.swift
//  project18
//
//  Created by Vladimir Kisselev on 2018-03-20.
//  Copyright © 2018 Matias Jow. All rights reserved.
//

import Foundation
import UIKit
import Firebase


class LoadingViewController: UIViewController, didDismissProtocol {
    
    
    let currentUser = CurrentUser.sharedInstance
    var withWelcome = false
    let logo = #imageLiteral(resourceName: "profile-header")
    let loadingOverlay = LoadingOverlay()
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupConstraints()
    
    }
    
    fileprivate func setupConstraints() {
        view.backgroundColor = ColorSelector.SELECTED_COLOR
        let imageView = UIImageView(image: logo)
        let loadingOverlayView = UIView()
        loadingOverlay.showOverlay(view: loadingOverlayView)
        let loadingView = UIView()
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        loadingOverlayView.translatesAutoresizingMaskIntoConstraints = false
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        
        loadingView.addSubview(imageView)
        loadingView.addSubview(loadingOverlayView)
        view.addSubview(loadingView)
        
        imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -100).isActive = true
        
        loadingOverlayView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loadingOverlayView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20).isActive = true
        
        
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
  
        currentUser.getCurrentUser { (sucess) in
            if sucess {
                
                self.uploadTokenToDatabase()
                
                self.loadMasterBarList()
                
                QuestionsMaster.sharedInstance.getMasterQuestionsList()
            }
        }
    }
    
    fileprivate func uploadTokenToDatabase() {
        if !(Messaging.messaging().fcmToken?.isEmpty)! {
            let tokenReference = Database.database().reference().child("user").child((Auth.auth().currentUser?.uid)!).child("FCMToken")
            
            tokenReference.setValue(Messaging.messaging().fcmToken)
            print("token uploaded from loading screen", Messaging.messaging().fcmToken!)
        }
    }
    
    fileprivate func loadMasterBarList() {
        BarMaster.sharedInstance.getMasterBarList(completionHandler: {
            self.loadCardsViewDataAndAccepted()
        })
    }
    fileprivate func loadCardsViewDataAndAccepted() {
        CardsViewData.sharedInstance.getShownUsersFromBarMember(completionHandler: {
            AcceptedOffers.sharedInstance.getAcceptedOfferAndMessages()
            CardsViewData.sharedInstance.getRecievedOffers(completionHandler: {
                print("LOADED RECIEVED OFFERS")
                print("LOADED SHOWN USERS")
                self.presentNextView()
            })
        })
    }
    
    fileprivate func presentNextView(){
        if CurrentUser.sharedInstance.userGender.isEmpty || CurrentUser.sharedInstance.userAge.isEmpty || CurrentUser.sharedInstance.userName.isEmpty {
            self.presentNeedsMoreInformation()
        } else {
            presentCardsView()
        }
    }
    
    fileprivate func presentNeedsMoreInformation(){
        let needMoreInfoView = NeedMoreInformationViewController()
        needMoreInfoView.didDismissDelegate = self
        needMoreInfoView.updateNeeds(name: CurrentUser.sharedInstance.userName.isEmpty, gender: CurrentUser.sharedInstance.userGender.isEmpty, age: CurrentUser.sharedInstance.userAge.isEmpty)
        self.present(needMoreInfoView, animated: true, completion: nil)
        
    }
    
    func presentCardsView(){
        self.loadingOverlay.hideOverlayView()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        if self.withWelcome{
            appDelegate.openWelcomeViewController()
        } else {
            appDelegate.openPageViewController()
        }
    }
}
