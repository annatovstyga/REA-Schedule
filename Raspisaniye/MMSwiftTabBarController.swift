
import UIKit
import SwiftyJSON
import SwiftSpinner
import RealmSwift
import SwiftDate


    

class MMSwiftTabBarController: UIViewController,UITextFieldDelegate{
    
    @IBOutlet weak var saturdayClick: UIButton!
    @IBOutlet weak var fridayClick: UIButton!
    @IBOutlet weak var thursdayClick: UIButton!
    @IBOutlet weak var wednesdayClick: UIButton!
    @IBOutlet weak var tuesdayClick: UIButton!
    @IBOutlet weak var mondayClick: UIButton!

    @IBOutlet var weekdaysButtons: Array<UIButton>!
    @IBOutlet var label:UIView! //перемещаюяся под кнопками полоска
    
    @IBOutlet weak var tabView: UIView!
    var type: Int?
    var searchName = ""
    var realmName = "default" //default - загруженное юзером расписание,search - загруженное для поиска
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
    var realm:Realm?
    var realmDay:Day = Day()

    var screenForwardEdgeRecognizer: UISwipeGestureRecognizer = UISwipeGestureRecognizer()
    var screenBackwardEdgeRecognizer: UISwipeGestureRecognizer = UISwipeGestureRecognizer()
    
    // MARK: ViewDidLoad
    
    
    
    
    override func viewDidLoad() {
        
        
        
        if(selectedDate.weekday == 1) //To identify monday correctly
        {
            selectedDate = selectedDate + 1.days
        }

        weekdaysButtons?[(selectedDate.weekday - 2)].setTitleColor(UIColor(red: 100/255, green: 100/255, blue:100/255, alpha: 1.0), for: .normal)

        if(realmName == "search"){//установка кнопки в состояние возврата,если мы вызвали контроллер в режими поиска
            self.leftButton.setImage(UIImage(named:"back"), for: .normal)
            self.subjectNameLabel.text = searchName
        }else{
            self.leftButton.setImage(UIImage(named:"Burger"), for: .normal)
            self.subjectNameLabel.text = defaults.value(forKey: "subjectName") as? String
        }

        var config = Realm.Configuration()

        //тут устанавливаем реалм для загрузки в зависимости от типа показываемого расписания
        config.fileURL = config.fileURL!.deletingLastPathComponent()
            .appendingPathComponent("\(realmName).realm")

        realm = try! Realm(configuration: config)

        tabView.center.y = (weekdaysButtons?[(selectedDate.weekday - 2)].frame.maxY)!
        self.tabView.addSubview(label)
        
            
        tabView.isHidden = false
        tabView.backgroundColor = UIColor(red: 232/255, green: 232/255, blue: 232/255, alpha: 1.0)
        label.isHidden = false
        label.backgroundColor = UIColor(red: 100/255, green: 100/255, blue:100/255, alpha: 1.0)
    
      

        updateRealmDay(segue: "mainSegue")
        
        
        //Week navigation gestures
        self.screenForwardEdgeRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(MMSwiftTabBarController.rotateWeekForward(_:)))
        self.screenForwardEdgeRecognizer.direction = .left
        self.screenBackwardEdgeRecognizer =  UISwipeGestureRecognizer(target: self, action: #selector(MMSwiftTabBarController.rotateWeekBackward(_:)))
        screenBackwardEdgeRecognizer.direction = .right
       
        self.view.addGestureRecognizer(screenForwardEdgeRecognizer)
        self.view.addGestureRecognizer(screenBackwardEdgeRecognizer)

        super.viewDidLoad()
    }

    
    override func viewWillAppear(_ animated: Bool) {
        self.label.center.x = (weekdaysButtons?[(selectedDate.weekday - 2)].center.x)!
        self.label.center.y = (weekdaysButtons?[(selectedDate.weekday - 2)].frame.maxY)!
    }
    @IBAction func profileClick(_ sender: AnyObject) {
        if(realmName == "search"){
            self.dismiss(animated: true, completion: { 
                //
            })
        }
        sideMenuVC.toggleMenu()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.label.center.x = (weekdaysButtons?[(selectedDate.weekday - 2)].center.x)!
        self.label.center.y = (weekdaysButtons?[(selectedDate.weekday - 2)].frame.maxY)!
    }

