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
        label.center.x = (weekButton?.center.x)! - 10
        label.center.y = (weekButton?.center.y)!
        label.frame = CGRect(x: 0.0, y: 5.0, width: 6, height: 30)
        self.addSubview(label)
    }
    
    @IBAction func buttonClick(_ sender: AnyObject) {
        UIView.animate(withDuration: 0.14, delay: 0.0, options: .curveEaseOut, animations: {
            self.label.center.y = sender.center.y
            }, completion: { finished in
                let clickedButton = sender as! UIButton
                
                if(clickedButton.tag == 1){
                    let VC = sideMenuVC.mainViewController?.childViewControllers.first
                    VC!.performSegue(withIdentifier: "FeedSegue", sender: self)
                    sideMenuVC.toggleMenu()
                }else if (clickedButton.tag == 0){
                    let VC = sideMenuVC.mainViewController?.childViewControllers.first as! MMSwiftTabBarController
//                    VC!.performSegue(withIdentifier: "mainSegue", sender: self)
                    VC.updateRealmDay()
                    sideMenuVC.toggleMenu()
                }else {
                    let VC = sideMenuVC.mainViewController?.childViewControllers.first
                    VC!.performSegue(withIdentifier: "segueCalendar", sender: self)
                    sideMenuVC.toggleMenu()
                }
        })
    }
    func updateLabelPosition(_ sender: AnyObject){
        UIView.animate(withDuration: 0.14, delay: 0.0, options: .curveEaseOut, animations: {
            self.label.center.y = sender.center.y
        }, completion: { finished in
          
        })
    }

    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    

}
