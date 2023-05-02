//
//  SelectionButton.swift
//  project18
//
//  Created by Vladimir Kisselev on 2018-04-16.
//  Copyright © 2018 Matias Jow. All rights reserved.
//

import Foundation

protocol DropDownProtocol: class {
    func dropDownPressed(newLabel: String)
}
class SelectionButton: UIButton, DropDownProtocol {
    
    func dropDownPressed(newLabel: String) {
        self.setTitle(newLabel, for: .normal)
        self.dismissDropDown()
    }
    
    
    lazy var picker: PickerView = {
        let view = PickerView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.borderColor = UIColor.black.cgColor
        view.layer.borderWidth = 1
        view.backgroundColor = .white
        view.dropDownDelegate = self
        return view
    }()
    
    var height: NSLayoutConstraint?
    
    var isOpen = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    func removeBuggyConstraints() {
        NSLayoutConstraint.deactivate(picker.constraints)
        picker.removeConstraints(picker.constraints)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Could not instantiat SelectButton")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !isOpen {
            print("touches")
            presentDropDown()
        } else {
            dismissDropDown()
        }
    }
    
    func dismissDropDown() {
        self.isOpen = false
        NSLayoutConstraint.deactivate([self.height!])
        self.height?.constant = 0
        NSLayoutConstraint.activate([self.height!])
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
            self.picker.center.y -= self.picker.frame.height / 2
            self.picker.layoutIfNeeded()
        }, completion: { _ in
            self.picker.removeFromSuperview()
        })
    }
    
    func presentDropDown() {
        self.isOpen = true
        addPickerToView()
        NSLayoutConstraint.deactivate([self.height!])
        if self.picker.tableView.contentSize.height > 150 {
            self.height?.constant = 150
        } else {
            self.height?.constant = self.picker.tableView.contentSize.height
        }
        
        NSLayoutConstraint.activate([self.height!])
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
            self.picker.layoutIfNeeded()
            self.picker.center.y += self.picker.frame.height / 2
        }, completion: nil)
    }

    func addPickerToView() {
        superview?.addSubview(picker)
        
        picker.topAnchor.constraint(equalTo: bottomAnchor).isActive = true
        picker.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        picker.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        
        height = picker.heightAnchor.constraint(equalToConstant: 0)
    }
    
}
