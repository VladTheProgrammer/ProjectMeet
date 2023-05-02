//
//  authViewController.swift
//  project18
//
//  Created by Matias Jow on 1/30/18.
//  Copyright © 2018 Happy Hour Labs Inc. All rights reserved.
//

// facebook authentication - No changes need to be made in here

import UIKit
import FBSDKLoginKit
import Firebase

class authViewController: UIViewController {

    @IBOutlet var btnFacebook: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        
        btnFacebook.layer.cornerRadius = 3
        btnFacebook.layer.borderWidth = 2
        btnFacebook.layer.borderColor = UIColor.black.cgColor
        view.backgroundColor = ColorSelector.SELECTED_COLOR
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func facebookLoginClicked(_ sender: UIButton) {
    
        let fbLoginManager = FBSDKLoginManager()
        
        //must update permission with gender below
        fbLoginManager.logIn(withReadPermissions: ["public_profile", "email","user_birthday","user_photos"], from: self) { (result, error) in
            print(result as Any)
            if let error = error {
                 self.alertwith(message: error.localizedDescription, alerttitle: "Login error")
                return
            }
            
            guard let accessToken = FBSDKAccessToken.current() else {
                print("Failed to get access token")
                self.alertwith(message: "Failed to get access token", alerttitle: "Login error")
                return
            }
            print(accessToken.tokenString)
            let credential = FacebookAuthProvider.credential(withAccessToken: accessToken.tokenString)
             print(credential)
            // Perform login by calling Firebase APIs
            Auth.auth().signIn(with: credential, completion: { (user, error) in
                if let error = error {
                    print("Login error: \(error.localizedDescription)")
                 self.alertwith(message: error.localizedDescription, alerttitle: "Login error")
                    
                    return
                }
                
                
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                
                appDelegate.openLoadingViewController(withWelcome: false)
                
                
                
            })
        }
    }
    
    
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
