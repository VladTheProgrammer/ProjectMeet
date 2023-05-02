/*
 ColorSelector.swift
 Project Vino
 
 Created by Jow on 2018-03-10.
 Copyright © 2018 Matias Jow. All rights reserved.
 
 This structure defines the color variable that is used the app theme.
 */

import Foundation
import UIKit

struct ColorSelector {

    // store the app wide color - navigation bars and all buttons
//    static var SELECTED_COLOR = UIColor(red: 31/255, green: 136/255, blue: 201/255, alpha: 1)
    static var SELECTED_COLOR = UIColor(red: 65/255, green: 201/255, blue: 249/255, alpha: 1)
    
    // stores the color of the location/time bar in CardsVC
    static var CARDS_BAR_COLOR = UIColor(red: 31/255, green: 136/255, blue: 201/255, alpha: 1)
    
    static var BACKGROUND_COLOR = UIColor(red: 230/255, green: 249/255, blue: 255/255, alpha: 1)
    
    static var PINK_COLOR = UIColor(red: 246/255, green: 166/255, blue: 193/255, alpha: 1)
    
    static var BUTTON_COLOR = UIColor.white
    
    static var BUTTON_BORDER_COLOR = UIColor(red: 203/255, green: 202/255, blue: 202/255, alpha: 1)

}
