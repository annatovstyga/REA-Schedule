//
//  MainTableViewController.swift
//  Raspisaniye
//
//  Created by rGradeStd on 2/9/16.
//  Copyright © 2016 rGradeStd. All rights reserved.
//

import UIKit

class MainTableViewController: UITableViewController {
    
    // MARK: - Properties
    
    var currentWeek: Int = 0
    
    var week: OneWeek = OneWeek()
    var realmDay:  OneDay  = OneDay()
    var lesson: OneLesson = OneLesson()
    var realmDayToFill:Day = Day()
    
    // MARK: - View methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)

        self.tableView.estimatedRowHeight = 120
        self.tableView.rowHeight = self.view.frame.size.height / 5
        rowH = self.tableView.rowHeight
    }
    

    
    
    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.separatorInset = UIEdgeInsetsZero
        cell.layoutMargins = UIEdgeInsetsZero
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("count - \(realmDayToFill.lessons.count)")
        if(realmDayToFill.lessons.count != 0){
            
            if(realmDayToFill.lessons.count>4)
            {
                tableView.scrollEnabled = true
            }
            else
            {
                tableView.scrollEnabled = false
            }
            return (realmDayToFill.lessons.count)
        }
        else{
            return 1
            
        }
        
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if(realmDayToFill.lessons.count != 0){
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell1", forIndexPath: indexPath) as! CustomTableViewCell
        
        cell.titleCell.text = realmDayToFill.lessons[indexPath.item].discipline
        
        cell.timeCell.text = "\(realmDayToFill.lessons[indexPath.item].lessonStart!) - \(realmDayToFill.lessons[indexPath.item].lessonEnd!)"
            print("lalalal - \(realmDayToFill.lessons[indexPath.item].startWeek)")
        cell.descriptionCell.text = " | \(realmDayToFill.lessons[indexPath.item].startWeek!)-\(realmDayToFill.lessons[indexPath.item].endWeek!) неделя | "
        if((realmDayToFill.lessons[indexPath.item].lector != nil)&&(amistudent)){
            cell.descriptionCell.text?.appendContentsOf(realmDayToFill.lessons[indexPath.item].lector!)
        }
        else
        {
//                for group in realmDayToFill.lessons[indexPath.item].groups!
//                {
//                cell.descriptionCell.text?.appendContentsOf("\(group) ")
//                }
        }
        cell.placeCell.text = "Ауд. \(realmDayToFill.lessons[indexPath.item].room!) (\(realmDayToFill.lessons[indexPath.item].building!) к. \(realmDayToFill.lessons[indexPath.item].house))"
    
        return cell
        }
        else
        {
            let cell = tableView.dequeueReusableCellWithIdentifier("cell1", forIndexPath: indexPath)
            return cell
        }
    
    }
    
}
