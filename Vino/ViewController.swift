/*
 ViewController.swift
 Project Vino
 
 Created by Matias Jow on 2017-10-18.
 Edited by Vladimir Kisselev on 03/13/08
 Copyright © 2018 Matias Jow. All rights reserved.
 
 This class file describes an object of type View Controller.
 */

import UIKit

//i believe the issue is that the pageController variable is outside the viewcontroller class
//this is where the transition style is declared


//add a optional variable of pagerclass and do not initialize here as we need reference of current pager
// use of uiviewcontroller instead of UIPageViewController in storyboard caused the issue
// declaration outside of class make this pagecontroller global in scope
var pageController :ViewController?

class ViewController: UIPageViewController , UIPageViewControllerDelegate{

    //Variable use to store current index location
    var currentIndex = 1
    
    //Variable used to store scroll functionality
    //var userscroll = true
    
    //Creating a UIViewController (One View Controller)
    let oneVC: UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "oneViewController")
    
    //Creating a UIViewController ()
    let twoVC: UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "twoViewController")
    
    //Creating a UIViewController ()
    let threeVC: UIViewController! = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "threeViewController")
    
    
    
    //Method to handle viewDidLoad
    override func viewDidLoad() {
        
        //Passing to Super
        super.viewDidLoad()
        
        //Assigning a Background Color constraint to view
        view.backgroundColor = UIColor.white
        
        //Assigning a Data source delegate as self
        //self.dataSource = self
        
        //Assigning a delegate as self
        self.delegate = self
        
//        //Loopiung through sub-views
//        for view in self.view.subviews {
//
//            //Checking if view will conform to UIScrollView
//            if let scrollView = view as? UIScrollView {
//
//                //Assigning a scroll view delegate as self
//                scrollView.delegate = self
//            }
//        }
        
        //Assigning ViewController to pageController variable
        pageController = self
        
        //Setting Background Color constraints on view
        view.backgroundColor = UIColor.white
        
        //Setting view controller
        setViewControllers([twoVC], direction: .forward, animated: true, completion: nil)
    }
   
//    //Method to handle viewDidScroll
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//
//        //Checking if userScroll is enabled
//        if userscroll {
//
//            //Checking current index(Left)
//            if currentIndex == 0 && scrollView.contentOffset.x < scrollView.bounds.size.width {
//
//                //Setting offset for scrollView
//                scrollView.contentOffset = CGPoint(x: scrollView.bounds.size.width, y: 0)
//
//            //Checking current index(Right)
//            } else if currentIndex == 2 && scrollView.contentOffset.x > scrollView.bounds.size.width {
//
//                //Setting offset for scrollView
//                scrollView.contentOffset = CGPoint(x: scrollView.bounds.size.width, y: 0)
//            }
//        }
//    }
//
//    //Method to handle scroll view will end dragging state
//    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
//
//        //Checking if userScroll is enabled
//        if userscroll {
//
//            //Checking current index(Left)
//            if currentIndex == 0 && scrollView.contentOffset.x < scrollView.bounds.size.width {
//
//                //Setting scrollView offset
//                scrollView.contentOffset = CGPoint(x: scrollView.bounds.size.width, y: 0)
//
//            //Checking current index (Right)
//            } else if currentIndex == 2 && scrollView.contentOffset.x > scrollView.bounds.size.width {
//
//                //Setting scrollView offset
//                scrollView.contentOffset = CGPoint(x: scrollView.bounds.size.width, y: 0)
//            }
//        }
//    }
    
    //Method to handle page view controller did finish animating state
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        //Checking for completion
        if completed {
            
            //Setting new view controller
            guard let viewController = pageViewController.viewControllers?.first,let index = [oneVC,twoVC,threeVC].index(of: viewController) else {
                    fatalError("Can't prevent bounce if there's not an index")
            }
            
            //Updating current index with the new page index
            currentIndex = index
            
            //Setting the scroll to true
            //userscroll = true
        }
    }
   
    // Method to handle a right swipe
    func goToNextVC() {
        
        //Assigning false to userScroll
        //userscroll = false
        
        //Assigning the next controller to nextVC
        guard let nextVC = pageViewController(self, viewControllerAfter: viewControllers![0] )else {
            return
        }
     
        //Setting the new view controller
        setViewControllers([nextVC], direction: .forward, animated: true, completion: nil)
    }
    
    //Method to handle a left swipe
    func goToPreviousVC() {
        
        //Assign false to userScroll
        //userscroll = false
        
        //Assigning the next controller to previousVC
        guard let previousVC = pageViewController(self, viewControllerBefore: viewControllers![0] )else {
            return
        }
       
        //Setting the new view controller
        setViewControllers([previousVC], direction: .reverse, animated: true, completion: nil)
    }
    
    
    //Method to handle the correct view controller on right swipe
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        //Checking for condition and returning controller
        switch viewController {
        case oneVC:
            return twoVC
        case twoVC:
            return threeVC
        case threeVC:
            return nil
        default:
            return nil
        }
    }
    
    //Method to handle the correct view controller on left swipe
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        //Checking for condition and returning controller
        switch viewController {
        case oneVC:
            return nil
        case twoVC:
            return oneVC
        case threeVC:
            return twoVC
        default:
            return nil
        }
    }
    
    //Function for garbage collection
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}


