//
//  InviteCodeViewController.swift
//  project18
//
//  Created by Matias Jow on 2018-02-25.
//  Copyright © 2018 Happy Hour Labs Inc. All rights reserved.
//

import UIKit

class InviteCodeViewController: UIViewController {

    @IBOutlet weak var doneButton: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        
        //asset UI Setup
        doneButton.layer.cornerRadius = 3
        doneButton.layer.borderWidth = 1
        doneButton.layer.borderColor = UIColor.black.cgColor
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
