//
//  NeedMoreInformationViewController.swift
//  project18
//
//  Created by Vladimir Kisselev on 2018-04-16.
//  Copyright © 2018 Matias Jow. All rights reserved.
//

import Foundation
import Firebase
import FBSDKLoginKit

protocol didDismissProtocol: class {
    func presentCardsView()
}

class NeedMoreInformationViewController: UIViewController, UITextFieldDelegate {
    
    var needName: Bool? = false
    var needGender: Bool? = false
    var needAge: Bool? = false
    
    lazy var doneButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = ColorSelector.SELECTED_COLOR
        button.setTitle("Save", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 3
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(doneButtonPressed), for: .touchUpInside)
        return button
    }()
    
    lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = ColorSelector.SELECTED_COLOR
        button.setTitle("Cancel", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 3
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        return button
    }()
    
    let mainView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
   
    lazy var nameTextField: UITextField = {
        let field = UITextField()
        field.layer.borderColor = UIColor.black.cgColor
        field.layer.borderWidth = 1
        field.layer.cornerRadius = 3
        field.textColor = .black
        field.isEnabled = true
        field.isUserInteractionEnabled = true
        field.returnKeyType = .done
        field.delegate = self
        field.isHidden = true
        return field
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Name:"
        label.textColor = .black
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.backgroundColor = .clear
        label.isHidden = true
        return label
        }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Tell Us a Bit More About Yourself"
        label.textColor = .black
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.backgroundColor = .clear
        return label
    }()
    
    let genderButton: SelectionButton = {
        let button = SelectionButton()
        button.backgroundColor = .white
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 3
        button.setTitleColor(.black, for: .normal)
        button.picker.dropDownOptions = ["male", "female"]
        button.isHidden = true
        return button
    }()
    
    let genderLabel: UILabel = {
        let label = UILabel()
        label.text = "Gender:"
        label.textColor = .black
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.backgroundColor = .clear
        label.isHidden = true
        return label
    }()
    
    let ageButton: SelectionButton = {
        let button = SelectionButton()
        button.backgroundColor = .white
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 3
        button.setTitleColor(.black, for: .normal)
        var counter = 19
        var array = [String]()
        while counter < 100 {
            array.append("\(counter)")
            counter += 1
        }
        button.picker.dropDownOptions = array
        button.isHidden = true
        return button
    }()
    
    let ageLabel: UILabel = {
        let label = UILabel()
        label.text = "Age:"
        label.textColor = .black
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.backgroundColor = .clear
        label.isHidden = true
        return label
    }()
    var didDismissDelegate: didDismissProtocol?
    
    var bottomOfMainViewAnchor: NSLayoutConstraint?
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        setupKeyboardObservers()
    }
    
    
    func updateNeeds(name: Bool, gender: Bool, age: Bool){
        needAge = age
        needGender = gender
        needName = name
        
    }
    
    fileprivate func setupUI(){
        view.addSubview(mainView)

        if needAge! {
            ageButton.isHidden = false
            ageLabel.isHidden = false
        }
        if needName! {
            nameTextField.isHidden = false
            nameLabel.isHidden = false
        }
        if needGender! {
            genderButton.isHidden = false
            genderLabel.isHidden = false
        }
        
        mainView.addSubview(genderLabel)
        mainView.addSubview(nameLabel)
        mainView.addSubview(titleLabel)
        mainView.addSubview(nameTextField)
        mainView.addSubview(ageButton)
        mainView.addSubview(ageLabel)
        mainView.addSubview(genderButton)
        
        view.addSubview(doneButton)
        view.addSubview(cancelButton)
        
        bottomOfMainViewAnchor = mainView.anchor(view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: doneButton.topAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)[2]
        
        doneButton.anchorWithConstantsToTop(nil, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.centerXAnchor, topConstant: 0, leftConstant: 16, bottomConstant: 16, rightConstant: 16)
        
        cancelButton.anchorWithConstantsToTop(nil, left: view.centerXAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 16, bottomConstant: 16, rightConstant: 16)
        
        titleLabel.anchorWithConstantsToTop(mainView.topAnchor, left: mainView.leftAnchor, bottom: nil, right: mainView.rightAnchor, topConstant: 20, leftConstant: 16, bottomConstant: 0, rightConstant: 16)
        
        _ = nameTextField.anchor(titleLabel.bottomAnchor, left: mainView.leftAnchor, bottom: mainView.centerYAnchor, right: mainView.rightAnchor, topConstant: 20, leftConstant: 16, bottomConstant: 0, rightConstant: 16, widthConstant: 0, heightConstant: 35)
        nameLabel.anchorWithConstantsToTop(nil, left: mainView.leftAnchor, bottom: nameTextField.topAnchor, right: nil, topConstant: 0, leftConstant: 16, bottomConstant: 10, rightConstant: 0)
        
        _ = genderButton.anchor(genderLabel.bottomAnchor, left: mainView.leftAnchor, bottom: nil, right: mainView.rightAnchor, topConstant: 10, leftConstant: 16, bottomConstant: 0, rightConstant: 16, widthConstant: 0, heightConstant: 0)
        genderLabel.anchorWithConstantsToTop(mainView.centerYAnchor, left: mainView.leftAnchor, bottom: nil, right: nil, topConstant: 10, leftConstant: 16, bottomConstant: 0, rightConstant: 0)
        
        _ = ageButton.anchor(ageLabel.bottomAnchor, left: mainView.leftAnchor, bottom: nil, right: mainView.rightAnchor, topConstant: 10, leftConstant: 16, bottomConstant: 0, rightConstant: 16, widthConstant: 0, heightConstant: 35)
        ageLabel.anchorWithConstantsToTop(genderButton.bottomAnchor, left: mainView.leftAnchor, bottom: nil, right: nil, topConstant: 10, leftConstant: 16, bottomConstant: 0, rightConstant: 0)
    }
    
    @objc func doneButtonPressed(){
        if needName! {
            if (nameTextField.text?.isEmpty)! {
                return
            } else {
                CurrentUser.sharedInstance.userName = nameTextField.text!
                print("Loaded name: ", CurrentUser.sharedInstance.userName)
            }
        }
        if needGender! {

            if (genderButton.currentTitle?.isEmpty)! {
                return
            } else {
                CurrentUser.sharedInstance.userGender = genderButton.currentTitle!
                CurrentUser.sharedInstance.setOppositeGender(gender: CurrentUser.sharedInstance.userGender)
                print("Loaded Genders: ", CurrentUser.sharedInstance.userGender, CurrentUser.sharedInstance.oppositeGender)
                
            }
        }
        if needAge! {
            if (ageButton.currentTitle?.isEmpty)! {
                return
            } else {
                CurrentUser.sharedInstance.userAge = ageButton.currentTitle!
                print("Loaded Age: ", CurrentUser.sharedInstance.userAge)
                
            }
        }

        CurrentUser.sharedInstance.handleSaveCurrentUserToDatabase()
       
        self.dismiss(animated: true, completion: {
            self.didDismissDelegate?.presentCardsView()
        })
    }
    
    @objc func cancelButtonTapped(){
        do {
            //Revoking authorizaion token for the Database
            try Auth.auth().signOut()
            
            let fbManager = FBSDKLoginManager()
            
            fbManager.logOut()
            
            //Creating App Delegate
            let appdele = UIApplication.shared.delegate as! AppDelegate
            
            //Sennding user to "Login" page
            appdele.openauthViewController()
        } catch _ {
            // Error handling
            print("Could not log out")
        }
    }
    private func setupKeyboardObservers() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
    }
    
    @objc private func handleKeyboardWillShow(notification: NSNotification){
        let keyboardFrame = (notification.userInfo![UIKeyboardFrameEndUserInfoKey] as AnyObject).cgRectValue
        let keyboardDuration = notification.userInfo![UIKeyboardAnimationDurationUserInfoKey] as! Double
        
        bottomOfMainViewAnchor?.constant = -keyboardFrame!.height
        UIView.animate(withDuration: keyboardDuration) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc private func handleKeyboardWillHide(notification: NSNotification){
        let keyboardDuration = notification.userInfo![UIKeyboardAnimationDurationUserInfoKey] as! Double
        
        bottomOfMainViewAnchor?.constant = 0
        UIView.animate(withDuration: keyboardDuration) {
            self.view.layoutIfNeeded()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    
    
}


