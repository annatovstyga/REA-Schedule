import UIKit
import SwiftyJSON
import SwiftSpinner
import RealmSwift
import SwiftDate

class MMSwiftTabBarController: UIViewController,UITextFieldDelegate{
    
    // MARK: Propiertes
    
    @IBOutlet weak var tabBarView: UIView!
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var weekLabel: UILabel!
    @IBOutlet var placeholderView: UIView!
    @IBOutlet var tabBarButtons: Array<UIButton>!
    var currentViewController: UIViewController?
    @IBOutlet weak var subjectNameLabel: UILabel!
    

    
    let realm = try! Realm()
    var todayDay = getDayOfWeek()!
    var SundayExtended:Bool? = false
    var tabBarFixedIndex:Int? = 1
    var weekNumberTab:Int? = 1
    var selectedDay:Int? = getDayOfWeek()!
    var week: OneWeek = OneWeek()
    var day:  OneDay  = OneDay()
    var lesson: OneLesson = OneLesson()
    var realmDay:Day = Day()
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func searchClick(sender: AnyObject) {
//TODO delete
    }
    
    
    // MARK: ViewDidLoad
    override func viewDidLoad() {
        let start = "2016-09-01"
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let predicate = NSPredicate(format: "date = %@", "04.09.2015")
        let DaysFromRealmWithFilter = realm.objects(Day.self).filter(predicate)
        if(DaysFromRealmWithFilter.count != 0){
        realmDay = DaysFromRealmWithFilter.first!
        }
        let startDate:NSDate = dateFormatter.dateFromString(start)!
        datesForCurrentWeek()
        print("first of September \(startDate)")
        print(Realm.Configuration.defaultConfiguration.fileURL!)
       self.modalTransitionStyle = .PartialCurl
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
                            isLogined = defaults.objectForKey("isLogined") as? Bool ?? Bool()
        
        
                            if(isLogined ==  false) {
                                let appDelegate = UIApplication.sharedApplication().delegate! as! AppDelegate
                                let initialViewController = self.storyboard!.instantiateViewControllerWithIdentifier("LoginViewOneControllerID")
                                appDelegate.window?.rootViewController = initialViewController
                                appDelegate.window?.makeKeyAndVisible()
                            }
        
//        self.navigationItem.title = " "
//        self.navigationController?.navigationItem.backBarButtonItem?.tintColor = UIColor.whiteColor()
//        dispatch_async(dispatch_get_main_queue(), {
//            parse(jsonDataList!,successBlock:
//                {
//                    successBlock in
//                    totalSchedule = successBlock //!
//                    
//                    
//                    let screenForwardEdgeRecognizer: UISwipeGestureRecognizer! = UISwipeGestureRecognizer(target: self, action: #selector(MMSwiftTabBarController.rotateWeekForward(_:)))
//                    screenForwardEdgeRecognizer.direction = .Left
//                    let screenBackwardEdgeRecognizer: UISwipeGestureRecognizer! = UISwipeGestureRecognizer(target: self, action: #selector(MMSwiftTabBarController.rotateWeekBackward(_:)))
//                    screenBackwardEdgeRecognizer.direction = .Right
//                    self.view.addGestureRecognizer(screenForwardEdgeRecognizer)
//                    self.view.addGestureRecognizer(screenBackwardEdgeRecognizer)
//                    

//                    else{
//                        var schedule = self.realm.objects(Schedule)
//                        
//                        if(schedule.count > 0)
//                        {
//                            self.weekNumberTab = getWeekNumber()
//                            weekNumber = totalSchedule[self.weekNumberTab! - 1].number!
//                            
//                            self.weekLabel.text = "Неделя \(String(weekNumber))"
//                            
//                            self.subjectNameLabel.text = defaults.valueForKey("subjectName") as? String ?? ""
//                            self.updateScheduleProperties(self.todayDay)
//                            if(self.day.lessons?.count != 0){
//                       
//                                    self.performSegueWithIdentifier("mainSegue", sender: self.tabBarButtons[self.todayDay])
//                                  
//                                
//                            }
//                            else
//                            {
//                                self.performSegueWithIdentifier("voidLessons", sender: self.tabBarButtons[self.todayDay])
//                            }
//
//                        }
//                        
//                    }
//            })
//            
//        })
        super.viewDidLoad()
        
        
    }
    
