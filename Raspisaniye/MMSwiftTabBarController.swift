import UIKit
import SwiftyJSON
import SwiftSpinner
import RealmSwift
import SwiftDate

class MMSwiftTabBarController: UIViewController,UITextFieldDelegate{
    
    @IBOutlet var weekdaysButtons: Array<UIButton>!
    // MARK: Propiertes
    var selectedDate = DateInRegion()
    var isCalendar = false
    @IBOutlet weak var tabBarView: UIView!
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var weekLabel: UILabel!
    @IBOutlet var placeholderView: UIView!
    @IBOutlet var tabBarButtons: Array<UIButton>!
    var currentViewController: UIViewController?
    @IBOutlet weak var subjectNameLabel: UILabel!
    let yearNow = Date().year
    let realm = try! Realm()
    var weekNumberTab:Int? = 1
    var realmDay:Day = Day()

    
    var screenForwardEdgeRecognizer: UISwipeGestureRecognizer = UISwipeGestureRecognizer()
    var screenBackwardEdgeRecognizer: UISwipeGestureRecognizer = UISwipeGestureRecognizer()
    
    // MARK: ViewDidLoad
    override func viewDidLoad() {

        if(selectedDate.weekday == 1) //To identify monday correctly
        {
            selectedDate = selectedDate + 1.days
        }
        self.subjectNameLabel.text = subjectNameMemory
        updateRealmDay()
        
        
        //Week navigation gestures
        self.screenForwardEdgeRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(MMSwiftTabBarController.rotateWeekForward(_:)))
        self.screenForwardEdgeRecognizer.direction = .left
        self.screenBackwardEdgeRecognizer =  UISwipeGestureRecognizer(target: self, action: #selector(MMSwiftTabBarController.rotateWeekBackward(_:)))
        screenBackwardEdgeRecognizer.direction = .right
       
        self.view.addGestureRecognizer(screenForwardEdgeRecognizer)
        self.view.addGestureRecognizer(screenBackwardEdgeRecognizer)

//        self.navigationController?.view.addGestureRecognizer(screenForwardEdgeRecognizer)
//        self.navigationController?.view.addGestureRecognizer(screenBackwardEdgeRecognizer)
        
        super.viewDidLoad()
    }
    
    // MARK: IBActions - buttons
    //TODO: Merge in collection
    @IBAction func profileClick(_ sender: AnyObject) {
        sideMenuVC.toggleMenu()
    }
   
    @IBAction func mondayClick(_ sender: AnyObject) {
        
        if(selectedDate.weekday > 2)
        {
            let weekday = selectedDate.weekday
            let toMinus = weekday - 2
            selectedDate = selectedDate - toMinus.days
        }
        updateRealmDay()
    }

