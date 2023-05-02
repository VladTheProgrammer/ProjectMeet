//
//  MatchesViewController.swift
//  project18
//
//  Created by Matias Jow on 2018-02-10.
//  Copyright © 2018 Happy Hour Labs Inc. All rights reserved.
//

// right VC

import UIKit
import Firebase


class MatchesViewController: UITableViewController, alerts, deleteUser, messaging, refreshTable {
    
    fileprivate let cellIdentifier = "MatchTableViewCell"
    
    fileprivate var timer: Timer?
    
    fileprivate lazy var functions = Functions.functions()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        handleTableReload()
        AcceptedOffers.sharedInstance.refreshDelegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        AcceptedOffers.sharedInstance.refreshDelegate = nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        setupTableView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setupTableView() {
        tableView.backgroundColor = UIColor(patternImage: UIImage(named: "Background")!).withAlphaComponent(0.1)
        
        //self.tableView.reloadData()
        tableView.register(MatchesTableViewCell.self, forCellReuseIdentifier: cellIdentifier)
    }
    
    func setupNavBar(){
        // hold the logo on the top navigation bar
        let imageView = UIImageView(frame: CGRect(x: 10, y: 0, width: 44, height: 44))
        imageView.contentMode = .scaleAspectFit
        let image = UIImage(named: "profile-header")
        imageView.image = image
        
        //Navigation bar buttons
        self.navigationItem.titleView = imageView
        let leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "nav-back-button"), style: .plain, target: self, action: #selector(goToTwo))
        self.navigationItem.setLeftBarButton(leftBarButtonItem, animated: true)
    }
    
    @objc func handleTableReload(){
        DispatchQueue.main.async {
            print("Reloaded")
            self.tableView.reloadData()
        }
    }
 
    @objc func goToTwo() {
        //check if var pageController is initialized or not
        if  pageController != nil
        {
            pageController!.goToPreviousVC()
        }
    }
    
    func presentAlert(alert: UIAlertController){
        //This is the function that'll be called from the cell
        //Here you can personalize how the alert will be displayed
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
    func goToMessages(indexPath: IndexPath) {
        let messaging = MessagingViewController(collectionViewLayout: UICollectionViewFlowLayout())
        
        let backItem = UIBarButtonItem()
        backItem.title = "Back"
        
        messaging.currentUser = CurrentUser.sharedInstance
        messaging.shownUser = AcceptedOffers.sharedInstance.acceptedOffersArray[indexPath.row]

        navigationItem.backBarButtonItem = backItem
        navigationController?.pushViewController(messaging, animated: true)

    }
    
    @objc func imageTapped(tappedGestureRecognizer: UIGestureRecognizer) {
        let touch = tappedGestureRecognizer.location(in: tableView)
        
        if let indexPath = tableView.indexPathForRow(at: touch){
            let cell = self.tableView.cellForRow(at: indexPath) as? MatchesTableViewCell

            if AcceptedOffers.sharedInstance.acceptedOffersArray.isEmpty {
                let shownUser = CardsViewData.sharedInstance.matchesnoUsers[indexPath.row]
                self.showNextImage(sampleUser: shownUser)
                DispatchQueue.main.async {
                    cell?.avatarView.image = shownUser.imageLocations?.first
                }
            } else {
                let shownUser = AcceptedOffers.sharedInstance.acceptedOffersArray[indexPath.row]
                if shownUser.imageLocations.count > 1 {
                    self.showNextImage(user: shownUser)
                    DispatchQueue.main.async {
                        cell?.avatarView.sd_setImage(with: shownUser.imageLocations.first!)
                    }
                } else {
                    return
                }
                
            }
        }
    }
}

extension MatchesViewController {
    fileprivate func showNextImage(user: ShownUser){
        if user.imageLocations.isEmpty {
            return
        } else {
            let first = user.imageLocations.first
            user.imageLocations.append(first!)
            user.imageLocations.removeFirst()
        }
    }
    
    fileprivate func showNextImage(sampleUser: User) {
        if (sampleUser.imageLocations?.isEmpty)! {
            return
        } else {
            let first = sampleUser.imageLocations?.first
            sampleUser.imageLocations?.append(first!)
            sampleUser.imageLocations?.removeFirst()
        }
    }
    
