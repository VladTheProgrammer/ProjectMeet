//
//  TutorialViewController.swift
//  project18
//
//  Created by Vladimir Kisselev on 2018-04-10.
//  Copyright © 2018 Matias Jow. All rights reserved.
//

import UIKit

class TutorialViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)

        cv.backgroundColor = ColorSelector.SELECTED_COLOR

        cv.dataSource = self
        cv.delegate = self
        cv.isPagingEnabled = true
        return cv
    }()
    
    let cellId = "tutorialCell"
    
    let welcomeCellId = "welcomeCell"
    
    let tutorialPages: [TutorialPage] = {
        
        let firstPage = TutorialPage(title: "A. Set the day you want to meet", message: "B. Set bars that are convinient to meet at", imageName: "Tutorial1")
        
        let secondPage = TutorialPage(title: "C. Scroll to Change the Time", message: "D. Start Matching... It's only one Drink", imageName: "Tutorial2")
        
        let thirdPage = TutorialPage(title: "E.  Meet!", message: "Oh, and messaging is not available until 1 hour before the date!", imageName: "Tutorial3")
        
        return [firstPage, secondPage, thirdPage]
    }()
    
    lazy var pageControl: UIPageControl = {
        let control = UIPageControl()
        control.pageIndicatorTintColor = .lightGray
        control.currentPageIndicatorTintColor = ColorSelector.BACKGROUND_COLOR
        control.numberOfPages = self.tutorialPages.count + 1
        return control
    }()
    
    lazy var skipButton: UIButton = {
    
        let button = UIButton(type: .system)
        button.setTitle("Skip", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(skipButtonPressed), for: .touchUpInside)
        return button
    }()
    
    lazy var nextButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Next", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(nextButtonPressed), for: .touchUpInside)
        return button
    }()
    
    var pageControlBottomAnchor: NSLayoutConstraint?
    var nextTopAnchor: NSLayoutConstraint?
    var skipTopAnchor: NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(collectionView)
        view.addSubview(pageControl)
        view.addSubview(skipButton)
        view.addSubview(nextButton)
        
        pageControlBottomAnchor = pageControl.anchor(nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 70, heightConstant: 50)[1]
        
        skipTopAnchor = skipButton.anchor(nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 70, heightConstant: 50)[1]
        
        nextTopAnchor = nextButton.anchor(nil, left: nil, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 70, heightConstant: 50)[0]
        
        registerCells()
        
        
        
        collectionView.anchorToTop(view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor)
    }
    
    private func registerCells(){
        collectionView.register(TutorialPageCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.register(AuthCell.self, forCellWithReuseIdentifier: welcomeCellId)
        
    }
    
    @objc func skipButtonPressed(){
        pageControl.currentPage = tutorialPages.count - 1
        nextButtonPressed()
    }
    
    @objc func nextButtonPressed(){
        if pageControl.currentPage == tutorialPages.count {
            return
        }
        
        if pageControl.currentPage == tutorialPages.count - 1 {
            moveButtons(direction: "out")
        }
        
        let indexPath = IndexPath(item: pageControl.currentPage + 1, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        pageControl.currentPage += 1
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let pageNumber = Int(targetContentOffset.pointee.x / view.frame.width)
        pageControl.currentPage = pageNumber
        
        if pageNumber == tutorialPages.count {
            moveButtons(direction: "out")
        } else {
            moveButtons(direction: "in")
        }
        

    }
    
    fileprivate func moveButtons(direction: String) {
        if direction == "in" {
            pageControlBottomAnchor?.constant = 0
            skipTopAnchor?.constant = 0
            nextTopAnchor?.constant = 0
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
                self.view.layoutIfNeeded()
            }, completion: nil)
        } else {
            pageControlBottomAnchor?.constant = 40
            skipTopAnchor?.constant = 40
            nextTopAnchor?.constant = 40
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.view.layoutIfNeeded()
            }, completion: nil)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tutorialPages.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        if indexPath.item == tutorialPages.count {
            let welcomeCell = collectionView.dequeueReusableCell(withReuseIdentifier: welcomeCellId, for: indexPath) as! AuthCell
            
            welcomeCell.authViewDelegate = self as? AuthViewProtocol
            
            return welcomeCell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! TutorialPageCell
        
        let page = tutorialPages[indexPath.item]
        
        cell.tutorialPage = page
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height)
    }
    
    func addThisViewControllerAsChild(authViewController: authViewController) {
        self.addChildViewController(authViewController);
    }
}


