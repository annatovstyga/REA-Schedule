//
//  CustomTextFld.swift
//  Raspisaniye
//
//  Created by rGradeStd on 1/25/16.
//  Copyright © 2016 rGradeStd. All rights reserved.
//

import UIKit

@IBDesignable
class CustomTextFld: UITextField {
    @IBInspectable var isFilled : Bool = false
    @IBInspectable var btnColor: UIColor = UIColor.white
    var placegolderText: String = "Введите "
    override func draw(_ rect: CGRect) {
        
        let path = UIBezierPath(roundedRect: rect, cornerRadius: 6)
        btnColor.set()
        
        if(isFilled)
        {
            path.fill()
        }
        else
        {
            path.stroke()
        }
       self.attributedPlaceholder =  NSAttributedString(string:placegolderText,
            attributes:[NSForegroundColorAttributeName: UIColor.white])
    }
}
