
import Foundation
import UIKit
import SwiftyJSON
import RealmSwift
import SwiftDate

let defaults = NSUserDefaults.standardUserDefaults()
var jsonDataList:JSON?

var isLogined = defaults.objectForKey("isLogined") as? Bool ?? Bool()
var amistudent: Bool = defaults.objectForKey("amistudent") as? Bool ?? Bool()
var subjectNameMemory = defaults.objectForKey("subjectName") as? String ?? String()
var subjectIDMemory   = defaults.objectForKey("subjectID") as? Int ?? Int()
var timestampMemory   = defaults.objectForKey("timestamp") as? Int ?? Int()

var lectorsArray: [String] = []
var groupsArray: [String] = []
var segueSide:CGFloat = 1
var groupNamesList: [String: Int] = [:]
var lectorsNamesList: [String: Int] = [:]
var rowH: CGFloat = 0
var slString:String?
var subjectName: (Int, String) = (0,"")

struct GlobalColors{
    
    static let lightBlueColor = UIColor(red: 0/255, green: 118/255, blue: 225/255, alpha: 1.0)
    static let BlueColor = UIColor(red: 0/255,green: 71/255,blue: 119/255,alpha: 1.0)
}

func before(value1: String, value2: String) -> Bool {
    return value1 < value2;
}

func parse(jsontoparse:JSON,successBlock: Bool -> ())
{
    let realm = try! Realm()
    try! realm.write {
        realm.deleteAll()
    }
    SwiftSpinner.show("Немного волшебства")
    
    let rasp = Schedule()
    rasp.year = "2016"
    
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
                        subject.house  = lessonData.1["housing"].stringValue
                        subject.startWeek = lessonData.1["week_start"].stringValue
                        subject.endWeek = lessonData.1["week_end"].stringValue
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

func updateSchedule(itemID itemID: Int, successBlock: Void -> ()) {
    var Who:String
    if(amistudent)
    {
        Who = "group"
    }else{
        Who = "lector"
    }
    InternetManager.sharedInstance.getLessonsList(["who":Who,"id":itemID,"timestamp":0], success: {
        success in
        jsonDataList = success
        successBlock()
        }, failure: {error in
            print(error)
    })
}


func updateSch()
{
    SwiftSpinner.show("")
    let id = defaults.objectForKey("subjectID") as! Int
    dispatch_async(dispatch_get_main_queue(), {
        updateSchedule(itemID: id, successBlock: {
            successBlock in
            dispatch_async(dispatch_get_main_queue(), {
                parse(jsonDataList!, successBlock: { (true) in
                    print("FIX ME,THAT'S AN ERROR")
                })
                
            })
        })
    })
}

func getCurrentViewController() -> UIViewController? {
    
    // If the root view is a navigation controller, we can just return the visible ViewController
    if let navigationController = getNavigationController() {
        
        return navigationController.visibleViewController
    }
    
    // Otherwise, we must get the root UIViewController and iterate through presented views
    if let rootController = UIApplication.sharedApplication().keyWindow?.rootViewController {
        
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
    if let navigationController = UIApplication.sharedApplication().keyWindow?.rootViewController  {
        
        return navigationController as? UINavigationController
    }
    return nil
}


