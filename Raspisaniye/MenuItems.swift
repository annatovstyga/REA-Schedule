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
       label.backgroundColor = UIColor.whiteColor()

    }
    
    
    func addLabel()
    {
        print(weekButton)
        label.center.x = (weekButton?.center.x)! - 10
        label.center.y = (weekButton?.center.y)!
        label.frame = CGRect(x: 0.0, y: 5.0, width: 6, height: 30)
        self.addSubview(label)
    }
    @IBAction func buttonClick(sender: AnyObject) {
        UIView.animateWithDuration(0.7, delay: 0.0, options: .CurveEaseOut, animations: {
            self.label.center.y = sender.center.y
            }, completion: { finished in
                print("Label move!")
                let clickedButton = sender as! UIButton
                if(clickedButton.tag == 1){
                print(clickedButton)
                let VC = sideMenuVC.mainViewController?.childViewControllers.first
                VC!.performSegueWithIdentifier("FeedSegue", sender: self)
                    sideMenuVC.toggleMenu()}
                else if (clickedButton.tag == 0){
                    let VC = sideMenuVC.mainViewController?.childViewControllers.first
                    VC!.performSegueWithIdentifier("mainSegue", sender: self)
                    sideMenuVC.toggleMenu()
                }
        })
    }
  

    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    

}
