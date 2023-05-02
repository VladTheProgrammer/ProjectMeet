/*
 ProfileVC.swift
 Project Vino

 Created by GOVIND on 2/7/18.
 Edited by Vladimir Kisselev on 02/28/18
 Copyright © 2018 Matias Jow. All rights reserved.
 
 This class file describes methods used by the "User Profile" screen.
 Contains functions used to pull data from Facebook, calculate years between two dates,
 summon an iOS alert screen, read data from a Database snapshot, write child data to the
 database, tableview setup used as input from the user for the "Occupation" and "About me" sections.
 Contains handlers for loading main view, cancel button tapped,
 logout tapped, did recieve memory warning, textfield(Occupation) state,
 textview(About me) state, toolbar, done with section, section cancelled,
 and textfield should return.
*/

import UIKit
import Firebase
import FBSDKLoginKit
import SDWebImage
import Firebase
import RangeSeekSlider


class AgeLabelCell: UICollectionViewCell {
    
    let ageRangeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(ageRangeLabel)
        
        ageRangeLabel.anchorToTop(topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

class TextFieldCell: UICollectionViewCell {
    
    let occupationTextField: UITextField = {
        let text = UITextField()
        text.layer.borderColor = UIColor.black.cgColor
        text.layer.borderWidth = 1
        text.backgroundColor = .white
        text.layer.cornerRadius = 3
        return text
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(occupationTextField)
        
        occupationTextField.anchorToTop(topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

class AgeRangeSliderCell: UICollectionViewCell {
    
    let ageRangeSlider: RangeSeekSlider = {
        let slider = RangeSeekSlider()

        slider.minValue = 19
        slider.maxValue = 60
        
        slider.tintColor = .black
        slider.handleDiameter = 22
        slider.handleBorderWidth = 2
        slider.step = 1.0
        
        slider.enableStep = true

        slider.selectedHandleDiameterMultiplier = 1.4
        slider.colorBetweenHandles = .black
        slider.lineHeight = 4.0
        slider.handleColor = ColorSelector.SELECTED_COLOR
        return slider
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(ageRangeSlider)
        
        ageRangeSlider.anchorToTop(topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}


/*
 Class responsible for the UI elemnts of the user inputs for "Occupation" and "About me" sections.
 This class also handles Facebook data pulls, Firebase user info, write data to Firebase.
 */
class ProfileVC: UIViewController, UICollectionViewDelegate,
UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITextFieldDelegate, RangeSeekSliderDelegate, DismissProfileEditorProtocol {
    func dismissViewController() {
        self.dismiss(animated: false, completion: nil)
    }
    

    
    //used to hold/upload the min and max age to firebase
    var minimumAgetracker = 19
    var maximumAgetracker = 100
    
    var ageRangeLabelCellID = "ageRangeLabelCell"
    var occuationTextFieldCellID = "textFieldCell"
    var ageRangeSliderCellID = "ageRangeSliderCell"
    
    
    lazy var nextButton: UIButton = {
        let button = UIButton()
        button.setTitle("Next", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 3
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.black.cgColor
        button.backgroundColor = ColorSelector.SELECTED_COLOR
        button.addTarget(self, action: #selector(nextTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var profileCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.dataSource = self
        cv.isPagingEnabled = false
        cv.keyboardDismissMode = .onDrag
        cv.backgroundColor = .white
        cv.delegate = self
        return cv
    }()
    
    lazy var profileImagesView: ProfileCollectionView = {
        let view = ProfileCollectionView()
        view.parentvc = self
        
        return view
    }()

    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }
    
    /*
     Method to load view. Handles loading initial TableView, loading UI and Navigation elements.
     Instantiates database Reference, gets Facebook user information, reads data from Firebase.
    */
    override func viewDidLoad() {
        //Passing to super
        super.viewDidLoad()
 
        
        view.addSubview(nextButton)
        view.addSubview(profileImagesView)
        view.addSubview(profileCollectionView)
        
        _ = profileImagesView.anchor(view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: view.frame.width, heightConstant: view.frame.height * 0.38)
        
        profileCollectionView.anchorWithConstantsToTop(profileImagesView.bottomAnchor, left: view.leftAnchor, bottom: nextButton.topAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 16, bottomConstant: 16, rightConstant: 16)
        
        _ = nextButton.anchor(nil, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 16, bottomConstant: 16, rightConstant: 16, widthConstant: 0, heightConstant: 40)

        assignbackground()
        
        registerCollectionViewCells()
        
        setupNavBar()

        
    }
    
    fileprivate func registerCollectionViewCells() {
        profileCollectionView.register(AgeLabelCell.self, forCellWithReuseIdentifier: ageRangeLabelCellID)
        profileCollectionView.register(TextFieldCell.self, forCellWithReuseIdentifier: occuationTextFieldCellID)
        profileCollectionView.register(AgeRangeSliderCell.self, forCellWithReuseIdentifier: ageRangeSliderCellID)
    }
    
    fileprivate func setupNavBar() {
        //navigation Bar items
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 44))
        imageView.contentMode = .scaleAspectFit
        let image = UIImage(named: "profile-header")
        imageView.image = image
        
        navigationItem.titleView = imageView
        //Adding cancel button to the left navigation slot
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel,
                                                                target: self, action: #selector(self.cancelTapped))
        
        //add in logout button - rightbarbuttonitem
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(logUserOut))
    }
    
    /*
     Method to handle events triggered on "Cancel Button" tap from user.
     Writes current data back to Firebase
     */
    
    func assignbackground(){
        let background = UIImage(named: "Background")
        
        var imageView : UIImageView!
        imageView = UIImageView(frame: view.bounds)
        imageView.contentMode =  UIViewContentMode.scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = background
        imageView.alpha = 0.15
        imageView.center = view.center
        view.addSubview(imageView)
        self.view.sendSubview(toBack: imageView)
    }
    
    
    @objc func cancelTapped() {
        self.dismiss(animated: true, completion: nil)
    }
    
 
    
    /*
     Method used to handle user tap recognition when editing with the keyboard.
     */
    @objc func onTapGestureTapped(recognizer: UITapGestureRecognizer) {
        
        self.view.endEditing(true)
    }
    
    @objc func logUserOut() {
        let alertController = UIAlertController(title: "Logout", message: "Are you sure, You want to logout?", preferredStyle: .alert)
        let noAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let okayAction = UIAlertAction(title: "Logout", style: UIAlertActionStyle.default) { (action) in
            self.logOut()
        }
        alertController.addAction(noAction)
        alertController.addAction(okayAction)
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    /*
     Action method used to handle UI "Logout Button".
     */
    @objc func nextTapped() {

        
        writeData()
        
        let questionsView = QuestionsViewController()
        questionsView.dismissDelegate = self
        self.present(questionsView, animated: true, completion: nil)

    }
    
    /*
     Method handling the "Logout" for user.
     */
    func logOut() {
        
        let reference = Database.database().reference().child("user").child(CurrentUser.sharedInstance.userID).child("DaysActual")
        
        let blankDays = "0000000"
        
        reference.setValue(blankDays)
        
        //Attempting to sign out
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
    
    /*
     Method to handle garbage collection
     */
    override func didReceiveMemoryWarning() {
    
        //Operating on super for a memory warning
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    /*
     Method used to send a UI Alert to user for the "Logout" function.
     */
    func alertwith(message:String,alerttitle:String)
    {
        let alertController = UIAlertController(title: alerttitle, message: message, preferredStyle: .alert)
        let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(okayAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
 
    

    
    /*
     Method used to write current user data to the database.
     */
    func writeData() {
        let value = ["Occupation" : CurrentUser.sharedInstance.userOccupation]
        
        let path = CurrentUser.sharedInstance.userID
        
        CurrentUser.sharedInstance.saveUserValuesToDatabase(value: value, forPath: path)
    }
    
    // MARK: CollectionViewDelegation
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.item {
        
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ageRangeLabelCellID, for: indexPath) as! AgeLabelCell
            cell.ageRangeLabel.text = "Occupation:"
            return cell
            
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: occuationTextFieldCellID, for: indexPath) as! TextFieldCell
            cell.occupationTextField.text = CurrentUser.sharedInstance.userOccupation
            cell.occupationTextField.delegate = self
            return cell
        case 2:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ageRangeLabelCellID, for: indexPath) as! AgeLabelCell
            cell.ageRangeLabel.text = "Age Range:"
            return cell
        case 3:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ageRangeSliderCellID, for: indexPath) as! AgeRangeSliderCell
            cell.ageRangeSlider.delegate = self
            cell.ageRangeSlider.selectedMinValue = CGFloat(CurrentUser.sharedInstance.userAgeMin)
            cell.ageRangeSlider.selectedMaxValue = CGFloat(CurrentUser.sharedInstance.userAgeMax)
            return cell
        default:
            break
        }
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.frame.width, height: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    


    /*
     Method used to recognize the beginning of user editing "Occupation" field.
     Returns Bool: true
     */
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        return true
    }
    
   /*
     Method used to recognize the ending of user editing "Occupation" field.
     Returns Bool: true
    */
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        
        return true
    }
    
    /*
     Method to handle the end of user input for the "Occupation" field.
     Saves user input into a local variable.
     */
    func textFieldDidEndEditing(_ textField: UITextField) {
        CurrentUser.sharedInstance.userOccupation = textField.text!
    }
    
   
    
   

    
    
    //MARK: Show Date Picker
    
    /*
     Method used to create the Toolbar for top of keyboard.
     */
    func showtoolbarFor(_ textView: UITextView){
    
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        
        //Done button
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker))
        
        //Space between buttons
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        //Cancel Button
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker))
        
        //Setting items on the toolbar
        toolbar.setItems([cancelButton,spaceButton,doneButton], animated: false)
        
        //Adding toolbar to TextView
        textView.inputAccessoryView = toolbar
    }
    
