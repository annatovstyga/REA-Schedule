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
    enum `Type`: Int {
        case month = 1
        case week = 2
    }
    var selectedDate = DateInRegion()
   
    
    @IBOutlet weak var labelMonth: UILabel!
    @IBOutlet weak var calendarView: CVCalendarView!
    @IBOutlet weak var menuView: CVCalendarMenuView!
    var selectedDate = DateInRegion()
    
    
    func presentationMode() -> CalendarMode {
        
        return CalendarMode.monthView
    }
    
    
    /// Required method to implement!
    func firstWeekday() -> Weekday {
        return Weekday.monday
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        labelMonth.text = CVDate(date: NSDate()).globalDescription
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
            updatedMonthLabel.transform = CGAffineTransformMakeTranslation(0, offset)
            updatedMonthLabel.transform = CGAffineTransformMakeScale(1, 0.1)
    
    UIView.animateWithDuration(0.35, delay: 0, options: UIViewAnimationOptions.CurveEaseIn, animations: {
            
            self.animationFinished = false
            self.labelMonth.transform = CGAffineTransformMakeTranslation(0, -offset)
            self.labelMonth.transform = CGAffineTransformMakeScale(1, 0.1)
            self.labelMonth.transform = CGAffineTransformMakeScale(1, 0.1)
            self.labelMonth.alpha = 0
                
                updatedMonthLabel.alpha = 1
                updatedMonthLabel.transform = CGAffineTransformIdentity
                
            }) { _ in
                
            self.animationFinished = true
            self.labelMonth.frame = updatedMonthLabel.frame
            self.labelMonth.text = updatedMonthLabel.text
            self.labelMonth.transform = CGAffineTransformIdentity
            self.labelMonth.alpha = 1
                updatedMonthLabel.removeFromSuperview()
            }
            
            self.view.insertSubview(updatedMonthLabel, aboveSubview: self.labelMonth)
        }
    }
   

    func shouldAutoSelectDayOnMonthChange() -> Bool {
       return false
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        menuView.commitMenuViewUpdate()
        calendarView.commitCalendarViewUpdate()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

   
    //func togglePresentedDate(date: NSDate) {
 
    //presentedDate = calendarView.coordinator.selectedDayView?.date
    
    //}
    var  selectedDate_: CVDate?
  
    func togglePresentedDate(date: NSDate) {
        let presentedDate = Date(date: date)
        guard
            selectedDate_ == calendarView.coordinator.selectedDayView?.date else {
                return
        }


    func didSelectDayView(dayView: DayView, animationDidFinish: Bool) {

//guard
//        var  nextController  = storyboard?.instantiateViewControllerWithIdentifier("mainTabBar") as! MMSwiftTabBarController
//        let navigationController = self.navigationController
//        else {
//            return
//        }
//        nextController.selectedDate = DateInRegion()
//        navigationController.pushViewController(nextController, animated: true)
        
//            print(sideMenuVC.mainViewController?.childViewControllers.first)
        let regionRome = Region.Local()
//        Region(calendarName: .Current , timeZoneName: TimeZoneName.europeMoscow, localeName: LocaleName.russian)
        let dateInReg = DateInRegion(absoluteDate: dayView.date.convertedDate()!)
        self.selectedDate = dateInReg
        let dsVC = sideMenuVC.mainViewController?.childViewControllers.first as! MMSwiftTabBarController
        dsVC.selectedDate = self.selectedDate
        dsVC.updateRealmDay()
    }

}
}

