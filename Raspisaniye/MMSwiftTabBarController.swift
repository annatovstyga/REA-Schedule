import UIKit
import SwiftyJSON
import SwiftSpinner
import RealmSwift
import SwiftDate

class MMSwiftTabBarController: UIViewController,UITextFieldDelegate{
    
    @IBOutlet var weekdaysButtons: Array<UIButton>!
    // MARK: Propiertes
    var selectedDate = DateInRegion()
    @IBOutlet weak var tabBarView: UIView!
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var weekLabel: UILabel!
    @IBOutlet var placeholderView: UIView!
    @IBOutlet var tabBarButtons: Array<UIButton>!
    var currentViewController: UIViewController?
    @IBOutlet weak var subjectNameLabel: UILabel!
    let yearNow = NSDate().year
    let realm = try! Realm()
    var weekNumberTab:Int? = 1
    var realmDay:Day = Day()

    // MARK: ViewDidLoad
    override func viewDidLoad() {

        if(selectedDate.weekday == 1) //To identify monday correctly
        {
            selectedDate = selectedDate + 1.days
        }
        self.subjectNameLabel.text = subjectNameMemory
        updateRealmDay()
        
        
        //Week navigation gestures
        let screenForwardEdgeRecognizer: UISwipeGestureRecognizer! = UISwipeGestureRecognizer(target: self, action: #selector(MMSwiftTabBarController.rotateWeekForward(_:)))
                            screenForwardEdgeRecognizer.direction = .Left
        let screenBackwardEdgeRecognizer: UISwipeGestureRecognizer! = UISwipeGestureRecognizer(target: self, action: #selector(MMSwiftTabBarController.rotateWeekBackward(_:)))
        screenBackwardEdgeRecognizer.direction = .Right
        self.view.addGestureRecognizer(screenForwardEdgeRecognizer)
        self.view.addGestureRecognizer(screenBackwardEdgeRecognizer)
        self.navigationController?.view.addGestureRecognizer(screenForwardEdgeRecognizer)
        self.navigationController?.view.addGestureRecognizer(screenBackwardEdgeRecognizer)
        
        super.viewDidLoad()
    }
    
    // MARK: IBActions - buttons
    //TODO: Merge in collection
    @IBAction func profileClick(sender: AnyObject) {
        sideMenuVC.toggleMenu()
    }
   
    @IBAction func mondayClick(sender: AnyObject) {
        
        if(selectedDate.weekday > 2)
        {
            let weekday = selectedDate.weekday
            let toMinus = weekday - 2
            selectedDate = selectedDate - toMinus.days
        }
        updateRealmDay()
    }

    @IBAction func TueClick(sender: AnyObject) {

        if(selectedDate.weekday > 3){
            let weekday = selectedDate.weekday
            let toMinus = weekday - 3
            selectedDate = selectedDate - toMinus.days
        }
        if (selectedDate.weekday < 3){
            let weekday = selectedDate.weekday
            let toPlus = 3 - weekday
            selectedDate = selectedDate + toPlus.days
        }
        
        updateRealmDay()
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
        
        updateRealmDay()
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
        updateRealmDay()
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
        updateRealmDay()
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
        
        updateRealmDay()
    }
    
    // MARK: Rotate weeks
    
    func rotateWeekForward(sender: UIScreenEdgePanGestureRecognizer) {
        if sender.state == .Ended
        {
            selectedDate = selectedDate + 1.weeks
            updateRealmDay()
        }
    }
    
    func rotateWeekBackward(sender: UIScreenEdgePanGestureRecognizer) {
        if sender.state == .Ended {
            selectedDate = selectedDate - 1.weeks
            updateRealmDay()
        }
    }
    
    // MARK: Supporting methods
    
    override func shouldAutorotate() -> Bool {
        return true
    }
    
    // MARK: Segue methods
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier! == "mainSegue" || segue.identifier! == "weekSegue" ) {
            let dayVC = segue.destinationViewController as! MainTableViewController
            dayVC.realmDayToFill = self.realmDay
        }
    }

    func updateRealmDay()
    {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd.MM.YYYY"
        let dateInFormat = dateFormatter.stringFromDate(selectedDate.absoluteTime)
        let predicate = NSPredicate(format: "date = %@", dateInFormat)
        let DaysFromRealmWithFilter = realm.objects(Day.self).filter(predicate)
        if(DaysFromRealmWithFilter.first != nil)
        {
            realmDay = DaysFromRealmWithFilter.first!
        }else{
            realmDay = Day()
        }
        
        if(self.realmDay.lessons.count != 0){
            performSegueWithIdentifier("mainSegue", sender: self)
        }
        else{
            performSegueWithIdentifier("voidLessons", sender: self)
        }
        let regionRome = Region(calendarName: .Current, timeZoneName: TimeZoneName.EuropeMoscow, localeName: LocaleName.Russian)
        //FIXME - REFACTOR NAMES
        let date = DateInRegion(era: 1, year: selectedDate.year, month: 9, day: 1, hour: 0, minute: 0, second: 0, nanosecond: 0, region: regionRome)
        let date2 = DateInRegion(era: 1, year: selectedDate.year, month: 12, day: 25, hour: 00, minute: 00, second: 0, nanosecond: 0, region: regionRome)
        
        let weekNumber:Int?
        let date3 =  DateInRegion(era: 1, year:  yearNow + 1, month: 1, day: 1, hour: 00, minute: 01, second: 0, nanosecond: 0, region: regionRome)
        let date4 =  DateInRegion(era: 1, year:  selectedDate.year, month: 1, day: 1, hour: 00, minute: 01, second: 0, nanosecond: 0, region: regionRome)
        if(selectedDate.isAfter(.Day, ofDate: date2) && selectedDate.isBefore(.Day, ofDate: date3))
        {
            weekNumber = (date2.weekOfYear + 1 - date.weekOfYear) + 1
        }else if(selectedDate.isAfter(.Day, ofDate: date4) && selectedDate.isBefore(.Day, ofDate: date))
        {
             weekNumber = (date2.weekOfYear - date.weekOfYear ) + selectedDate.weekOfYear
        }else{
             weekNumber = selectedDate.weekOfYear - date.weekOfYear + 1
        }

        weekLabel.text = "Неделя \(weekNumber!),\(dateInFormat)"
        
    }
    
    func daysBetweenDates(startDate: NSDate, endDate: NSDate) -> Int
    {
        let calendar = NSCalendar.currentCalendar()
        
        let components = calendar.components([.Day], fromDate: startDate, toDate: endDate, options: [])
        
        return components.day
    }
}