    /*
     Method used to handle the end of "Date Picker" section
     */
    @objc func donedatePicker() {
        self.view.endEditing(true)
        
        
    }
    
    /*
     Method used to handle the cancellation of "Date Picker" section
     */
    @objc func cancelDatePicker() {
        
        self.view.endEditing(true)
        //self.tblview.reloadData()
    }
    
   /*
    Method used to handle the return of TextField.
    Returns Bool: true
    */
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
    
    
    
//    // range seek slider setup
//    func rangeSeekSlider(_ slider: RangeSeekSlider, didChange minValue: CGFloat, maxValue: CGFloat) {
//        print("Standard slider updated. Min Value: \(minValue) Max Value: \(maxValue)")
//
//        if minValue > CGFloat(Int(minValue)){
//            minimumAgetracker = Int(minValue) + 1
//        } else {
//            minimumAgetracker = Int(minValue)
//        }
//
//        if maxValue > CGFloat(Int(maxValue)){
//            maximumAgetracker = Int(maxValue) + 1
//        } else {
//            maximumAgetracker = Int(maxValue)
//        }
//
//
//    }
    
    
    func didStartTouches(in slider: RangeSeekSlider) {
        print("did start touches")
    }
    
    // upload the range seek slider values to firebase once the use has changed the value
    func didEndTouches(in slider: RangeSeekSlider) {
        
        minimumAgetracker = Int(slider.selectedMinValue)
        maximumAgetracker = Int(slider.selectedMaxValue)
        print("did end touches", minimumAgetracker, maximumAgetracker)
        
        
        //firebase code here
        
        CurrentUser.sharedInstance.userAgeMin = minimumAgetracker
        CurrentUser.sharedInstance.userAgeMax = maximumAgetracker
        
        let value = ["MinimumAge": minimumAgetracker,
                     "MaximumAge": maximumAgetracker]
        let path = CurrentUser.sharedInstance.userID + "/AgeRange"
        
        CurrentUser.sharedInstance.saveUserValuesToDatabase(value: value, forPath: path)
        
    }
    
    
    
    /*
    MARK: - Navigation

    In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     Get the new view controller using segue.destinationViewController.
    Pass the selected object to the new view controller.
    }
    */
}
