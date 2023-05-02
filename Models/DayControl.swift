/*
 Day Control.swift
 Project Vino
 
 Edited by Vladimir Kisselev on 03/13/18
 Copyright © 2018 Matias Jow. All rights reserved.
 
 This class file describes the Day Control object that is used to store the "Available Days" for the current user. Contains methods for the initializer, handling day button tap, setting up the correct days as pulled from the Firebase Database, and updating days on the Database.
 */

import UIKit
import Firebase

class DayControl: UIStackView {
    
    //Array of buttons to represent Days
    private var dayButtons = [UIButton]()
    
    //Variable used to check whether the user has entered into the screen for the first time
    var firstIn = false
    
    //Variable used to track free days
    var freedays = 0 {
        didSet {
            updateDaySelectionStates()
        }
    }
    
    //Variable used to define the properties of the cell
    lazy var daySize: CGSize = {
        let size = CGSize(width: self.frame.height, height: self.frame.width)
        return size
    }()
    
    //Variable used for total day count (1 week)
    @IBInspectable var dayCount: Int = 7
    
    //Variable used to store te current users days free as an array
    //Day busy represented as 0, day free represented as 1, day of the week represented as the index location
    
    
    //MARK: Initializers
    
    
    
    //Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        //Calling the setupDays
        self.setupDays()
    }
    
    //Initializer
    required init(coder: NSCoder) {
        
        //Passing the parameter to Super
        super.init(coder: coder)
            
        
    
    }
    
    
    //Method to handle user interaction with the button
    @objc func dayButtonTapped(day: UIButton){
        
        Analytics.logEvent("daysAvailableChanged", parameters: ["userID" : CurrentUser.sharedInstance.userID])
        
        //Checking for current index(Day of week)
        guard let index = dayButtons.index(of: day) else{
            fatalError("the button, \(day), is not in the dayButtons array: \(dayButtons)")
        }
        
        //Setting the seleceted day based on user input
        let selectedDay = index + 1
        
        //setting the selected day as a free day
        freedays = selectedDay
    }
    
    
    //Method to handle the setup of free days
    @objc private func setupDays(){
        
        //Removing days from view
        for day in dayButtons {
            
            removeArrangedSubview(day)
            day.removeFromSuperview()
        }
        
        //Clearing the dayButtons Array
        dayButtons.removeAll()
        
        //Creating a bundle to hold days
        let bundle = Bundle(for: type(of:self))
        
        //Creating array for day images in "filled(Free)" state
        let filledDay = [UIImage(named: "filledMonday", in: bundle, compatibleWith: self.traitCollection), UIImage(named: "filledTuesday", in: bundle, compatibleWith: self.traitCollection), UIImage(named: "filledWednesday", in: bundle, compatibleWith: self.traitCollection), UIImage(named: "filledThursday", in: bundle, compatibleWith: self.traitCollection), UIImage(named: "filledFriday", in: bundle, compatibleWith: self.traitCollection), UIImage(named: "filledSaturday", in: bundle, compatibleWith: self.traitCollection), UIImage(named: "filledSunday", in: bundle, compatibleWith: self.traitCollection)]
        
        //Creating array for day images in "empty(Busy)" state
        let emptyDay = [UIImage(named: "emptyMonday", in: bundle, compatibleWith: self.traitCollection), UIImage(named: "emptyTuesday", in: bundle, compatibleWith: self.traitCollection), UIImage(named: "emptyWednesday", in: bundle, compatibleWith: self.traitCollection), UIImage(named: "emptyThursday", in: bundle, compatibleWith: self.traitCollection), UIImage(named: "emptyFriday", in: bundle, compatibleWith: self.traitCollection), UIImage(named: "emptySaturday", in: bundle, compatibleWith: self.traitCollection), UIImage(named: "emptySunday", in: bundle, compatibleWith: self.traitCollection)]
        
        //Variable to track the index(Day of week) to be setup
        var indexx = 0
        
        //Looping through days
        for _ in 0..<dayCount {
            
            //Creating the day button
            let day = UIButton()
            
            //Uploading the images to the individual days
            day.setImage(emptyDay[indexx], for: .normal)
            day.setImage(filledDay[indexx], for: .selected)
            
            //Creating constraints for day buttons
            day.translatesAutoresizingMaskIntoConstraints = false
            
            //Adding button to stack
            addArrangedSubview(day)
            
            day.widthAnchor.constraint(equalTo: day.heightAnchor).isActive = true
            
            //Adding action target to button
            day.addTarget(self, action: #selector(DayControl.dayButtonTapped(day:)), for: .touchUpInside)
            
            
            
            //Adding day button to the array
            dayButtons.append(day)
            
            //Incrementing position
            indexx = indexx + 1
        }
        
        //Updating the current state of buttons
        updateDaySelectionStates()
    }
    
    //Function for handling the update of current days selected
    //Uploads changed states to Firebase Database
    private func updateDaySelectionStates(){
        
        //Final days free string to upload to Database
        var finalToUpload = String()
        
        //Looping through the array of Firebase data and assigning the proper state to the button
        for (index, day) in CurrentUser.sharedInstance.userDayActualInArray.enumerated(){
            
            //If day is free
            if day == 1{
                
                //Switch the day button to selected
                dayButtons[index].isSelected = true
            }
        }
        
        //Looping through the array of buttons for current state
        for (index, day) in dayButtons.enumerated() {
            
            //Checking the current index location
            if (index == freedays - 1){
                
                //Checking if the selected day is free
                if (day.isSelected == true){
                    
                    //Switching day to un-selected(Busy) state
                    day.isSelected = false
                    
                    //Testing
                    //print("unselected")
                    
                    //Creating variable to track position
                    var counter = 0
                    
                    //Checking if there are any free days
                    if freedays < 1 {
                        
                        //Resetting counter if none
                        counter = 0
                    } else {
                        
                        //Adjusting counter position to the free day
                        counter = freedays - 1
                    }
                    
                    //Adjusting the dayActualArray to reflect the state change
                    CurrentUser.sharedInstance.userDayActualInArray[counter] = 0;
                } else {
                    
                    //Changing the state of day to selected(Free)
                    day.isSelected = true
                    
                    //Testing
                    //print("selected")
                    
                    //Creating variable to track position
                    var counter = 0
                    
                    //Checking if free days
                    if freedays < 1 {
                        
                        //Re-setting counter
                        counter = 0
                    } else {
                        
                        //Adjusting counter to the free day position
                        counter = freedays - 1
                    }
                    
                    //Adjusting the dayActualArray to reflect the state change
                    CurrentUser.sharedInstance.userDayActualInArray[counter] = 1;
                }
            }
        }
        
        //Testing
        //print("Days Selected: " + "\(freedays)")
        //print(dayActualArray)
        
        //Looping through the dayActualArray
        CurrentUser.sharedInstance.userDayActualInArray.forEach {
            int in
            
            //Converting to String for upload
            finalToUpload = finalToUpload + String(int)
        }
        
        //Checking if this is the first time that user accessed this screen
        if self.firstIn == false{
            
            //Changing the firstIn state
            self.firstIn = true
        } else {
            let value = ["DaysActual" : finalToUpload]
            let path = CurrentUser.sharedInstance.userID
            
            CurrentUser.sharedInstance.saveUserValuesToDatabase(value: value, forPath: path)
            
        }
    }
}