    // MARK: IBActions - buttons
    
   
    @IBAction func profileClick(sender: AnyObject) {
        sideMenuVC.toggleMenu()
    }
//    func countDays (){
//        if (selectedDay == todayDay){
//            self.storyboard?.instantiateViewControllerWithIdentifier("MMSwiftTabBarControllerID")
//        }
//    }
   
    
    @IBAction func monClick(sender: AnyObject) {
        
        if(selectedDate.weekday > 2)
        {
            let weekday = selectedDate.weekday
            let toMinus = weekday - 2
            selectedDate = selectedDate - toMinus.days
            print(selectedDate)
        }
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateInFormat = selectedDate.toString()
        let predicate = NSPredicate(format: "date = %@", "04.09.2015")
        let DaysFromRealmWithFilter = realm.objects(Day.self).filter(predicate)
        realmDay = DaysFromRealmWithFilter.first!
        print("realm2 - \(self.realmDay.date)")
        if(self.day.lessons?.count != 0){
            performSegueWithIdentifier("mainSegue", sender: tabBarButtons[selectedDay!])
        }
        else
        {
            performSegueWithIdentifier("voidLessons", sender: tabBarButtons[selectedDay!])
        }
    }
    @IBAction func TueClick(sender: AnyObject) {

        if(selectedDate.weekday > 3)
        {
            let weekday = selectedDate.weekday
            let toMinus = weekday - 3
            selectedDate = selectedDate - toMinus.days
            print(selectedDate)
        }
        if (selectedDate.weekday < 3) {
            let weekday = selectedDate.weekday
            let toPlus = 3 - weekday
            selectedDate = selectedDate + toPlus.days
            print(selectedDate)
        }

        
        
        let predicate = NSPredicate(format: "date = %@", "04.09.2015")
        let DaysFromRealmWithFilter = realm.objects(Day.self).filter(predicate)
        realmDay = DaysFromRealmWithFilter.first!
//        updateScheduleProperties(1)
        selectedDay = 1
        if(self.day.lessons?.count != 0){
            performSegueWithIdentifier("mainSegue", sender: tabBarButtons[selectedDay!])
        }
        else
        {
            performSegueWithIdentifier("voidLessons", sender: tabBarButtons[selectedDay!])
        }
    }
    @IBAction func WedClick(sender: AnyObject) {
        
        if(selectedDate.weekday > 4)
        {
            let weekday = selectedDate.weekday
            let toMinus = weekday - 4
            selectedDate = selectedDate - toMinus.days
            print(selectedDate)
        }
        if (selectedDate.weekday < 4) {
            let weekday = selectedDate.weekday
            let toPlus = 4 - weekday
            selectedDate = selectedDate + toPlus.days
            print(selectedDate)
        }
        
        
        
        
        let predicate = NSPredicate(format: "date = %@", "04.09.2015")
        let DaysFromRealmWithFilter = realm.objects(Day.self).filter(predicate)
        realmDay = DaysFromRealmWithFilter.first!
//        updateScheduleProperties(2)
        selectedDay = 2
        if(self.day.lessons?.count != 0){
       
            performSegueWithIdentifier("mainSegue", sender: tabBarButtons[selectedDay!])
        }
        else
        {
            performSegueWithIdentifier("voidLessons", sender: tabBarButtons[selectedDay!])
        }
    }
    @IBAction func ThuClick(sender: AnyObject) {

        
        if(selectedDate.weekday > 5)
        {
            let weekday = selectedDate.weekday
            let toMinus = weekday - 5
            selectedDate = selectedDate - toMinus.days
            print(selectedDate)
        }
        if (selectedDate.weekday < 5) {
            let weekday = selectedDate.weekday
            let toPlus = 5 - weekday
            selectedDate = selectedDate + toPlus.days
            print(selectedDate)
        }
        let predicate = NSPredicate(format: "date = %@", "04.09.2015")
        let DaysFromRealmWithFilter = realm.objects(Day.self).filter(predicate)
        realmDay = DaysFromRealmWithFilter.first!
        
//        updateScheduleProperties(3)
        selectedDay = 3
        if(self.day.lessons?.count != 0){
         
            performSegueWithIdentifier("mainSegue", sender: tabBarButtons[selectedDay!])
        }
        else
        {
            performSegueWithIdentifier("voidLessons", sender: tabBarButtons[selectedDay!])
        }
    }
    @IBAction func FriClick(sender: AnyObject) {

        
        if(selectedDate.weekday > 6)
        {
            let weekday = selectedDate.weekday
            let toMinus = weekday - 6
            selectedDate = selectedDate - toMinus.days
            print(selectedDate)
        }
        if (selectedDate.weekday < 6) {
            let weekday = selectedDate.weekday
            let toPlus = 6 - weekday
            selectedDate = selectedDate + toPlus.days
            print(selectedDate)
        }
        
        let predicate = NSPredicate(format: "date = %@", "04.09.2015")
        let DaysFromRealmWithFilter = realm.objects(Day.self).filter(predicate)
        realmDay = DaysFromRealmWithFilter.first!
//        updateScheduleProperties(4)
        selectedDay = 4
        
        if(self.day.lessons?.count != 0){
            performSegueWithIdentifier("mainSegue", sender: tabBarButtons[selectedDay!])
        }
        else
        {
            performSegueWithIdentifier("voidLessons", sender: tabBarButtons[selectedDay!])
        }
    }
    @IBAction func SutClick(sender: AnyObject) {
        
        
        if(selectedDate.weekday > 7)
        {
            let weekday = selectedDate.weekday
            let toMinus = weekday - 7
            selectedDate = selectedDate - toMinus.days
            print(selectedDate)
        }
        if (selectedDate.weekday < 7) {
            let weekday = selectedDate.weekday
            let toPlus = 7 - weekday
            selectedDate = selectedDate + toPlus.days
            print(selectedDate)
        }
        
        
        let predicate = NSPredicate(format: "date = %@", "04.09.2015")
        let DaysFromRealmWithFilter = realm.objects(Day.self).filter(predicate)
        realmDay = DaysFromRealmWithFilter.first!

//        updateScheduleProperties(5)
        selectedDay = 5
        if(self.day.lessons?.count != 0){
            performSegueWithIdentifier("mainSegue", sender: tabBarButtons[selectedDay!])
        }
        else
        {
            performSegueWithIdentifier("voidLessons", sender: tabBarButtons[selectedDay!])
        }
    }
    
