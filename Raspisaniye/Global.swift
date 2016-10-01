
import Foundation
import UIKit
import SwiftyJSON
import RealmSwift
import SwiftDate
let defaults = NSUserDefaults.standardUserDefaults()
var jsonDataList:JSON?
var selectedDay:Int = 1
var weekNumber:Int = 1

var selectedDate = DateInRegion()

var firstOfSeptember:NSDate? = NSDate()
var isGCMReceived:Bool? = defaults.objectForKey("isGCM") as? Bool ?? Bool()
var sevenDayWeek:Bool = false
var changes:Bool = false //Temp var
var onSearch:Bool = false
var searchDisplayed:Bool = false
var isLogined = defaults.objectForKey("isLogined") as? Bool ?? Bool()
var amistudent: Bool = defaults.objectForKey("amistudent") as? Bool ?? Bool()
var subjectNameMemory = defaults.objectForKey("subjectName") as? String ?? String()
var subjectIDMemory   = defaults.objectForKey("subjectID") as? Int ?? Int()
var timestampMemory   = defaults.objectForKey("timestamp") as? Int ?? Int()
var currentWeekMemory = defaults.objectForKey("currentWeek") as? Int ?? Int()
var lectorsArray: [String] = []
var groupsArray: [String] = []
var segueSide:CGFloat = 1
var groupNamesList: [String: Int] = [:]
var lectorsNamesList: [String: Int] = [:]
var rowH: CGFloat = 0
var slString:String?
var subjectName: (Int, String) = (0,"")
var totalSchedule: [OneWeek] = []

func before(value1: String, value2: String) -> Bool {
    return value1 < value2;
}
func beforeLes(value1: OneLesson, value2: OneLesson) -> Bool {
    return value1.lessonNumber < value2.lessonNumber;
}
struct GlobalColors{
    
    static let lightBlueColor = UIColor(red: 0/255, green: 118/255, blue: 225/255, alpha: 1.0)
    static let BlueColor = UIColor(red: 0/255,green: 71/255,blue: 119/255,alpha: 1.0)
}
func parseLessonType(notParsedString:String) -> String
{
    switch(notParsedString)
    {
        case "Л":
            return "Лекция"
        break
        case "С":
            return "Семинар"
        break
        case "П":
            return "Практ. занятие"
        break
        default:
            return "Занятие"
    }
}

func getWeekNumber() -> Int
{
    let date = NSDate()
    let calendar = NSCalendar.currentCalendar()
    let components = calendar.components([.Day , .Month , .Year], fromDate: date)
    
    let year =  components.year
    var todayYear = year
    let todayDay = components.day
    let firstSeptember = NSDate(timeIntervalSince1970: 1472688000);
    if date.compare(firstSeptember) == NSComparisonResult.OrderedDescending
    {
        NSLog("date1 after date2");
    } else if date.compare(firstSeptember) == NSComparisonResult.OrderedAscending
    {
        NSLog("date1 before date2");
        todayYear-=1
    } else
    {
        NSLog("dates are equal");
    }

//    if(todayDay < NSDate(year: todayYear, month: 09, day: 1))
//    {
//        todayYear -= 1
//    }
    let start = "\(todayYear)-09-01"
    print(todayYear)
    let dateFormatter = NSDateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
  
    let startDate:NSDate = dateFormatter.dateFromString(start)!
    let endDate:NSDate = NSDate()
    func daysBetweenDate(startDate: NSDate, endDate: NSDate) -> Int
    {
        let calendar = NSCalendar.currentCalendar()
        
        let components = calendar.components([.Day], fromDate: startDate, toDate: endDate, options: [])
        
        return components.day
    }
    let days = daysBetweenDate(startDate, endDate: endDate) + 1
    let week = days/7 + 1
    var count:Int = 0
    for item in totalSchedule
    {
        if(item.number <= week)
        {
            count += 1;
        }
        else
        {
            break
        }
    }
    return count
}

func parseToList(parsingList:[String: Int],successBlock: [String] ->())
{
     SwiftSpinner.show("Немного волшебства")
    var parsedList:[String] = []
    for (value, _) in parsingList{
        parsedList.append(value)
    }
    parsedList.sortInPlace(before)
    
    successBlock(parsedList)
    SwiftSpinner.hide()
    return
}


//lesson.

