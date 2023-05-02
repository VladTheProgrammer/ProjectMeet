//
//  WelcomeController.swift
//  FFBLogin
//
//  Created by Matias Jow on 1/29/18.
//  Copyright © 2018 Happy Hour Labs Inc. All rights reserved.
//https://developers.facebook.com/docs/graph-api/reference/user

//this VC is only shown the first time a user logs into the app via facebook, grabs basic profile info from their profile and saves it

//basic instructions on how to use the app
//view dependant on whether guy or girl

//matias to handle code changes

import UIKit
import Firebase
import FBSDKLoginKit
import SDWebImage
import Firebase

class WelcomeController: UIViewController ,UITextFieldDelegate{

    // to be removed - asset setup
    //these were exisiting labels in the project recieved from my developer
    //they can be found in the project i had origionally sent you
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblName: UITextField!
    @IBOutlet weak var lblFBID: UITextField!
    @IBOutlet weak var lblOccupation: UITextField!
    @IBOutlet weak var lblAge: UITextField!
    
    //current asset setup
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var okayButtonLabel: UIButton!
    


    
    override func viewWillAppear(_ animated: Bool) {
    
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 44))
        imageView.contentMode = .scaleAspectFit
        let image = UIImage(named: "profile-header")
        imageView.image = image
        
        
        // navigation bar items
        navigationItem.titleView = imageView
        okayButtonLabel.layer.cornerRadius = 3
        okayButtonLabel.layer.borderWidth = 1
        okayButtonLabel.layer.borderColor = UIColor.black.cgColor

        //self.welcomeLabel.text = "Welcome " + CurrentUser.userName!
        readData()

        okayButtonLabel.backgroundColor = ColorSelector.SELECTED_COLOR

        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
       let singletap = UITapGestureRecognizer(target: self, action: #selector(self.onTapGestureTapped(recognizer:)))
        self.view.addGestureRecognizer(singletap)


        
        // download girl/guy welcome message
        
 
    }
    
    @objc func cancelTapped()
    {
        let appdele = UIApplication.shared.delegate as! AppDelegate
        appdele.openPageViewController()
    }
    @objc func onTapGestureTapped(recognizer: UITapGestureRecognizer) {
   self.view.endEditing(true)
        
    }
    

    
    //get gender message from FIREBASE
    func readData() {
        

        
        Database.database().reference().child("loginMessage").observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            
            if CurrentUser.sharedInstance.userGender == "male" {
                let messageContent = value?["Male"] as? String ?? ""
                self.messageLabel.text = messageContent
            }
                
            else {
                let messageContent = value?["Female"] as? String ?? ""
                self.messageLabel.text = messageContent
                
            }
            self.welcomeLabel.text = "Welcome " + CurrentUser.sharedInstance.userName
            
           
            // ...
        }) { (error) in
            print(error.localizedDescription)
        }
        
    }

    
    // MARK - sender
    //Okay! button
    @IBAction func buttonLogout(_ sender: Any) {
        let appdele = UIApplication.shared.delegate as! AppDelegate
        appdele.openPageViewController()
    }
    
    
    
    // not used
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //not used
    func alertwith(message:String,alerttitle:String)
    {
        let alertController = UIAlertController(title: alerttitle, message: message, preferredStyle: .alert)
        let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(okayAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
