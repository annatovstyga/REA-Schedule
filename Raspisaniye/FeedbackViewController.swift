//
//  ViewController.swift
//  Raspisaniye
//
//  Created by adam musallam on 20.10.16.
//  Copyright © 2016 rGradeStd. All rights reserved.
//

import UIKit

class FeedbackViewController: UIViewController {

    @IBAction func FeedbackClick(_ sender: Any) {
        if let url = NSURL(string: "http://www.itlab.styleru.net/"){
            UIApplication.shared.openURL(url as URL)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
       override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
