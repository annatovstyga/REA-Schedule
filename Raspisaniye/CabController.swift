import UIKit

class CabController: UIViewController {
    
    
    @IBAction func firstBtnClick(_ sender: AnyObject) {
        performSegue(withIdentifier: "cabTabSegue", sender: tabBarButtons[0])
        
    }
    @IBAction func secondBtnClick(_ sender: AnyObject) {
        performSegue(withIdentifier: "cabTabSegue", sender: tabBarButtons[1])
    }
    
    var currentViewController: UIViewController?
    @IBOutlet var placeholderView: UIView!
    @IBOutlet var tabBarButtons: Array<UIButton>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        performSegue(withIdentifier: "cabTabSegue", sender: tabBarButtons[0])
    }
    
    override var shouldAutorotate : Bool {
        return true
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let availableIdentifiers = ["cabTabSegue"]
        if(availableIdentifiers.contains(segue.identifier!) ) {
            
        }
    }
}
