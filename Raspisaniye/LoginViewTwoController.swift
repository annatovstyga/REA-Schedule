//
//  LoginViewTwoController.swift
//  
//
//  Created by rGradeStd on 1/24/16.
//
//

import UIKit
import Foundation
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
        
        textField.autocompleteType = .Sentence
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
        
        textField.autocorrectionType = .No
        self.textField.delegate = self;
        for (value, _) in lectorsNamesList {
            lectorsArray.append(value)
        }
        lectorsArray.sortInPlace(before)
        
        for (value, _) in groupNamesList {
            groupsArray.append(value)
        }
        groupsArray.sortInPlace(before)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(LoginViewTwoController.keyboardWillShow(_:)), name:UIKeyboardWillShowNotification, object: nil);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(LoginViewTwoController.keyboardWillHide(_:)), name:UIKeyboardWillHideNotification, object: nil);
        
        super.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }

    @IBAction func enterClick(sender: AnyObject) {
        
    if((self.textField.suggestionNormal.lowercaseString.rangeOfString(self.textField.text!.lowercaseString)) != nil)
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
                subjectIDMemory   = defaults.objectForKey("subjectID") as? Int ?? Int()
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
        let alertController = UIAlertController(title: "Некоректный ввод!", message:
            "Попробуйте ввести название группы правильно", preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default,handler: nil))
        self.presentViewController(alertController, animated: true, completion: nil)
    }

    
    func enter()
    {
        defaults.setBool(true, forKey: "isLogined")
        //      (subjectIDMemory, subjectNameMemory)  = subjectName
        defaults.setObject(subjectName.0, forKey: "subjectID")
        defaults.setObject(subjectName.1, forKey: "subjectName")
        dispatch_async(dispatch_get_main_queue(), {
            updateSchedule(itemID: subjectName.0, successBlock: {
                successBlock in
                dispatch_async(dispatch_get_main_queue(), {
                parse(jsonDataList!, successBlock: { (parsed) in
                    let aDelegate = UIApplication.sharedApplication().delegate
                    let mainVcIntial = kConstantObj.SetIntialMainViewController("mainTabBar")
                    aDelegate!.window?!.rootViewController = mainVcIntial
                    aDelegate!.window?!.makeKeyAndVisible()
                })
                })
            })
        })
    }
    
    private let data: [String] = {
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
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.textField.text = self.textField.suggestion
        self.view.endEditing(true)
        return false
    }

    func keyboardWillShow(sender: NSNotification) {
        self.view.frame.origin.y = -150
      
    }
    
    func keyboardWillHide(sender: NSNotification) {
        self.view.frame.origin.y = 0
    }
}