    //анимация пока что происходит во всех функциях-кликах.Стоит пофиксить
    @IBAction func mondayClick(_ sender: AnyObject) {
        
        UIView.animate(withDuration: 0.14, delay: 0.0, options: .curveEaseOut, animations: {
        
        self.label.center.x = sender.center.x
         }, completion: { finished in

        
        if(self.selectedDate.weekday > 2)
        {
            let weekday = self.selectedDate.weekday
            let toMinus = weekday - 2
            self.selectedDate = self.selectedDate - toMinus.days
        }
            self.updateRealmDay(segue: "mainSegue")
        })
    
    }
   
    @IBAction func TueClick(_ sender: AnyObject) {
        UIView.animate(withDuration: 0.14, delay: 0.0, options: .curveEaseOut, animations: {
            self.label.center.x = sender.center.x
            }, completion: { finished in
        
        if(self.selectedDate.weekday > 3){
            let weekday = self.selectedDate.weekday
            let toMinus = weekday - 3
            self.selectedDate = self.selectedDate - toMinus.days
        }
        if (self.selectedDate.weekday < 3){
            let weekday = self.selectedDate.weekday
            let toPlus = 3 - weekday
            self.selectedDate = self.selectedDate + toPlus.days
        }
        
        self.updateRealmDay(segue: "mainSegue")
        })
    }
    
    @IBAction func WedClick(_ sender: AnyObject) {
        UIView.animate(withDuration: 0.14, delay: 0.0, options: .curveEaseOut, animations: {
            self.label.center.x = sender.center.x
            }, completion: { finished in

        if(self.selectedDate.weekday > 4)
        {
            let weekday = self.selectedDate.weekday
            let toMinus = weekday - 4
            self.selectedDate = self.selectedDate - toMinus.days
            print(self.selectedDate)
        }
        if (self.selectedDate.weekday < 4) {
            let weekday = self.selectedDate.weekday
            let toPlus = 4 - weekday
            self.selectedDate = self.selectedDate + toPlus.days
            print(self.selectedDate)
        }
        
        self.updateRealmDay(segue: "mainSegue")
                 })
    }
    
    @IBAction func ThuClick(_ sender: AnyObject) {
        UIView.animate(withDuration: 0.14, delay: 0.0, options: .curveEaseOut, animations: {
            self.label.center.x = sender.center.x
            }, completion: { finished in

        if(self.selectedDate.weekday > 5)
        {
            let weekday = self.selectedDate.weekday
            let toMinus = weekday - 5
            self.selectedDate = self.selectedDate - toMinus.days
            print(self.selectedDate)
        }
        if (self.selectedDate.weekday < 5) {
            let weekday = self.selectedDate.weekday
            let toPlus = 5 - weekday
            self.selectedDate = self.selectedDate + toPlus.days
            print(self.selectedDate)
        }
        self.updateRealmDay(segue: "mainSegue")
        })
    }
    
    @IBAction func FriClick(_ sender: AnyObject) {
        UIView.animate(withDuration: 0.14, delay: 0.0, options: .curveEaseOut, animations: {
            self.label.center.x = sender.center.x
            }, completion: { finished in

        if(self.selectedDate.weekday > 6)
        {
            let weekday = self.selectedDate.weekday
            let toMinus = weekday - 6
            self.selectedDate = self.selectedDate - toMinus.days
            print(self.selectedDate)
        }
        if (self.selectedDate.weekday < 6) {
            let weekday = self.selectedDate.weekday
            let toPlus = 6 - weekday
            self.selectedDate = self.selectedDate + toPlus.days
            print(self.selectedDate)
        }
        self.updateRealmDay(segue: "mainSegue")
        })
    }
    
