//
//  MainTableViewController.swift
//  Raspisaniye
//
//  Created by rGradeStd on 2/9/16.
//  Copyright © 2016 rGradeStd. All rights reserved.
//

import UIKit
import RealmSwift

class MainTableViewController: UITableViewController {
    
    // MARK: - Properties
    
    var currentWeek: Int = 0
    var sortedLessons:Array<Lesson>? = Array()
    var realmDayToFill:Day = Day()
    
    // MARK: - View methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(self.realmDayToFill.lessons.count != 0)
        {
            let result = self.realmDayToFill.lessons.sorted("lessonNumber")
            for lesson in result{
                sortedLessons?.append(lesson)
//                print("lesson - \(lesson.discipline) numb - \(lesson.lessonNumber)")
            }
            
        }
        self.tableView.reloadData()
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
        if((sortedLessons) != nil){
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell1", forIndexPath: indexPath) as! CustomTableViewCell
        
        cell.titleCell.text = sortedLessons?[indexPath.item].discipline
        
        cell.timeCell.text = "\((sortedLessons?[indexPath.item].lessonStart)!) - \((sortedLessons?[indexPath.item].lessonEnd)!)"
        cell.descriptionCell.text = " | \((sortedLessons?[indexPath.item].startWeek)!)-\((sortedLessons?[indexPath.item].endWeek)!) неделя | "
        if((sortedLessons?[indexPath.item].lector != nil)&&(amistudent)){
            cell.descriptionCell.text?.appendContentsOf((sortedLessons?[indexPath.item].lector!)!)
        }
        else if(true/*add check for groups*/){
//                for group in realmDayToFill.lessons[indexPath.item].groups!
//                {
//                cell.descriptionCell.text?.appendContentsOf("\(group) ")
//                }
        }
            if((sortedLessons?[indexPath.item].room) != nil){
        cell.placeCell.text = "Ауд. \((sortedLessons?[indexPath.item].room)!) (\((sortedLessons?[indexPath.item].building)!) к. \((sortedLessons![indexPath.item].house)!))"
            }else{
                cell.placeCell.text = ""
            }
    
        return cell
        }
        else
        {
            let cell = tableView.dequeueReusableCellWithIdentifier("cell1", forIndexPath: indexPath)
            return cell
        }
    
    }
    
}
