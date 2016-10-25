//
//  SegueFromCalendar.swift
//  Raspisaniye
//
//  Created by Анна Товстыга on 21/10/16.
//  Copyright © 2016 rGradeStd. All rights reserved.
//

//import UIKit

//class SegueFromCalendar: UIStoryboardSegue {
//    override func perform() {
//        
//        let tabBarController = self.sourceViewController as UIViewController
//        let destinationController = self.destinationViewController as! MMSwiftTabBarController
//        
//        for view in destinationController.placeholderView.subviews as [UIView] {
//            view.removeFromSuperview()
//        }
//        
//        
//        destinationController.currentViewController = tabBarController
//       destinationController.placeholderView.addSubview(tabBarController.view)
//        
//        
//      destinationController.placeholderView.translatesAutoresizingMaskIntoConstraints = false
//       tabBarController.view.translatesAutoresizingMaskIntoConstraints = false
//
//       tabBarController.didMoveToParentViewController( destinationController)
//        
//    }
//
//}