    // MARK: Rotate weeks
    
    func rotateWeekForward(sender: UIScreenEdgePanGestureRecognizer) {

        if sender.state == .Ended
        {
            selectedDate = selectedDate + 1.weeks
            if(weekNumberTab < totalSchedule.count)
            {
                segueSide = 1
                (weekNumberTab!) += 1
//                self.updateScheduleProperties(selectedDay)
                let predicate = NSPredicate(format: "date = %@", "04.09.2015")
                let DaysFromRealmWithFilter = realm.objects(Day.self).filter(predicate)
                realmDay = DaysFromRealmWithFilter.first!
                weekLabel.text = "Неделя " + String(weekNumber)
                if(day.date != ""){
                    weekLabel.text? += ", \(day.date!)"
                }
                if(self.day.lessons?.count != 0){
                    performSegueWithIdentifier("weekSegue", sender: tabBarButtons[selectedDay!])
                }
                else
                {
                    performSegueWithIdentifier("voidLessons", sender: tabBarButtons[selectedDay!])
                }

            }
        }
    }
    
    func rotateWeekBackward(sender: UIScreenEdgePanGestureRecognizer) {
        
        if sender.state == .Ended {
            if(weekNumberTab > 1)
            {
                selectedDate = selectedDate - 1.weeks
                segueSide = -1
                (weekNumberTab!) -= 1
                print(selectedDay)
//                self.updateScheduleProperties(selectedDay)
                let predicate = NSPredicate(format: "date = %@", "04.09.2015")
                let DaysFromRealmWithFilter = realm.objects(Day.self).filter(predicate)
                realmDay = DaysFromRealmWithFilter.first!
                print("realm1 - \(self.realmDay.date)")
                weekLabel.text = "Неделя " + String(weekNumber)
                if(day.date != ""){
                    weekLabel.text? += ", \(day.date!)"
                }
                if(self.day.lessons?.count != 0){
                    performSegueWithIdentifier("weekSegue", sender: tabBarButtons[selectedDay!])
                }
                else
                {
                    performSegueWithIdentifier("voidLessons", sender: tabBarButtons[selectedDay!])
                }

                
            }
            
        }
    }
//     MARK: - Update schedule
    func updateScheduleProperties(dayIndex:Int?) {


        weekNumber = totalSchedule[weekNumberTab! - 1].number!
        if(dayIndex < totalSchedule[weekNumberTab! - 1].days?.count)
        {
            day = (totalSchedule[weekNumberTab! - 1].days![dayIndex!])
        }
        else
        {
            day = OneDay()
        }
        day.lessons?.sortInPlace(beforeLes)
        
    }

    
    
    
    // MARK: Supporting methods
    override func shouldAutorotate() -> Bool {
        return true
    }
    
