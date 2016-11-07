import UIKit
import Alamofire
import RealmSwift

class LoginViewOneController: UIViewController {

    let realm = try! Realm()
    @IBOutlet weak var label_IT_lab: UILabel!

    @IBAction func studClick(_ sender: AnyObject) {
        fetchUnitsToRealm()
        self.performSegue(withIdentifier: "studLogin", sender: nil)
        amistudent = true //обновляем,т.к. храним в global
        UserDefaults.standard.set(true, forKey: "amistudent")
    }

    @IBAction func lectorClick(_ sender: AnyObject) {
        fetchUnitsToRealm()
        self.performSegue(withIdentifier: "lectorLogin", sender: nil)
        amistudent = false
        UserDefaults.standard.set(false, forKey: "amistudent")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func fetchUnitsToRealm() //Получаем сразу все данные.Лучше всего в одном запросе всегда получать
    {

        try! self.realm.write {
            realm.deleteAll()
        }

        InternetManager.sharedInstance.getLectorsList({
            success in
            let groups = success["success"]["data"]

            for item in groups {
                let idLector   = item.1["ID"].int!
                let nameLector = item.1["name"].string!
                lectorsNamesList[nameLector] = idLector

                let unitToAdd = Unit()
                unitToAdd.name = nameLector
                unitToAdd.ID = idLector
                unitToAdd.type = 1
                try! self.realm.write(){
                    self.realm.add(unitToAdd,update:false)
                }

            }
            for (value, _) in lectorsNamesList {
                lectorsArray.append(value)
            }
            lectorsArray.sort(by: before)
        }, failure:{error in print(error)
            self.showWarning()
        })

        InternetManager.sharedInstance.getGroupList({
            success in
            let groups = success["success"]["data"]
            for item in groups {
                let idGroup   = item.1["ID"].int!
                let nameGroup = item.1["name"].string!
                groupNamesList[nameGroup] = idGroup
                let unitToAdd = Unit()
                unitToAdd.name = nameGroup
                unitToAdd.ID = idGroup
                unitToAdd.type = 0
                try! self.realm.write(){
                    self.realm.add(unitToAdd,update:true)//change
                }

            }
            for (value, _) in groupNamesList {
                groupsArray.append(value)
            }
            groupsArray.sort(by: before)
        }, failure:{error in print(error)
            self.showWarning()
        })

    }

    func showWarning() {
        let alertController = UIAlertController(title: "Connection error!", message:
            "При получении данных произошла проблема", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default,handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        let dsVC = segue.destination as! LoginViewTwoController
        if(segue.identifier == "lectorLogin"){
            dsVC.isStudent = false
        }else{
            dsVC.isStudent = true
        }
    }
}
