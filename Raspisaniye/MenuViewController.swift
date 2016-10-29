//
//  MenuViewController.swift
//  Raspisaniye
//
//  Created by _ on 9/7/16.
//  Copyright © 2016 rGradeStd. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {
    @IBOutlet var menuItems:MenuItems?
    @IBAction func change_group(_ sender: AnyObject) {
        
        defaults.set(false, forKey: "isLogined")
        if let vc = storyboard?.instantiateViewController(withIdentifier: "LoginViewOneControllerID") as?
            LoginViewOneController
        {
            navigationController?.pushViewController(vc, animated: true)
            self.present(vc, animated: true, completion: nil)
//            self.present(vc, animated: true, completion: nil)

        }
    }
    
    
    @IBOutlet weak var group_name: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        menuItems?.addLabel()
        group_name.text = defaults.value(forKey: "subjectName") as? String
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