    // MARK: Segue methods
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier! == "mainSegue" ) {
            weekLabel.text = "Неделя " + String(weekNumber)
            if(day.date != "" && day.date != nil){
                weekLabel.text? += ", \(selectedDate.toShortString()!)"
            }
            
            let dayVC = segue.destinationViewController as! MainTableViewController
            print("realm1 - \(self.realmDay.date)")
            dayVC.realmDayToFill = self.realmDay

        }
        if(segue.identifier! == "voidLessons" )
        {
            weekLabel.text = "Неделя " + String(weekNumber)
            if(day.date != ""){
                weekLabel.text? += ", \(selectedDate.toShortString()!)"
            }
            
        }
        if(segue.identifier! == "weekSegue")
        {
            
            let dayVC = segue.destinationViewController as! MainTableViewController
            print("realm1 - \(self.realmDay.date)")
            dayVC.realmDayToFill = self.realmDay

        }
        
    }
    
    func showWarning() {
        let alertController = UIAlertController(title: "Некоректный ввод!", message:
            "Попробуйте ввести название группы правильно", preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default,handler: nil))
        self.presentViewController(alertController, animated: true, completion: nil)
    }

       
    // MARK: - Text field delegate
    func updateSchedule(itemID itemID: Int, successBlock: Void -> ()) {
        var Who:String = "lector"
        if(amistudent)
        {
            Who = "group"
        }
        InternetManager.sharedInstance.getLessonsList(["who":Who,"id":itemID,"timestamp":0], success: {
            success in
            jsonDataList = success
            successBlock()
            }, failure: {error in print(error)})
    }

    func enter()
    {
        
        dispatch_async(dispatch_get_main_queue(), {
            self.updateSchedule(itemID: subjectName.0, successBlock: {
                successBlock in
                dispatch_async(dispatch_get_main_queue(), {
                    parse(jsonDataList!,successBlock:
                        {
                            successBlock in
                            totalSchedule = successBlock
                            
                            
                                if(totalSchedule.count > 0)
                                {
                                    self.weekNumberTab = getWeekNumber()
                                    weekNumber = totalSchedule[self.weekNumberTab! - 1].number!
                                    
                                    self.weekLabel.text = "Неделя " + String(weekNumber)
                                    if(self.day.date != ""){
                                        self.weekLabel.text? += ", \(self.day.date!)"
                                    }
                                    
                                    self.subjectNameLabel.text = subjectName.1
                                    self.updateScheduleProperties(0)
                                    self.weekLabel.hidden = false
                                    self.subjectNameLabel.hidden = false
                                    
                                    if(self.day.lessons?.count != 0){
                                        self.performSegueWithIdentifier("mainSegue", sender: self.tabBarButtons[self.selectedDay!])
                                    }
                                    else
                                    {
                                        self.performSegueWithIdentifier("voidLessons", sender: self.tabBarButtons[self.selectedDay!])
                                    }
                            }
                    })
                    
                })
            })
        })
    }
}
