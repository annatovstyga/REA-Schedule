import UIKit



@IBDesignable
class CustomBtn: UIButton {
    
    @IBInspectable var isFilled : Bool = false
    @IBInspectable var btnColor: UIColor = UIColor.white
    
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
    }
}
