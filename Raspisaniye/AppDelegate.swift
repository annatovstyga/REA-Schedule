//Created by rGradeStd

import UIKit
import RealmSwift
let kConstantObj = kConstant()
@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate {

var window: UIWindow?

func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        print("REALMFILE - \(Realm.Configuration.defaultConfiguration.fileURL!)")
        let mainVcIntial = kConstantObj.SetIntialMainViewController("mainTabBar")
        self.window?.rootViewController = mainVcIntial
        self.window?.makeKeyAndVisible()
    
        // Override point for customization after application launch.
        return true
}

func updateSch()
    {
        SwiftSpinner.show("")
        let id = defaults.objectForKey("subjectID") as! Int
        print("ID = \(id)")
        dispatch_async(dispatch_get_main_queue(), {
            self.updateSchedule(itemID: id, successBlock: {
                successBlock in
                dispatch_async(dispatch_get_main_queue(), {
                    parse(jsonDataList!,successBlock:
                        {
                            successBlock in
                            totalSchedule = successBlock
                            let mainStoryboardIpad : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                            let initialViewControlleripad : MMSwiftTabBarController = mainStoryboardIpad.instantiateViewControllerWithIdentifier("mainTabBar") as! MMSwiftTabBarController
                           let viewCR = self.getCurrentViewController() as! MMSwiftTabBarController
                        
//                            self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
//                            self.window?.rootViewController = initialViewControlleripad
////                            self.window?.makeKeyAndVisible()
//                            self.window?.becomeKeyWindow()
//                            initialViewControlleripad.updateScheduleProperties(initialViewControlleripad.selectedDay)
//                            initialViewControlleripad.performSegueWithIdentifier("mainSegue", sender: initialViewControlleripad.tabBarButtons[initialViewControlleripad.selectedDay!])
                            viewCR.updateScheduleProperties(viewCR.selectedDay!)
                            viewCR.performSegueWithIdentifier("mainSegue", sender: viewCR.tabBarButtons[viewCR.selectedDay!])
                    })
                    
                })
            })
        })
    }
    
    func getNavigationController()-> UINavigationController? {
        if let navigationController = UIApplication.sharedApplication().keyWindow?.rootViewController  {
            
            return navigationController as? UINavigationController
        }
        return nil
    }
    
    // Returns the most recently presented UIViewController (visible)
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
    
        // Returns the navigation controller if it exists
     
    func updateSchedule(itemID itemID: Int, successBlock: Void -> ()) {
        var Who:String = "lector"
        if(amistudent)
        {
            Who = "group"
        }
        print(Who)
        InternetManager.sharedInstance.getLessonsList(["who":Who,"id":itemID,"timestamp":0], success: {
            success in
            jsonDataList = success
            successBlock()
            }, failure: {error in
                print(error)})
    }

  
    
}
