//
//  AppDelegateHandlers+Extension.swift
//  project18
//
//  Created by Vladimir Kisselev on 2018-03-19.
//  Copyright © 2018 Matias Jow. All rights reserved.
//

import UIKit
import Firebase
import FBSDKCoreKit
import UserNotifications


extension AppDelegate {
    
    
    
    func handleSetupWindow(){
        
        //Assigning window to local variable
        self.window = UIWindow(frame: UIScreen.main.bounds)
        
        //Setting a background color constraint
        self.window?.backgroundColor = UIColor.white
        
        //Setting Nav Bar color
        UINavigationBar.appearance().barTintColor = ColorSelector.SELECTED_COLOR
        UINavigationBar.appearance().tintColor = UIColor.black

    }
    
    func handleSetupFirebaseApp(application: UIApplication){
        //Configuring Firebase database
        FirebaseApp.configure()
        //let currentUser = CurrentUser.sharedInstance
        Messaging.messaging().delegate = self
        
        
        
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
        
        
    }
    
    
    
    func handleSetupFacebookUserAuthentication(){
        
        
        
        //Testing
        //print(currentUser.providerData)
        

            
        if FBSDKAccessToken.current() != nil {
            
            
            
            self.openLoadingViewController(withWelcome: false)
            
           
            } else {
            
            //Opening authentication page
            self.openTutorial()
        }

    }
    
    func openTutorial(){
        let tutorial: TutorialViewController = TutorialViewController()
        self.window?.rootViewController = tutorial
        self.window?.makeKeyAndVisible()
    }
    
    func openLoadingViewController(withWelcome: Bool) {
       
        
        let loading: LoadingViewController = LoadingViewController()
        if withWelcome {
            loading.withWelcome = true
        }
        self.window?.rootViewController = loading
        self.window?.makeKeyAndVisible()
    }
    
    
    func openWelcomeViewController() {
        let welcome: WelcomeController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WelcomeController") as! WelcomeController
        self.window?.rootViewController = welcome
        self.window?.makeKeyAndVisible()
    }
    
    
    //Method to handle opening of the Auth View Controller
    func openauthViewController() {
        
        
        
        //Seperating Auth View from the page
        let auth: authViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "authViewController") as! authViewController
        
        //Setting Auth View in window root view controller
        self.window?.rootViewController = auth
        
        //Loading window
        self.window?.makeKeyAndVisible()
        
    }
    
   
    
    
    //Method to handle opening of the Page View Controller
    func openPageViewController() {
 
        //Creating a View Controller, assigning UIStoryboard
        let pager: ViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "pagercontroller") as! ViewController
        
        //Setting View Controller as Window root view controller
        self.window?.rootViewController = pager
        
        //Loading Window
        self.window?.makeKeyAndVisible()
        
    }
}


// [START ios_10_message_handling]
@available(iOS 10, *)
extension AppDelegate : UNUserNotificationCenterDelegate {
    
    // Receive displayed notifications for iOS 10 devices.
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        // Print full message.
        print(userInfo)
        
        // Change this to your preferred presentation option
        completionHandler([])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        // Print full message.
        print(userInfo)
        
        completionHandler()
    }
}
// [END ios_10_message_handling]

extension AppDelegate : MessagingDelegate {
    // [START refresh_token]
    func messaging(_ messaging: Messaging, didRefreshRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
        
        
        
        if FBSDKAccessToken.current() != nil {
            let tokenReference = Database.database().reference().child("user").child((Auth.auth().currentUser?.uid)!).child("FCMToken")
            
            tokenReference.setValue(fcmToken)
            print("token uploaded from AppDelegate screen", fcmToken)
        }
        
        // TODO: If necessary send token to application server.
        // Note: This callback is fired at each app startup and whenever a new token is generated.
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        if FBSDKAccessToken.current() != nil {
            let tokenReference = Database.database().reference().child("user").child((Auth.auth().currentUser?.uid)!).child("FCMToken")
            
            tokenReference.setValue(fcmToken)
            print("token uploaded from AppDelegate screen", fcmToken)
        }
    }
    // [END refresh_token]
    // [START ios_10_data_message]
    // Receive data messages on iOS 10+ directly from FCM (bypassing APNs) when the app is in the foreground.
    // To enable direct data messages, you can set Messaging.messaging().shouldEstablishDirectChannel to true.
    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
        print("Received data message: \(remoteMessage.appData)")
        
    }
    // [END ios_10_data_message]
}
