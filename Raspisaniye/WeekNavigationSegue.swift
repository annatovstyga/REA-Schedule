import UIKit

class WeekNavigationSegue: UIStoryboardSegue {
    
    override func perform() {
        let tabBarController = self.source as! MMSwiftTabBarController
        let destinationController = self.destination as UIViewController
        
        let screenWidth = UIScreen.main.bounds.size.width
        
        tabBarController.currentViewController = destinationController
        tabBarController.placeholderView.addSubview(destinationController.view)
        
        
        tabBarController.placeholderView.translatesAutoresizingMaskIntoConstraints = false
        destinationController.view.translatesAutoresizingMaskIntoConstraints = false
        
        let horizontalConstraint = NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[v1]-0-|", options: .alignAllTop, metrics: nil, views: ["v1": destinationController.view])
        
        tabBarController.placeholderView.addConstraints(horizontalConstraint)
        
        let verticalConstraint = NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[v1]-0-|", options: .alignAllTop, metrics: nil, views: ["v1": destinationController.view])
        
        tabBarController.placeholderView.addConstraints(verticalConstraint)
        
        UIView.animate(withDuration: 0.4, animations: { () -> Void in

            destinationController.view.frame = destinationController.view.frame.offsetBy(dx: -segueSide*screenWidth, dy: 0.0)
            }, completion: { (Finished) -> Void in
                tabBarController.placeholderView.subviews.first?.removeFromSuperview()
        }) 
        
        tabBarController.placeholderView.layoutIfNeeded()
        destinationController.didMove(toParentViewController: tabBarController)
        
        
    }
    
}
