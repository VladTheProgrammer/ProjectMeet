//
//  PageViewController.swift
//  PageControl
//
//  Created by Matias Jow on 2/2/17.
//  Copyright © 2018 Happy Hour Labs Inc. All rights reserved.
//

//this VC handles the chnages in ViewControllers?, no changes should be needed here


import UIKit



class PageViewController: UIPageViewController, UIPageViewControllerDelegate {

    
    
    // MARK: UIPageViewControllerDataSource
    
    lazy var orderedViewControllers: [UIViewController] = {
        return [self.newVc(viewController: "oneViewController"),
                self.newVc(viewController: "CardViewController"),
                self.newVc(viewController: "MatchesViewController")]
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        //self.dataSource = self
        self.delegate = self
        
        view.backgroundColor = UIColor.white
        if let firstViewController = orderedViewControllers.first {
            setViewControllers([firstViewController],
                                    direction: .forward,
                                    animated: true,
                                    completion: nil)
            
        }
        
        
        
        
        
        
        
        // This sets up the first view that will show up on our page control
        
        
        
        // Do any additional setup after loading the view.
    }

    
    func newVc(viewController: String) -> UIViewController {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: viewController)
    }
    
    
    // MARK: Delegate methords
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
      
    }
    
    // MARK: Data source functions.
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.index(of: viewController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        
        // User is on the first view controller and swiped left to loop to
        // the last view controller.
        guard previousIndex >= 0 else {
            return orderedViewControllers.last
            // Uncommment the line below, remove the line above if you don't want the page control to loop.
            // return nil
        }
        
        guard orderedViewControllers.count > previousIndex else {
            return nil
        }
        
        return orderedViewControllers[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.index(of: viewController) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        let orderedViewControllersCount = orderedViewControllers.count
        
        // User is on the last view controller and swiped right to loop to
        // the first view controller.
        guard orderedViewControllersCount != nextIndex else {
            return orderedViewControllers.first
            // Uncommment the line below, remove the line above if you don't want the page control to loop.
            // return nil
        }
        
        guard orderedViewControllersCount > nextIndex else {
            return nil
        }
        
        return orderedViewControllers[nextIndex]
    }
    

}
