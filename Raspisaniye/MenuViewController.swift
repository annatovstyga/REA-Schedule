//
//  MenuViewController.swift
//  Raspisaniye
//
//  Created by _ on 9/7/16.
//  Copyright © 2016 rGradeStd. All rights reserved.
//

import UIKit
import CCAutocomplete
import RealmSwift

class MenuViewController: UIViewController {
    var searchArray = [String]()
    @IBOutlet var menuItems:MenuItems?
    var isFirstLoad = true
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        if self.isFirstLoad {
            self.isFirstLoad = false
            Autocomplete.setupAutocompleteForViewcontroller(self)
        }
    }

    @IBAction func change_group(_ sender: AnyObject) {
        defaults.set(false, forKey: "isLogined")
        if let vc = storyboard?.instantiateViewController(withIdentifier: "LoginViewOneControllerID") as?
            LoginViewOneController
        {
            self.view.window?.rootViewController = vc;//making a view to root view
            self.view.window?.makeKeyAndVisible()
        }

    }


    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var group_name: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        menuItems?.addLabel()
        group_name.text = defaults.value(forKey: "subjectName") as? String
    }

    override func viewWillAppear(_ animated: Bool) {
        let realm = try! Realm()
        let results = realm.objects(Unit.self)
        for item in results{
            self.searchArray.append(item.name)
        }
    }

    @IBAction func searchClick(_ sender: Any) {
        let realm = try! Realm()
        let predicate = NSPredicate(format: "name = %@",self.textField.text!)
        let lectorIDObject = realm.objects(Unit.self).filter(predicate)
        let lectorID = lectorIDObject.first
        //получем расписание по поиску и парсим его в реалм search
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
        let alertController = UIAlertController(title: "Не найдено ничего по запросу!", message:
            "Попробуйте проверить имя/название", preferredStyle: UIAlertControllerStyle.alert)
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
    }

    func autoCompleteThreshold(_ textField: UITextField) -> Int {
        return 2
    }

    func autoCompleteItemsForSearchTerm(_ term: String) -> [AutocompletableOption] {
        var filteredCountries = [String]()
        //FIXIT переименовать переменные
        filteredCountries = self.searchArray.filter { (country) -> Bool in
            return country.lowercased().contains(term.lowercased())
        }

        let countriesAndFlags: [AutocompletableOption] = filteredCountries.map { ( country) -> AutocompleteCellData in
            var country = country
            country.replaceSubrange(country.startIndex...country.startIndex, with: String(country.characters[country.startIndex]).capitalized)
            return AutocompleteCellData(text: country, image: UIImage(named: country))
            }.map( { $0 as AutocompletableOption })

        return countriesAndFlags
    }

    func autoCompleteHeight() -> CGFloat {
        return self.view.frame.height / 3.0
    }

    func didSelectItem(_ item: AutocompletableOption) {
        self.textField.text = item.text
    }
}

