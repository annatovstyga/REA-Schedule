//Created by rGradeStd

import UIKit
import RealmSwift
let kConstantObj = kConstant()
@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate {

var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        print("REALMFILE - \(Realm.Configuration.defaultConfiguration.fileURL!)")
        isLogined = defaults.object(forKey: "isLogined") as? Bool ?? Bool()
        
        if(isLogined ==  false) {
            let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            let initialViewController = storyboard.instantiateViewController(withIdentifier: "LoginViewOneControllerID")
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
