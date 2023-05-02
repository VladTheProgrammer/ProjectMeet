//
//  AuthCell.swift
//  project18
//
//  Created by Vladimir Kisselev on 2018-04-10.
//  Copyright © 2018 Matias Jow. All rights reserved.
//

import UIKit

protocol AuthViewProtocol: class {
    func addThisViewControllerAsChild(authViewController: authViewController)
}

class AuthCell: UICollectionViewCell {
    
    var authController = authViewController()
    
    let container = UIView()
    
    weak var authViewDelegate: AuthViewProtocol?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        if self.authViewDelegate != nil {
            self.authViewDelegate?.addThisViewControllerAsChild(authViewController: authController)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    fileprivate func setupViews() {
        print("Awake call from cell")
        // Initialization code
        
        backgroundColor = ColorSelector.SELECTED_COLOR
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        authController = (storyboard.instantiateViewController(withIdentifier: "authViewController") as? authViewController)!
        authController.view.frame = container.bounds
        container.addSubview((authController.view)!)
        
        addSubview(container)
        
        container.anchorToTop(topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(Coder) has not been implemented")
    }
}
