//
//  MenuViewController.swift
//  Raspisaniye
//
//  Created by _ on 9/7/16.
//  Copyright © 2016 rGradeStd. All rights reserved.
//

import UIKit

<<<<<<< Updated upstream
class MenuViewController: UIViewController {
=======
class MenuViewController: UIViewController, UITextFieldDelegate {
    var searchArray = [String]()
>>>>>>> Stashed changes
    @IBOutlet var menuItems:MenuItems?
    @IBAction func change_group(_ sender: AnyObject) {
        
        defaults.set(false, forKey: "isLogined")
        if let vc = storyboard?.instantiateViewController(withIdentifier: "LoginViewOneControllerID") as?
            LoginViewOneController
        {
            self.view.window?.rootViewController = vc;//making a view to root view
            self.view.window?.makeKeyAndVisible()


//            navigationController?.pushViewController(vc, animated: true)
//            self.present(vc, animated: true, completion: nil)
//            self.present(vc, animated: true, completion: nil)

        }
    }
    
    
    @IBOutlet weak var group_name: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        textField.delegate = self
        menuItems?.addLabel()
        group_name.text = defaults.value(forKey: "subjectName") as? String
        
<<<<<<< Updated upstream
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
=======
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let realm = try! Realm()
        let results = realm.objects(Unit.self)
        print("rea - %@",results)
        for item in results{
            self.searchArray.append(item.name)
        }
    }
    @IBAction func searchClick(_ sender: Any) {
        view.endEditing(true)
        let realm = try! Realm()
        let predicate = NSPredicate(format: "name = %@",self.textField.text!)
        let lectorIDObject = realm.objects(Unit.self).filter(predicate)
        let lectorID = lectorIDObject.first
        print("YEAHTYPE - \(lectorID?.name)")
        if(lectorID != nil){
            DispatchQueue.main.async(execute: {
                updateSchedule(itemID: (lectorID?.ID)!,type:(lectorID?.type)!, successBlock: {
                    successBlock in
                    DispatchQueue.main.async(execute: {
                        parse(jsonDataList!,realmName:"search", successBlock: { (parsed) in
                                    self.performSegue(withIdentifier: "searchSegue", sender: lectorID)
                        })
                    })
                })
            })

        }else{
            showWarning()
        }

    }

    func showWarning() {
        let alertController = UIAlertController(title: "Некорректный ввод!", message:
            "Попробуйте ввести название группы правильно", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default,handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "searchSegue"){
            let unit:Unit = sender as! Unit
            let dsVC = segue.destination as! MMSwiftTabBarController
            dsVC.realmName = "search"
            dsVC.searchName = unit.name
        }
    }
}

extension MenuViewController: AutocompleteDelegate {

    func autoCompleteTextField() -> UITextField {
        return self.textField
>>>>>>> Stashed changes
    }
    
    @IBAction func buttonClick(_ sender: AnyObject) {

    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
