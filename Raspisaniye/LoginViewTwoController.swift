//
//  LoginViewTwoController.swift
//  
//
//  Created by rGradeStd on 1/24/16.
//
//

import UIKit
import Foundation
import CCAutocomplete
import RealmSwift

class LoginViewTwoController: UIViewController,UITextFieldDelegate{
    
    // MARK: - Properties

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var label_IT_lab_: UILabel!
    @IBOutlet weak var REALogo: UIImageView!

    var autoCompleteViewController: AutoCompleteViewController!//внутренний контроллер поля с автодополнением.Нигде не используется кроме внутреннего инициализатора.
    @IBOutlet weak var placeholderView: UIView!

    // MARK: - View methods
    var isStudent = false
    var isFirstLoad = true
    override func viewDidLoad() {
        
        textField.delegate = self
        textField.autocorrectionType = .no
        let realm = try! Realm()
        lectorsArray = [String]()
        groupsArray = [String]()
        if(isStudent){
            let result = realm.objects(Unit.self).filter("type = 0")
            for item in result{
                groupsArray.append(item.name)
            }
            groupsArray.sort(by: before)
            textField.placeholder = "Введите вашу группу"
        }
        else{
            textField.placeholder = "Введите имя преподавателя"
            let result = realm.objects(Unit.self).filter("type = 1")

            for item in result{
                lectorsArray.append(item.name)
            }

            lectorsArray.sort(by: before)

        }



        /*!!! НЕ ЗАБЫВАТЬ УДАЛЯТЬ !!!*/
        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewTwoController.keyboardWillShow(_:)), name:NSNotification.Name.UIKeyboardWillShow, object: nil);
        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewTwoController.keyboardWillHide(_:)), name:NSNotification.Name.UIKeyboardWillHide, object: nil);
        
        super.viewDidLoad()


    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        if self.isFirstLoad {
            self.isFirstLoad = false
            Autocomplete.setupAutocompleteForViewcontroller(self) // Устанавливать всегда только один раз,либо будет постоянно вылетать автодополнения
        }
    }

    @IBAction func enterClick(_ sender: AnyObject) {
        view.endEditing(true)
        
        let realm = try! Realm()

        let predicate = NSPredicate(format: "name = %@",self.textField.text!)
        let lectorIDObject = realm.objects(Unit.self).filter(predicate)
        let lectorID = lectorIDObject.first?.ID
        defaults.set(lectorID, forKey: "subjectID")
        defaults.set(lectorIDObject.first?.name, forKey: "subjectName")
        if(lectorID != nil){
            self.enter(ID: lectorID!,type:(lectorIDObject.first?.type)!)
        }else{
            showWarning()
        }
    }
    
    //func dismissKeyboard() {
      //  view.endEditing(true)
    //}
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func showWarning() {
        let alertController = UIAlertController(title: "Не найдено данных!", message:
            "Попробуйте проверить имя/название", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default,handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }

    func enter(ID:Int,type:Int)
    {
        defaults.set(true, forKey: "isLogined")

        DispatchQueue.main.async(execute: {
            updateSchedule(itemID: ID,type:type, successBlock: {
                successBlock in
                DispatchQueue.main.async(execute: {
                    parse(jsonDataList!,realmName:"default", successBlock: { (parsed) in
                    let aDelegate = UIApplication.shared.delegate
                    let mainVcIntial = kConstantObj.SetIntialMainViewController("mainTabBar")
                    aDelegate!.window?!.rootViewController = mainVcIntial
                    aDelegate!.window?!.makeKeyAndVisible()
                })
                })
            })
        })
    }

    func keyboardWillShow(_ sender: Notification) {
        if let keyboardSize = (sender.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
      
    }
    
    func keyboardWillHide(_ sender: Notification) {
        if let keyboardSize = (sender.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += keyboardSize.height
            }
        }
    }
}


extension LoginViewTwoController: AutocompleteDelegate {
    func autoCompleteTextField() -> UITextField {
        return self.textField
    }
    func autoCompleteThreshold(_ textField: UITextField) -> Int {
        return 1
    }

    func autoCompleteItemsForSearchTerm(_ term: String) -> [AutocompletableOption] {
        //FIXME переименовать переменные
        var filteredCountries = [String]()
        if(isStudent){
            filteredCountries = groupsArray.filter { (country) -> Bool in
                return country.lowercased().contains(term.lowercased())
            }
        }else{
            filteredCountries = lectorsArray.filter { (country) -> Bool in
                return country.lowercased().contains(term.lowercased())
            }
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