    @IBAction func SutClick(_ sender: AnyObject) {
        UIView.animate(withDuration: 0.14, delay: 0.0, options: .curveEaseOut, animations: {
            self.label.center.x = sender.center.x
            }, completion: { finished in

        if(self.selectedDate.weekday > 7)
        {
            let weekday = self.selectedDate.weekday
            let toMinus = weekday - 7
            self.selectedDate = self.selectedDate - toMinus.days
            print(self.selectedDate)
        }
        if (self.selectedDate.weekday < 7) {
            let weekday = self.selectedDate.weekday
            let toPlus = 7 - weekday
            self.selectedDate = self.selectedDate + toPlus.days
            print(self.selectedDate)
        }
        
        self.updateRealmDay(segue: "mainSegue")
    })
    }
    
    
    // MARK: Rotate weeks
    
//    func rotateWeekForward(_ sender: UIScreenEdgePanGestureRecognizer) {
//        if sender.state == .ended && !self.isCalendar
//        {
//            selectedDate = selectedDate + 1.weeks
//
//            updateRealmDay(segue: "weekSegue")
//        }
//    }
//    
//    func rotateWeekBackward(_ sender: UIScreenEdgePanGestureRecognizer) {
//        if sender.state == .ended && !self.isCalendar {
//            selectedDate = selectedDate - 1.weeks
//            updateRealmDay(segue: "weekSegue")
//        }
//    }
    func rotateWeekForward(_ sender: UIScreenEdgePanGestureRecognizer){
        
        if sender.state == .ended && !self.isCalendar {
            
            if self.selectedDate.weekday < 7 {
                
                selectedDate = selectedDate + 1.day
                updateRealmDay(segue: "mainSegue")
            } else {
                
            let weekday = self.selectedDate.weekday
            let toMinus = weekday - 2
            let plusWeek = selectedDate + 1.weeks
                
                selectedDate = plusWeek - toMinus.days
                updateRealmDay(segue: "weekSegue")
            }
        }
    }
    
    func rotateWeekBackward ( _ sender: UIScreenEdgePanGestureRecognizer){
        
        if sender.state == .ended && !self.isCalendar {
            if self.selectedDate.weekday > 2{
                selectedDate = selectedDate - 1.day
                updateRealmDay(segue: "mainSegue")
            
             
               

            }else {
                let weekday = self.selectedDate.weekday
                let minusWeek = selectedDate - 1.weeks
                print("monty\(selectedDate - 1.weeks)")
                let toPlusDay = weekday + 3
                
                selectedDate  = minusWeek + toPlusDay.days
                print("lala\(minusWeek + toPlusDay.days)")
                updateRealmDay(segue: "weekSegue")

            }
        }
    }
    // MARK: Supporting methods
    
    override var shouldAutorotate : Bool {
        return true
    }
    
    // MARK: Segue methods
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //обновляем тут состояние label и tabView,gestureRecognizers и т.д.

