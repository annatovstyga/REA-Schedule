//Created by rGradeStd

import UIKit
import RealmSwift
let kConstantObj = kConstant()
@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate {

var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        print("REALMFILE - \(Realm.Configuration.defaultConfiguration.fileURL!)")
        isLogined = defaults.objectForKey("isLogined") as? Bool ?? Bool()
        
        if(isLogined ==  false) {
            let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
            let initialViewController = storyboard.instantiateViewControllerWithIdentifier("LoginViewOneControllerID")
            self.window?.rootViewController = initialViewController
            self.window?.makeKeyAndVisible()
        }else{
            let mainVcIntial = kConstantObj.SetIntialMainViewController("mainTabBar")
            self.window?.rootViewController = mainVcIntial
            self.window?.makeKeyAndVisible()
        }

        return true
    }
}