    fileprivate func showFromSampleUsers(cell: MatchesTableViewCell, indexPath: IndexPath) -> MatchesTableViewCell {
        let match = CardsViewData.sharedInstance.matchesnoUsers[indexPath.row]
        cell.dayandtimeLabel.attributedText = UserService.processDisplayText(string: match.dayandtime, fontSize: nil, fontColor: nil, fontJustify: nil, fontWeight: nil)
        cell.avatarView.image = match.imageLocations?[0]
        cell.nameLabel.attributedText = nil
        cell.messageButtonLabel.isEnabled = false
        cell.cancelButtonLabel.isEnabled = false
        return cell
    }
    
    fileprivate func showFromAcceptedUsers(cell: MatchesTableViewCell, indexPath: IndexPath) -> MatchesTableViewCell {
        let match = AcceptedOffers.sharedInstance.acceptedOffersArray[indexPath.row]
        
        let dayAndTimeString = match.dayActual! + " " + match.time! + "\n\(BarMaster.sharedInstance.getBarNameForID(barID: match.barID))"
        let nameAndOccupationText = UserService.processDisplayText(string: match.name, fontSize: 20, fontColor: nil, fontJustify: NSTextAlignment.right, fontWeight: UIFont.Weight.bold)
        nameAndOccupationText.append(UserService.processDisplayText(string: "\n" + match.occupation, fontSize: nil, fontColor: nil, fontJustify: NSTextAlignment.right, fontWeight: nil))
        
        cell.nameLabel.attributedText = nameAndOccupationText
        
        cell.dayandtimeLabel.attributedText = UserService.processDisplayText(string: dayAndTimeString, fontSize: 15, fontColor: nil, fontJustify: nil, fontWeight: nil)
        
        if match.imageLocations.isEmpty {
            cell.avatarView.sd_setImage(with: CurrentUser.sharedInstance.sampleImageReference)
        } else {
            cell.avatarView.sd_setImage(with: match.imageLocations[cell.currentImage])
        }
        
        cell.date = match.dayActual!
        cell.time = match.time!
        cell.alertsDelegate = self
        cell.messagingDelegate = self
        cell.shownUserID = match.userID
        cell.currentUserID = CurrentUser.sharedInstance.userID
        cell.currentIndex = indexPath
        cell.deleteDelegate = self
        cell.messageButtonLabel.isEnabled = true
        cell.cancelButtonLabel.isEnabled = true
        
        UserService.updateTextFont(textView: cell.nameLabel)
        UserService.updateTextFont(textView: cell.dayandtimeLabel)
        
        return cell
    }
    
    func deleteCellAtIndex(indexPath: IndexPath){
        let dictionary = ["toUser" : AcceptedOffers.sharedInstance.acceptedOffersArray[indexPath.row].userID, "withUserName" : CurrentUser.sharedInstance.userName] as [String : Any]
        
        functions.httpsCallable("dateCancelledNotification").call(dictionary) { (result, error) in
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
        }
        
        
        
        let shownUserID = AcceptedOffers.sharedInstance.acceptedOffersArray[indexPath.row].userID
        
        let currentUserAcceptedReference = Database.database().reference().child("user").child(CurrentUser.sharedInstance.userID).child("Accepted Offers").child(shownUserID)
        let shownUserAcceptedReference = Database.database().reference().child("user").child(shownUserID).child("Accepted Offers").child(CurrentUser.sharedInstance.userID)
        currentUserAcceptedReference.removeValue()
        shownUserAcceptedReference.removeValue(completionBlock: { (error, _) in
            if let error = error {
                print(error)
            }
        })
        
        
    }
}


//Tableview Data Source
extension MatchesViewController {
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if AcceptedOffers.sharedInstance.acceptedOffersArray.isEmpty{
            return CardsViewData.sharedInstance.matchesnoUsers.count
        }
        return AcceptedOffers.sharedInstance.acceptedOffersArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        var cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! MatchesTableViewCell
        
        if AcceptedOffers.sharedInstance.acceptedOffersArray.isEmpty{
            cell = showFromSampleUsers(cell: cell, indexPath: indexPath)
        } else {
            cell = showFromAcceptedUsers(cell: cell, indexPath: indexPath)
        }
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        cell.avatarView.addGestureRecognizer(tapGestureRecognizer)
        cell.selectionStyle = .none
        return cell
    }
}
