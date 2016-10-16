import UIKit

class LoginViewOneController: UIViewController {

    @IBOutlet weak var label_IT_lab: UILabel!
    @IBAction func studClick(sender: AnyObject) {
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
            groupsArray.sortInPlace(before)
            self.performSegueWithIdentifier("studLogin", sender: sender)
            }, failure:{error in print(error)
                self.showWarning()
        })
        
        
    }

    @IBAction func lectorClick(sender: AnyObject) {
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
            lectorsArray.sortInPlace(before)
            self.performSegueWithIdentifier("lectorLogin", sender: sender)
            }, failure:{error in print(error)
                self.showWarning()
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

 
    }

    func showWarning() {
        let alertController = UIAlertController(title: "Connection error!", message:
            "При получении данных произошла проблема", preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default,handler: nil))
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        
        if(segue.identifier == "studLogin"){
            slString = "group"
            amistudent = true;
            defaults.setBool(true, forKey: "amistudent")
        }
        else{
            slString = "lector"
            amistudent = false;
            defaults.setBool(false, forKey: "amistudent")
        }

    }
}
