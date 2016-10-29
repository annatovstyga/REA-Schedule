//
//  MenuItems.swift
//  Raspisaniye
//
//  Created by _ on 9/7/16.
//  Copyright © 2016 rGradeStd. All rights reserved.
//

import UIKit

class MenuItems: UIView {
    @IBOutlet var weekButton: UIButton?
    @IBOutlet var mounthButton: UIButton?
    @IBOutlet var Feedback: UIButton?
    
    var label:UIView = UIView()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
       label.backgroundColor = UIColor.white

    }
    
    
    func addLabel()
    {
        print(weekButton)
        label.center.x = (weekButton?.center.x)! - 10
        label.center.y = (weekButton?.center.y)!
        label.frame = CGRect(x: 0.0, y: 5.0, width: 6, height: 30)
        self.addSubview(label)
    }
    @IBAction func buttonClick(_ sender: AnyObject) {
        UIView.animate(withDuration: 0.7, delay: 0.0, options: .curveEaseOut, animations: {
            self.label.center.y = sender.center.y
            }, completion: { finished in
                print("Label move!")
                let clickedButton = sender as! UIButton
                if(clickedButton.tag == 1){
                print(clickedButton)
                let VC = sideMenuVC.mainViewController?.childViewControllers.first
                VC!.performSegue(withIdentifier: "FeedSegue", sender: self)
                    sideMenuVC.toggleMenu()}
                else if (clickedButton.tag == 0){
                    let VC = sideMenuVC.mainViewController?.childViewControllers.first
                    VC!.performSegue(withIdentifier: "mainSegue", sender: self)
                    sideMenuVC.toggleMenu()
                }
        })
        let VC = sideMenuVC.mainViewController?.childViewControllers.first
        VC!.performSegue(withIdentifier: "segueCalendar", sender: self)
        sideMenuVC.toggleMenu()
        
//        let calendarVC = kConstantObj.SetIntialMainViewController("CalendarViewControllerID")
//    self.window?.rootViewController = calendarVC
//        if sender as! NSObject == mounthButton {
//            calendarVC.presentationMode()
//        } else {
//            calendarVC.presentationMode(.Week)
//            
//        }
    }
  

    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    

}