func parse(jsontoparse:JSON,successBlock: [OneWeek] -> ())
{
    let realm = try! Realm()
    try! realm.write {
        realm.deleteAll()
    }
    print(jsontoparse)
    SwiftSpinner.show("Немного волшебства")
    var schedule: [OneWeek] = []
    
    
    var rasp = Schedule()
    rasp.year = "2016"
    print("from parse with love \(jsontoparse)")
    
    for semestr in jsontoparse["success"]["data"] {

        let oneWeek: OneWeek = OneWeek()
        
        var week = Week()
        week.number = semestr.1["weekNum"].int
        
        
        
        
        oneWeek.number = semestr.1["weekNum"].int
        oneWeek.days = [OneDay(),OneDay(),OneDay(),OneDay(),OneDay(),OneDay()]
        // weekData - is one week
        for weekData in semestr.1 {

            // dayData - is one day
            for dayData in weekData.1 {
                var oneDay: OneDay = OneDay()
                
                
                
                var day = Day()
                day.dayName = dayData.0
                day.date = dayData.1["date"].string
                
                
                
                
                oneDay.dayName = dayData.0

                
                oneDay.lessons = []
                oneDay.date = dayData.1["date"].string
                // lessonData - is one lesson
                for lessonData in dayData.1["lessons"] {
                    if(lessonData.1 != nil) {
                        // Main properties
                        let lessonNumber        = Int(lessonData.0)
                        let hashID: String?     = lessonData.1["hash_id"].string
                         let lessonType: String? = lessonData.1["lesson_type"].string
                        let room: String?       = lessonData.1["room"].string
                        let lessonStart: String? = lessonData.1["lesson_start"].string
                        let lessonEnd: String?   = lessonData.1["lesson_end"].string
                        let discipline: String? = lessonData.1["discipline"].string
                        let building: String?   = lessonData.1["building"].string
                        let lector: String?     = lessonData.1["lector"].string
                        let house: Int?         = lessonData.1["housing"].int
                        let startWeek: Int? = lessonData.1["week_start"].int
                        let endWeek: Int?  = lessonData.1["week_end"].int
                        var groups: [String]?   = []
                        let lessonsGroups = lessonData.1["groups"].array
                        
                        if let data = lessonsGroups {
                            for groupName in data {
                                let groupString = groupName.stringValue
                                groups?.append(groupString)
                            }
                        }
                        let lesson = OneLesson(lessonNumber: lessonNumber, hashID: hashID, lessonType: lessonType, room: room, lessonStart: lessonStart, lessonEnd: lessonEnd, discipline: discipline, building: building, lector: lector, house: house, groups: groups,startWeek:startWeek,endWeek:endWeek)
                       
                        oneDay.lessons?.append(lesson)
                        
                        
                        var subject = Lesson()
                        

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
                        print("start \(subject.startWeek)")
                        print("end - \(lessonData.1["week_start"].stringValue)")
                        subject.endWeek = lessonData.1["week_end"].stringValue
                        }
                       
                        
                        
    
                        try! realm.write {
                            day.lessons.append(subject)
                        }
                        

                    
                        print("lessons 1\(day.lessons)")
                }

                    print("lessons \(day.lessons)")

                }
                try! realm.write {
                    week.days.append(day)
                }
                print("lessons 1\(day.lessons)")

//                try! realm.write{
//        
//                }
                switch oneDay.dayName! {
                case "Monday":
                    oneWeek.days?[0] = oneDay
                    break
                case "Tuesday":
                    oneWeek.days?[1] = oneDay
                    break
                case "Wednesday":
                    oneWeek.days?[2] = oneDay
                    break
                case "Thursday":
                    oneWeek.days?[3] = oneDay
                    break
                case "Friday":
                    oneWeek.days?[4] = oneDay
                    break
                case "Saturday":
                    oneWeek.days?[5] = oneDay
                    break
                default:
                    oneWeek.days?[6] = oneDay
                }
                oneWeek.number = semestr.1["weekNum"].int!
            }
            
        }
        
        try! realm.write {
            rasp.weeks.append(week)
        }

        
        if(oneWeek.days?.count > 6)
        {
            sevenDayWeek = true
        }
//        print(oneWeek.days?.count)
        
        try! realm.write() {
            
        }
        schedule.append(oneWeek)
        try! realm.write(){
            realm.add(rasp, update: true)
        }
    }
    
    successBlock(schedule)
    SwiftSpinner.hide()
}

func getDayOfWeek()->Int? {

    let todaysDate:NSDate = NSDate()
    print(todaysDate)
    let calendar = NSCalendar.currentCalendar();
    calendar.firstWeekday = 2
    let myComponents = calendar.components(.Weekday, fromDate: todaysDate)
    let dayOfWeek = (myComponents.weekday + 7 - calendar.firstWeekday) % 7 + 1
  
    
    return ((dayOfWeek - 1) > 5) ? (5) : (dayOfWeek - 1)
}

func datesForCurrentWeek() -> [NSDate]
{
    let date = NSDate()
    let calendar = NSCalendar.currentCalendar()
    
    let components = calendar.components([.Weekday], fromDate: date)
    let weekday = components.weekday == 1 ? 8 : components.weekday
    
    var weekArray = [NSDate]()
    
    for i in 2 ... 8
    {
        let components = NSDateComponents()
        components.day = i - weekday
        weekArray.append(calendar.dateByAddingComponents(components, toDate: date, options: [])!)
    }
    print("week is \(weekArray)")
    return weekArray

    
}

