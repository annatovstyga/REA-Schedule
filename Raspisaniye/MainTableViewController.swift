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
    var sortedLessons:Array<Lesson>? = Array()
    var realmDayToFill:Day = Day()
    var type :Int?
    
    // MARK: - View methods
    override func viewDidLoad() {
        super.viewDidLoad()

        if(self.realmDayToFill.lessons.count != 0)//сортировка по времени урока
        {
            let result = self.realmDayToFill.lessons.sorted(byProperty: "lessonNumber")
            for lesson in result{
                sortedLessons?.append(lesson)
            }
            
        }
        self.tableView.reloadData()
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        self.tableView.estimatedRowHeight = 120
        self.tableView.rowHeight = self.view.bounds.size.height / 4
        rowH = self.tableView.rowHeight
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        //FIXIT sorted lessons?
        if(realmDayToFill.lessons.count != 0){
            
            if(realmDayToFill.lessons.count>4)
            {
                tableView.isScrollEnabled = true
            }
            else
            {
                tableView.isScrollEnabled = false
            }
            return (realmDayToFill.lessons.count)
        }
        else{
            return 0
            
        }
        
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (self.view.bounds.size.height / 4)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if((sortedLessons) != nil){
            
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath) as! CustomTableViewCell
        
            cell.titleCell?.text = sortedLessons?[indexPath.item].discipline
            
            if sortedLessons?[indexPath.item].discipline != nil {
                cell.titleCell?.text = sortedLessons?[indexPath.item].discipline
                
                } else {
                cell.titleCell?.text = ""
            }
            
            cell.timeCell.text = "\((sortedLessons?[indexPath.item].lessonStart)!) - \((sortedLessons?[indexPath.item].lessonEnd)!)"
            if (sortedLessons?[indexPath.item].lessonStart != nil) && (sortedLessons?[indexPath.item].lessonEnd != nil){
                cell.timeCell.text = "\((sortedLessons?[indexPath.item].lessonStart)!) - \((sortedLessons?[indexPath.item].lessonEnd)!)"
                
            } else {
                cell.timeCell?.text = ""
                
            }
            
        
                cell.descriptionCell.text = " | \((sortedLessons?[indexPath.item].startWeek)!)-\((sortedLessons?[indexPath.item].endWeek)!) неделя | "
            
            if sortedLessons?[indexPath.item].startWeek != nil && sortedLessons?[indexPath.item].endWeek != nil {
                cell.descriptionCell.text = " | \((sortedLessons?[indexPath.item].startWeek)!)-\((sortedLessons?[indexPath.item].endWeek)!) неделя | "
            } else {
                
                cell.descriptionCell?.text = ""
                
            }
            
            if((sortedLessons?[indexPath.item].lector != nil)&&(amistudent)&&(type != 1)){
                
                cell.descriptionCell.text?.append((sortedLessons?[indexPath.item].lector!)!)
                
            }
                
            else if(true/*add check for groups*/){
                
                
    //                for group in realmDayToFill.lessons[indexPath.item].groups!
    //                {
    //                cell.descriptionCell.text?.appendContentsOf("\(group) ")
    //                }
    
 }
            if (amistudent == true)&&(type == 1) {
                cell.descriptionCell.text?.append((sortedLessons?[indexPath.item].groups)!)
            }
            
            if((sortedLessons?[indexPath.item].groups != nil) && (!amistudent)){
            cell.descriptionCell.text?.append((sortedLessons?[indexPath.item].groups)!)

        }
            if((sortedLessons?[indexPath.item].room) != nil)&&( sortedLessons?[indexPath.item].building != nil)&&( sortedLessons?[indexPath.item].house != nil){
        cell.placeCell.text = "Ауд. \((sortedLessons?[indexPath.item].room)!) (\((sortedLessons?[indexPath.item].building)!) к. \((sortedLessons![indexPath.item].house)))"
            }else{
                cell.placeCell.text = ""
            }
            
        return cell
        }
            
        else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath)
            return cell
        }
    
    }
    
}
