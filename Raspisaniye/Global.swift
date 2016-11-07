
import Foundation
import UIKit
import SwiftyJSON
import RealmSwift
import SwiftDate

let defaults = UserDefaults.standard
var jsonDataList:JSON?

var isLogined = defaults.object(forKey: "isLogined") as? Bool ?? Bool()
var amistudent: Bool = defaults.object(forKey: "amistudent") as? Bool ?? Bool()

var lectorsArray: [String] = []
var groupsArray: [String] = []
var segueSide:CGFloat = 1
var groupNamesList: [String: Int] = [:]
var lectorsNamesList: [String: Int] = [:]
var rowH: CGFloat = 0
var slString:String?
var subjectName: (Int, String) = (0,"")

struct GlobalColors{
    //FIXIT check and change
    static let lightBlueColor = UIColor(red: 0/255, green: 118/255, blue: 225/255, alpha: 1.0)
    static let BlueColor = UIColor(red: 0/255,green: 71/255,blue: 119/255,alpha: 1.0)
}

func before(_ value1: String, value2: String) -> Bool {//личная функция для сортировки
    return value1 < value2;
}

func parse(_ jsontoparse:JSON,realmName:String ,successBlock: (Bool) -> ())
{
    var config = Realm.Configuration()

    config.fileURL = config.fileURL!.deletingLastPathComponent()
        .appendingPathComponent("\(realmName).realm")
    let realm = try! Realm(configuration: config)
    if(realmName == "search"){
        try! realm.write {
            realm.deleteAll()//удаляется только всё в search,default в другом месте
        }
    }
    SwiftSpinner.show("Немного волшебства")

    let rasp = Schedule()
    rasp.year = "2016"
    print(jsontoparse)
    for semestr in jsontoparse["success"]["data"] {
        
        let week = Week()
        week.number = semestr.1["weekNum"].int
        // weekData - is one week
        for weekData in semestr.1 {
            // dayData - is one day
            for dayData in weekData.1 {
                
                let day = Day()
                day.dayName = dayData.0
                day.date = dayData.1["date"].string

                // lessonData - is one lesson
                for lessonData in dayData.1["lessons"] {
                    if(lessonData.1 != nil) {
                        // Main properties
                        let subject = Lesson()

                        try! realm.write {
                    
                        subject.lessonNumber = lessonData.0 
                        subject.hashID  = lessonData.1["hash_id"].string
                        subject.lessonType = lessonData.1["lesson_type"].stringValue
                        subject.room = lessonData.1["room"].string
                        subject.lessonStart = lessonData.1["lesson_start"].string
                        subject.lessonEnd = lessonData.1["lesson_end"].string
                        subject.discipline = lessonData.1["discipline"].string
                        subject.lessonType = lessonData.1["lessontype"].string
                        subject.building = lessonData.1["building"].string
                        subject.lector = lessonData.1["lector"].string
                        subject.house  = lessonData.1["housing"].intValue
                        subject.startWeek = lessonData.1["week_start"].intValue
                        subject.endWeek = lessonData.1["week_end"].intValue
                        var groupsString:String = ""
                        for item in lessonData.1["groups"]{
                                if(groupsString.range(of: "\(item.1.stringValue) |") == nil){
                                    groupsString.append("\(item.1.stringValue) |")
                                }
                            }
                        print(groupsString)
                        subject.groups = groupsString
                        }
                       
                        try! realm.write {
                            day.lessons.append(subject)
                        }
                }
                

                }
                try! realm.write {
                    week.days.append(day)
                }
            }
            
        }
        
        try! realm.write {
            rasp.weeks.append(week)
        }
    }
    try! realm.write(){
        realm.add(rasp, update: true)
    }
    successBlock(true)
    SwiftSpinner.hide()
}

func updateSchedule(itemID: Int,type:Int, successBlock: @escaping (Void) -> ()) {
    var Who:String
    if(type == 0)
    {
        Who = "group"
    }else{
        Who = "lector"
    }
    InternetManager.sharedInstance.getLessonsList(["who":Who as AnyObject,"id":itemID as AnyObject,"timestamp":0 as AnyObject], success: {
        success in
        jsonDataList = success
        successBlock()
        }, failure: {error in
            print(error)
    })
}



//куча методов для установки различных контроллеров на свои места.Возможно стоит удалить нахуй.
func getCurrentViewController() -> UIViewController? {
    
    // If the root view is a navigation controller, we can just return the visible ViewController
    if let navigationController = getNavigationController() {
        
        return navigationController.visibleViewController
    }
    
    // Otherwise, we must get the root UIViewController and iterate through presented views
    if let rootController = UIApplication.shared.keyWindow?.rootViewController {
        
        var currentController: UIViewController! = rootController
        
        // Each ViewController keeps track of the view it has presented, so we
        // can move from the head to the tail, which will always be the current view
        while( currentController.presentedViewController != nil ) {
            
            currentController = currentController.presentedViewController
        }
        return currentController
    }
    return UIViewController()
    
}


func getNavigationController()-> UINavigationController? {
    if let navigationController = UIApplication.shared.keyWindow?.rootViewController  {
        
        return navigationController as? UINavigationController
    }
    return nil
}


