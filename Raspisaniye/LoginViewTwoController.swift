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
class LoginViewTwoController: UIViewController,UITextFieldDelegate{
    
    // MARK: - Properties

    @IBOutlet weak var label_IT_lab_: UILabel!
    @IBOutlet weak var REALogo: UIImageView!
    var tempID:Int? = 0
    
    @IBOutlet weak var placeholderView: UIView!
    var timestamp: Int = 0
    var currentWeek: Int = 0
    // MARK: - View methods
    
    
    override func viewDidLoad() {
        
        textField.autocompleteType = .sentence
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        if(amistudent){
            textField.placeholder = "Введите вашу группу"
            textField.suggestions = groupsArray
        }
        else{
            textField.placeholder = "Введите имя преподавателя"
            textField.suggestions = lectorsArray
        }
        
        textField.autocorrectionType = .no
        self.textField.delegate = self;
        for (value, _) in lectorsNamesList {
            lectorsArray.append(value)
        }
        lectorsArray.sort(by: before)
        
        for (value, _) in groupNamesList {
            groupsArray.append(value)
        }
        groupsArray.sort(by: before)
        
        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewTwoController.keyboardWillShow(_:)), name:NSNotification.Name.UIKeyboardWillShow, object: nil);
        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewTwoController.keyboardWillHide(_:)), name:NSNotification.Name.UIKeyboardWillHide, object: nil);
        
        super.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }

    @IBAction func enterClick(_ sender: AnyObject) {
        
    if((self.textField.suggestionNormal.lowercased().range(of: self.textField.text!.lowercased())) != nil)
        {
            self.textField.text = self.textField.suggestionNormal
        }
        else
        {
            self.textField.text = ""
        }
       
        if (amistudent) {
            let groupNameTemp = textField.text
            let indexTemp = groupNamesList[groupNameTemp!]
        
            if(indexTemp != nil){
                subjectName = (indexTemp!, groupNameTemp!)
                self.enter()
                subjectIDMemory   = defaults.object(forKey: "subjectID") as? Int ?? Int()
            }
            else{
                self.showWarning()
            }
        } else {
            
            let lectorNameTemp = textField.text
            
            let indexTempLector = lectorsNamesList[lectorNameTemp!]
            if(indexTempLector != nil){
                subjectName = (indexTempLector!, lectorNameTemp!)
                self.enter()
            }
            else{
                self.showWarning()
            }
        }
 
        
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @IBOutlet weak var textField: AutocompleteField!
    
    func showWarning() {
        let alertController = UIAlertController(title: "Некорректный ввод!", message:
            "Попробуйте ввести название группы правильно", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default,handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }

    
    func enter()
    {
        defaults.set(true, forKey: "isLogined")
        //      (subjectIDMemory, subjectNameMemory)  = subjectName
        defaults.set(subjectName.0, forKey: "subjectID")
        defaults.set(subjectName.1, forKey: "subjectName")
        DispatchQueue.main.async(execute: {
            updateSchedule(itemID: subjectName.0, successBlock: {
                successBlock in
                DispatchQueue.main.async(execute: {
                parse(jsonDataList!, successBlock: { (parsed) in
                    let aDelegate = UIApplication.shared.delegate
                    let mainVcIntial = kConstantObj.SetIntialMainViewController("mainTabBar")
                    aDelegate!.window?!.rootViewController = mainVcIntial
                    aDelegate!.window?!.makeKeyAndVisible()
                })
                })
            })
        })
    }
    
    fileprivate let data: [String] = {
            var data:[String] = []
            if(amistudent){
                 data = groupsArray
                            }
            else{
                data = lectorsArray
            }
        return data
    }()
    
    // MARK: - IBActions
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.textField.text = self.textField.suggestion
        self.view.endEditing(true)
        return false
    }

    func keyboardWillShow(_ sender: Notification) {
        self.view.frame.origin.y = -150
      
    }
    
    func keyboardWillHide(_ sender: Notification) {
        self.view.frame.origin.y = 0
    }
}