        if(segue.identifier! == "mainSegue" || segue.identifier! == "weekSegue" ) {
            self.view.addGestureRecognizer(screenForwardEdgeRecognizer)
            self.view.addGestureRecognizer(screenBackwardEdgeRecognizer)
            let dayVC = segue.destination as! MainTableViewController
            dayVC.realmDayToFill = self.realmDay
            if (self.type == 1){
                dayVC.type = self.type
            } else {
                dayVC.type = 0
            }
            
            for button in tabBarButtons{
                button.isHidden = false
            }
            self.label.isHidden = false
            self.tabView.isHidden = false
            self.isCalendar = false
            
        }else if (segue.identifier == "segueCalendar"){
            
            self.isCalendar = true
            self.label.isHidden = true
            self.tabView.isHidden = true
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
            self.label.isHidden = false
            self.tabView.isHidden = false
            self.isCalendar = false
        }else if(segue.identifier == "FeedSegue"){
            self.label.isHidden = true
            self.tabView.isHidden = true
            for button in tabBarButtons{
                button.isHidden = true
            }
        }
    }

    func updateRealmDay(segue:String)
    {
        //получение дня из реалма
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.YYYY"
        let dateInFormat = dateFormatter.string(from: selectedDate.absoluteDate)
        let predicate = NSPredicate(format: "date = %@", dateInFormat)
        let DaysFromRealmWithFilter = realm?.objects(Day.self).filter(predicate)
        if(DaysFromRealmWithFilter?.first != nil)
        {
            realmDay = (DaysFromRealmWithFilter?.first!)!
        }else{
            realmDay = Day()
        }
        
        if(self.realmDay.lessons.count != 0){
            performSegue(withIdentifier: "mainSegue", sender: true)
        }
        else{
            performSegue(withIdentifier: "voidLessons", sender: self)
        }

        //FIXIT тут много кривых вычислений числа недели.Тут такой баг,что 26 число 2016 года - уже первая неделя следующего.
        let regionMoscow = Region.Local()
        let date = try! DateInRegion(string: "\(selectedDate.year)-09-01 00:01:00", format: .custom("yyyy-MM-dd HH:mm:ss"), fromRegion: regionMoscow)

        let datetest2 = date.endOf(component: .yearForWeekOfYear)
        let endOfLastWeekOfYear = datetest2.startOf(component: .weekOfYear)
        let weekNumber:Int?
        let yearPlusOne = yearNow + 1
        let date3 = try! DateInRegion(string: "\((yearPlusOne))-01-01 00:01:00", format: .custom("yyyy-MM-dd HH:mm:ss"), fromRegion: regionMoscow)

        let date4 =  try! DateInRegion(string: "\((selectedDate.year))-01-01 00:01:00", format: .custom("yyyy-MM-dd HH:mm:ss"), fromRegion: regionMoscow)
        if(selectedDate.isAfter(date: endOfLastWeekOfYear,granularity:.day) && selectedDate.isBefore(date: date3,granularity:.day))
        {
            weekNumber = (endOfLastWeekOfYear.weekOfYear + 1 - date.weekOfYear)
        }else if(selectedDate.isAfter(date: date4,granularity:.day) && selectedDate.isBefore(date: date, granularity:.day))
        {
             weekNumber = (endOfLastWeekOfYear.weekOfYear - date.weekOfYear ) + selectedDate.weekOfYear + 1
        }else{
             weekNumber = selectedDate.weekOfYear - date.weekOfYear + 1
        }
        if(segue == "weekSegue")
        {

            let animation = CABasicAnimation(keyPath: "transform.scale")
            animation.toValue = NSNumber(value: 0.9)
            animation.duration = 0.4
            animation.repeatCount = 1
            animation.autoreverses = true
            self.weekLabel.layer.add(animation, forKey: nil)
        }
        self.weekLabel.text = " \(dateInFormat) | \(weekNumber!) неделя"

        self.setAllButtonsGray()
         weekdaysButtons?[(selectedDate.weekday - 2)].setTitleColor(UIColor(red: 100/255, green: 100/255, blue:100/255, alpha: 1.0), for: .normal)
        self.label.center.x = (weekdaysButtons?[(selectedDate.weekday - 2)].center.x)!
        self.label.center.y = (weekdaysButtons?[(selectedDate.weekday - 2)].frame.maxY)!

    }
    
    func setAllButtonsGray()
    {
        for button in weekdaysButtons{
            button.setTitleColor(UIColor(red: 232/255, green: 232/255, blue: 232/255, alpha: 1.0), for: .normal)
        }
    }

    //попробовать сделать всё через эту функцию
    func daysBetweenDates(_ startDate: Date, endDate: Date) -> Int
    {
        let calendar = Calendar.current
        
        let components = (calendar as NSCalendar).components([.day], from: startDate, to: endDate, options: [])

        return components.day!
    }
}
