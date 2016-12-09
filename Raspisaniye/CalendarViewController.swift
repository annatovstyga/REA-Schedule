//
//  CalendarViewController.swift
//  Raspisaniye
//
//  Created by Анна Товстыга on 17/10/16.
//  Copyright © 2016 rGradeStd. All rights reserved.
//

import UIKit
import FSCalendar
import SwiftDate


class CalendarViewController: UIViewController,FSCalendarDataSource,FSCalendarDelegate{
    
@IBOutlet weak var calendar: FSCalendar!

    var selectedDate = DateInRegion()
    
    override func loadView() {
        
        let view = UIView(frame: UIScreen.main.bounds)
        view.backgroundColor = UIColor.groupTableViewBackground
        self.view = view
        
        let calendar = FSCalendar(frame: CGRect(x: 0, y: -30, width: self.view.bounds.width, height: 400))
      
        calendar.dataSource = self
        calendar.delegate = self
        calendar.backgroundColor = UIColor.white
        calendar.scopeGesture.isEnabled = true
        self.view.addSubview(calendar)

        calendar.firstWeekday = 2;
        calendar.locale = Locale(identifier: "ru")
        calendar.appearance.weekdayFont = UIFont(name: "Helvetica Neue", size: 11)
        

        calendar.appearance.headerTitleColor = UIColor.black
        calendar.appearance.todayColor = UIColor.lightGray
        calendar.appearance.weekdayTextColor = UIColor(red: 100/255, green: 100/255, blue:100/255, alpha: 1.0)
       
//        calendar.appearance.weekdayFont = UIFont(name: "Helvetica Neue", size: 5)
      
        calendar.appearance.headerMinimumDissolvedAlpha = 0.0

       
   }
    
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date) {
              debugPrint()
        let VC = sideMenuVC.menuViewController as! MenuViewController
        let menuItems = VC.menuItems
        menuItems?.updateLabelPosition((menuItems?.weekButton)!)
        let dateInReg = DateInRegion(absoluteDate: date)
        self.selectedDate = dateInReg
        print("select\(self.selectedDate )")
        let dsVC = sideMenuVC.mainViewController?.childViewControllers.first as! MMSwiftTabBarController
       
        if(self.selectedDate.weekday == 1) //To identify monday correctly
        {
            self.selectedDate = self.selectedDate + 1.days
        }

        dsVC.selectedDate = self.selectedDate
      print("update\(dsVC.updateRealmDay)")
        dsVC.updateRealmDay(segue:"mainSegue")

    }


    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layoutIfNeeded()

    }

    

}

