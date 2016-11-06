//
//  CalendarViewController.swift
//  Raspisaniye
//
//  Created by Анна Товстыга on 17/10/16.
//  Copyright © 2016 rGradeStd. All rights reserved.
//

import UIKit
import CVCalendar
import SwiftDate


class CalendarViewController: UIViewController,CVCalendarViewDelegate, CVCalendarMenuViewDelegate{

    var selectedDate = DateInRegion()
    
    @IBOutlet weak var labelMonth: UILabel!
    @IBOutlet weak var calendarView: CVCalendarView!
    @IBOutlet weak var menuView: CVCalendarMenuView!
    var  selectedDate_: CVDate?
    
    func presentationMode() -> CalendarMode {
        return CalendarMode.monthView
    }
    
    func firstWeekday() -> Weekday {
        return Weekday.monday
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        menuView.commitMenuViewUpdate()
        calendarView.commitCalendarViewUpdate()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layoutIfNeeded()
        labelMonth.text = CVDate(date: NSDate() as Date).globalDescription
        
        calendarView.calendarAppearanceDelegate = self
        calendarView.animatorDelegate = self
        menuView.menuViewDelegate = self
        calendarView.calendarDelegate = self
    
        
    }

       

    var presentedDate:Date!
    var animationFinished = true
    func presentedDateUpdated(_ date: CVDate) {
        
        if labelMonth.text != date.globalDescription && self.animationFinished {
            let updatedMonthLabel = UILabel()
            
            updatedMonthLabel.textColor = labelMonth.textColor
            updatedMonthLabel.font = labelMonth.font
            updatedMonthLabel.text = date.globalDescription
            updatedMonthLabel.sizeToFit()
            updatedMonthLabel.alpha = 0
            updatedMonthLabel.center = self.labelMonth.center
            
            let offset = CGFloat(48)
            updatedMonthLabel.transform = CGAffineTransform(translationX: 0, y: offset)
            updatedMonthLabel.transform = CGAffineTransform(scaleX: 1, y: 0.1)
    
    UIView.animate(withDuration: 0.35, delay: 0, options: UIViewAnimationOptions.curveEaseIn, animations: {
            
            self.animationFinished = false
            self.labelMonth.transform = CGAffineTransform(translationX: 0, y: -offset)
            self.labelMonth.transform = CGAffineTransform(scaleX: 1, y: 0.1)
            self.labelMonth.transform = CGAffineTransform(scaleX: 1, y: 0.1)
            self.labelMonth.alpha = 0
                
                updatedMonthLabel.alpha = 1
                updatedMonthLabel.transform = CGAffineTransform.identity
                
            }) { _ in
                
            self.animationFinished = true
            self.labelMonth.frame = updatedMonthLabel.frame
            self.labelMonth.text = updatedMonthLabel.text
            self.labelMonth.transform = CGAffineTransform.identity
            self.labelMonth.alpha = 1
                updatedMonthLabel.removeFromSuperview()
            }
            
            self.view.insertSubview(updatedMonthLabel, aboveSubview: self.labelMonth)
        }
    }
   

    func shouldAutoSelectDayOnMonthChange() -> Bool {
       return false
    }

    
    func togglePresentedDate(date: NSDate) {
        guard selectedDate_ == calendarView.coordinator.selectedDayView?.date else {
                return
        }
        
    }
    
    func didSelectDayView(_ dayView: DayView, animationDidFinish: Bool) {
        debugPrint()
        let VC = sideMenuVC.menuViewController as! MenuViewController
        let menuItems = VC.menuItems
        menuItems?.updateLabelPosition((menuItems?.weekButton)!)
        let dateInReg = DateInRegion(absoluteDate: dayView.date.convertedDate()!)
        self.selectedDate = dateInReg
        let dsVC = sideMenuVC.mainViewController?.childViewControllers.first as! MMSwiftTabBarController
        if(self.selectedDate.weekday == 1) //To identify monday correctly
        {
            self.selectedDate = self.selectedDate + 1.days
        }

        dsVC.selectedDate = self.selectedDate
        dsVC.updateRealmDay()


    }
}

