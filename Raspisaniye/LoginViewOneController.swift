import UIKit
import Alamofire

class LoginViewOneController: UIViewController {

    @IBOutlet weak var label_IT_lab: UILabel!
    @IBAction func studClick(_ sender: AnyObject) {
        
        InternetManager.sharedInstance.getGroupList({
            success in
            let groups = success["success"]["data"]
            for item in groups {
                let idGroup   = item.1["ID"].int!
                let nameGroup = item.1["name"].string!
                groupNamesList[nameGroup] = idGroup
            }
            for (value, _) in groupNamesList {
                groupsArray.append(value)
            }
            groupsArray.sort(by: before)
            self.performSegue(withIdentifier: "studLogin", sender: sender)
            }, failure:{error in print(error)
                self.showWarning()
        })
        
        
    }

    @IBAction func lectorClick(_ sender: AnyObject) {
        InternetManager.sharedInstance.getLectorsList({
            success in
            let groups = success["success"]["data"]
            
            for item in groups {
                let idLector   = item.1["ID"].int!
                let nameLector = item.1["name"].string!
                lectorsNamesList[nameLector] = idLector
                
            }
            for (value, _) in lectorsNamesList {
                lectorsArray.append(value)
            }
            lectorsArray.sort(by: before)
            self.performSegue(withIdentifier: "lectorLogin", sender: sender)
            }, failure:{error in print(error)
                self.showWarning()
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

 
    }

    func showWarning() {
        let alertController = UIAlertController(title: "Connection error!", message:
            "При получении данных произошла проблема", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default,handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        
        if(segue.identifier == "studLogin"){
            slString = "group"
            amistudent = true;
            defaults.set(true, forKey: "amistudent")
        }
        else{
            slString = "lector"
            amistudent = false;
            defaults.set(false, forKey: "amistudent")
        }

    }
}
