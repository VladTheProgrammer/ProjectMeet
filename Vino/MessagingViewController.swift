//
//  MessagingViewController.swift
//  project18
//
//  Created by Matias Jow on 2018-02-25.
//  Copyright © 2018 Happy Hour Labs Inc. All rights reserved.
//

import UIKit
import Firebase

class MessagingViewController: UICollectionViewController, UITextFieldDelegate, UICollectionViewDelegateFlowLayout {
    
    let cellID = "cellID"
    
    lazy var inputTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter message..."
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.delegate = self
        return textField
    }()

    let imageView = UIImageView()
    
    var shownUser: ShownUser? {
        didSet {
            return
            
        }
    }
    
    lazy var functions = Functions.functions()
    
    
    var currentUser: CurrentUser?
    
    var messages = [Message]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
   
        
        
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        
        
        
        //navigationItem.title = "Messaging"
        
        //navigationItem.backBarButtonItem?.setValue("Back", forKey: title!)
        
        
        collectionView?.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        //collectionView?.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
        collectionView?.alwaysBounceVertical = true
        collectionView?.backgroundColor = UIColor.white
        collectionView?.register(ChatMessageCell.self, forCellWithReuseIdentifier: cellID)
        
        collectionView?.keyboardDismissMode = .interactive
        //setupInputComponents()
        handleMessagesDownload()
        setupKeyboardObservers()
        // Do any additional setup after loading the view.
    }
    
    func setupNavigationBar(){
        
        if let navigation = self.navigationController {
            let width = navigation.navigationBar.frame.width
            let height = navigation.navigationBar.frame.height
            
            let navView = UIView()
            navView.frame = CGRect(x: 0, y: 0, width: width, height: height)
            
            let nameLabel = UILabel()
            nameLabel.text = shownUser?.name
            nameLabel.translatesAutoresizingMaskIntoConstraints = false
            nameLabel.font = UIFont.systemFont(ofSize: 18)
            
            if (shownUser?.imageLocations.isEmpty)! {
                imageView.sd_setImage(with: CurrentUser.sharedInstance.sampleImageReference)
            } else {
                imageView.sd_setImage(with: (shownUser?.imageLocations[0])!)
            }
            
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.layer.cornerRadius = 16
            imageView.layer.masksToBounds = true
            imageView.contentMode = .scaleAspectFill
            
            
            navView.addSubview(imageView)
            navView.addSubview(nameLabel)
            
            //imageView.leftAnchor.constraint(equalTo: navView.leftAnchor, constant: 8).isActive = true
            //imageView.center = navView.center
            imageView.widthAnchor.constraint(equalToConstant: 32).isActive = true
            imageView.heightAnchor.constraint(equalToConstant: 32).isActive = true
            imageView.rightAnchor.constraint(equalTo: navView.centerXAnchor, constant: -8).isActive = true
            imageView.centerYAnchor.constraint(equalTo: navView.centerYAnchor).isActive = true
            
            nameLabel.leftAnchor.constraint(equalTo: navView.centerXAnchor).isActive = true
            nameLabel.centerYAnchor.constraint(equalTo: navView.centerYAnchor).isActive = true
            
            
            navigationItem.titleView = navView
            
        }
        
        
        
        
        
        
        
        //navView.sizeToFit()
    }
    
    

    
    lazy var inputContainerView: UIView = {
        let containerView = UIView()
        containerView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50)
        containerView.backgroundColor = UIColor.white
        
        
        let sendButton = UIButton(type: .system)
        sendButton.setTitle("Send", for: .normal)
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(sendButton)
        
        sendButton.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
        sendButton.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        sendButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        sendButton.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
        
        //containerView.addSubview(sendButton)
        
        containerView.addSubview(inputTextField)
        
        inputTextField.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 8).isActive = true
        inputTextField.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        inputTextField.rightAnchor.constraint(equalTo: sendButton.leftAnchor).isActive = true
        inputTextField.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
        
        let separatorLineView = UIView()
        separatorLineView.backgroundColor = UIColor(red: 220.0/255.0, green: 220.0/255.0, blue: 220.0/255.0, alpha: 1.0)
        separatorLineView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(separatorLineView)
        
        separatorLineView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        separatorLineView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        separatorLineView.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        separatorLineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        return containerView
    }()
    
    override var inputAccessoryView: UIView? {
        get {
            return inputContainerView
        }
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionView?.collectionViewLayout.invalidateLayout()
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if messages.isEmpty{
            return 0
        }
        return (messages.count)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! ChatMessageCell
        
        if messages.isEmpty{
            return cell
        }
        let message = messages[indexPath.item]
        cell.textView.text = message.message
        
        cell.profileImageView.image = imageView.image
        
        
       setupCell(cell: cell, message: message)
        
        cell.bubbleWidthAnchor?.constant = estimateTextHeight(text: message.message!).width + 32
        //cell.backgroundColor = UIColor.blue
        
        return cell
    }
    
    private func setupCell(cell: ChatMessageCell, message: Message){
        if message.fromID == CurrentUser.sharedInstance.userID{
            cell.bubbleView.backgroundColor = ChatMessageCell.blueColor
            cell.textView.textColor = UIColor.white
            cell.profileImageView.isHidden = true
            cell.bubbleViewRightAnchor?.isActive = true
            cell.bubbleViewLeftAnchor?.isActive = false
        } else {
            cell.bubbleView.backgroundColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1)
            cell.textView.textColor = UIColor.black
            cell.bubbleViewRightAnchor?.isActive = false
            cell.bubbleViewLeftAnchor?.isActive = true
            cell.profileImageView.isHidden = false
        }
    }
    
    private func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
    }
    
    @objc func fakeKeyboardWillShow(){
        print("Shown Keyboard Fake")
    }
    
    @objc private func handleKeyboardWillShow(notification: NSNotification){
        let keyboardFrame = (notification.userInfo![UIKeyboardFrameEndUserInfoKey] as AnyObject).cgRectValue
        let keyboardDuration = notification.userInfo![UIKeyboardAnimationDurationUserInfoKey] as! Double
        
        containerViewBottomAnchor?.constant = -keyboardFrame!.height
        
        let last = messages.count - 1
        print("Last: ", last)
        if last > 0 {
            
            Timer.scheduledTimer(withTimeInterval: keyboardDuration, repeats: false) { (timer) in
                self.collectionView?.scrollToItem(at: IndexPath(item: last, section: 0), at: .bottom, animated: true)
                timer.invalidate()
                print("Timer Fired")
            }
        }
        
        UIView.animate(withDuration: keyboardDuration) {
            self.view.layoutIfNeeded()
        }
        
    }
    
    @objc private func handleKeyboardWillHide(notification: NSNotification){
        let keyboardDuration = notification.userInfo![UIKeyboardAnimationDurationUserInfoKey] as! Double
        
        containerViewBottomAnchor?.constant = 0
        UIView.animate(withDuration: keyboardDuration) {
            self.view.layoutIfNeeded()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var height: CGFloat = 80
        
        if let text = messages[indexPath.item].message {
            height = estimateTextHeight(text: text).height + 20
        }
        
        let width = UIScreen.main.bounds.width
        return CGSize(width: width, height: height)
    }
    
    private func estimateTextHeight(text: String) -> CGRect{
        let size = CGSize(width: 200, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 16)], context: nil)
    }
    
    var containerViewBottomAnchor: NSLayoutConstraint?
    
    func setupInputComponents() {
        
        let containerView = UIView()
        
        containerView.backgroundColor = UIColor.white
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(containerView)
        
        containerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        
        
        containerViewBottomAnchor = containerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        containerViewBottomAnchor?.isActive = true
        
        
        containerView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        containerView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        let sendButton = UIButton(type: .system)
        sendButton.setTitle("Send", for: .normal)
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(sendButton)
        
        sendButton.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
        sendButton.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        sendButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        sendButton.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
        
        //containerView.addSubview(sendButton)

        containerView.addSubview(inputTextField)
        
        inputTextField.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 8).isActive = true
        inputTextField.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        inputTextField.rightAnchor.constraint(equalTo: sendButton.leftAnchor).isActive = true
        inputTextField.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
        
        let separatorLineView = UIView()
        separatorLineView.backgroundColor = UIColor(red: 220.0/255.0, green: 220.0/255.0, blue: 220.0/255.0, alpha: 1.0)
        separatorLineView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(separatorLineView)
        
        separatorLineView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        separatorLineView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        separatorLineView.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        separatorLineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        
    }

    @objc func handleSend() {
        print("Send Pressed")
        
        if (inputTextField.text?.isEmpty)! {
            return
        }
        
        let message = inputTextField.text
        //print(message)
        
        let toID = shownUser?.userID
        let fromID = CurrentUser.sharedInstance.userID
        let timeStamp: NSNumber = Date().timeIntervalSince1970 as NSNumber
        
        let messagingToReference = Database.database().reference().child("user").child(fromID).child("Messages").child(toID!).childByAutoId()
        let messagingFromReference = Database.database().reference().child("user").child(toID!).child("Messages").child(fromID).childByAutoId()
        
        let dictionary = ["toID" : toID!, "fromID" : fromID, "timeStamp" : timeStamp, "Message" : message!] as [String : Any]
        
        functions.httpsCallable("sendNewMessageNotification").call(dictionary) { (result, error) in
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
        
        messagingToReference.updateChildValues(dictionary)
        messagingFromReference.updateChildValues(dictionary)
        
        
        
        self.inputTextField.text = nil
        
    }
    
    func sendNotificationToRemoteUser(body: String, to: String){
      
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if !(textField.text?.isEmpty)! {
            handleSend()
        }
        return true
    }
    
    func handleMessagesDownload(){
        let messageReference = Database.database().reference().child("user").child(CurrentUser.sharedInstance.userID).child("Messages").child((shownUser?.userID)!)
        
        messageReference.observe(.childAdded, with: {
            snapshot in
            
            //print(snapshot)
            
            let snapValue = snapshot.value as! Dictionary<String, AnyObject>
            
            let messagesFromUser = Message(messageDictionary: snapValue)
            
            self.messages.append(messagesFromUser)

            let last = self.messages.count - 1
            
            
            
            DispatchQueue.main.async {
                self.collectionView?.reloadData()
                if last > 0 {
                    self.collectionView?.scrollToItem(at: IndexPath(item: last, section: 0), at: .bottom, animated: false)
                }
            }
        })
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        NotificationCenter.default.removeObserver(self)
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