    @IBAction func TueClick(_ sender: AnyObject) {

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
    
    @IBAction func WedClick(_ sender: AnyObject) {

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
    
    @IBAction func ThuClick(_ sender: AnyObject) {

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
    
    @IBAction func FriClick(_ sender: AnyObject) {

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
    
    @IBAction func SutClick(_ sender: AnyObject) {
        
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
    
    func rotateWeekForward(_ sender: UIScreenEdgePanGestureRecognizer) {
        if sender.state == .ended && !self.isCalendar
        {
            selectedDate = selectedDate + 1.weeks
            updateRealmDay()
        }
    }
    
    func rotateWeekBackward(_ sender: UIScreenEdgePanGestureRecognizer) {
        if sender.state == .ended && !self.isCalendar {
            selectedDate = selectedDate - 1.weeks
            updateRealmDay()
        }
    }
    
    // MARK: Supporting methods
    
    override var shouldAutorotate : Bool {
        return true
    }
    
    // MARK: Segue methods
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier! == "mainSegue" || segue.identifier! == "weekSegue" ) {
            self.view.addGestureRecognizer(screenForwardEdgeRecognizer)
            self.view.addGestureRecognizer(screenBackwardEdgeRecognizer)
            let dayVC = segue.destination as! MainTableViewController
            dayVC.realmDayToFill = self.realmDay
            for button in tabBarButtons{
                button.isHidden = false
            }
            self.isCalendar = false
            
        }else if (segue.identifier == "segueCalendar"){
            self.isCalendar = true
            self.view.gestureRecognizers?.removeAll()
            
            for subview in (self.navigationController?.view.subviews)! as [UIView] {
                    subview.gestureRecognizers?.removeAll(keepingCapacity: false)
            }
            for button in tabBarButtons{
                button.isHidden = true
            }
        }else if(segue.identifier == "voidLessons"){
            self.view.addGestureRecognizer(screenForwardEdgeRecognizer)
            self.view.addGestureRecognizer(screenBackwardEdgeRecognizer)
            for button in tabBarButtons{
                button.isHidden = false
            }
            self.isCalendar = false
        }else if(segue.identifier == "FeedSegue"){
            for button in tabBarButtons{
                button.isHidden = true
            }
        }
    }

    func updateRealmDay()
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.YYYY"
        let dateInFormat = dateFormatter.string(from: selectedDate.absoluteDate)
        let predicate = NSPredicate(format: "date = %@", dateInFormat)
        let DaysFromRealmWithFilter = realm.objects(Day.self).filter(predicate)
        if(DaysFromRealmWithFilter.first != nil)
        {
            realmDay = DaysFromRealmWithFilter.first!
        }else{
            realmDay = Day()
        }
        
        if(self.realmDay.lessons.count != 0){
            performSegue(withIdentifier: "mainSegue", sender: true)
        }
        else{
            performSegue(withIdentifier: "voidLessons", sender: self)
        }
        let regionRome = Region.Local()
        let date = try! DateInRegion(string: "\(selectedDate.year)-09-01 00:01:00", format: .custom("yyyy-MM-dd HH:mm:ss"), fromRegion: regionRome)
        let date2 = try! DateInRegion(string: "\(selectedDate.year)-12-25 00:01:00", format: .custom("yyyy-MM-dd HH:mm:ss"), fromRegion: regionRome)

        
        let weekNumber:Int?
        let yearPlusOne = yearNow + 1
        let date3 = try! DateInRegion(string: "\((yearPlusOne))-01-01 00:01:00", format: .custom("yyyy-MM-dd HH:mm:ss"), fromRegion: regionRome)

        let date4 =  try! DateInRegion(string: "\((selectedDate.year))-01-01 00:01:00", format: .custom("yyyy-MM-dd HH:mm:ss"), fromRegion: regionRome)
        if(selectedDate.isAfter(date: date2,granularity:.day) && selectedDate.isBefore(date: date3,granularity:.day))
        {
            weekNumber = (date2.weekOfYear + 1 - date.weekOfYear)
        }else if(selectedDate.isAfter(date: date4,granularity:.day) && selectedDate.isBefore(date: date, granularity:.day))
        {
             weekNumber = (date2.weekOfYear - date.weekOfYear ) + selectedDate.weekOfYear + 1
        }else{
             weekNumber = selectedDate.weekOfYear - date.weekOfYear + 1
        }

        weekLabel.text = "Неделя \(weekNumber!),  \(dateInFormat)"
        
        
        print(selectedDate.weekday)
        self.setAllButtonsGray()
         weekdaysButtons?[(selectedDate.weekday - 2)].setTitleColor(UIColor(red: 100/255, green: 100/255, blue:100/255, alpha: 1.0), for: .normal)
    }
    
    func setAllButtonsGray()
    {
        for button in weekdaysButtons{
            button.setTitleColor(UIColor(red: 232/255, green: 232/255, blue: 232/255, alpha: 1.0), for: .normal)
        }
    }
    func daysBetweenDates(_ startDate: Date, endDate: Date) -> Int
    {
        let calendar = Calendar.current
        
        let components = (calendar as NSCalendar).components([.day], from: startDate, to: endDate, options: [])
        
        return components.day!
    }
}
