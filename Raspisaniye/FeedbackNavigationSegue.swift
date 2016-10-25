import UIKit

class FeedbackNavigationSegue: UIStoryboardSegue {
    
    override func perform() {
        let tabBarController = self.sourceViewController as! MMSwiftTabBarController
        let destinationController = self.destinationViewController as UIViewController
        
        let screenWidth = UIScreen.mainScreen().bounds.size.width
        
        tabBarController.currentViewController = destinationController
        tabBarController.placeholderView.addSubview(destinationController.view)
        
        
        tabBarController.placeholderView.translatesAutoresizingMaskIntoConstraints = false
        destinationController.view.translatesAutoresizingMaskIntoConstraints = false
        
        let horizontalConstraint = NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[v1]-0-|", options: .AlignAllTop, metrics: nil, views: ["v1": destinationController.view])
        
        tabBarController.placeholderView.addConstraints(horizontalConstraint)
        
        let verticalConstraint = NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[v1]-0-|", options: .AlignAllTop, metrics: nil, views: ["v1": destinationController.view])
        
        tabBarController.placeholderView.addConstraints(verticalConstraint)
        
        UIView.animateWithDuration(0.4, animations: { () -> Void in
            
            destinationController.view.frame = CGRectOffset(destinationController.view.frame, -segueSide*screenWidth, 0.0)
        }) { (Finished) -> Void in
            tabBarController.placeholderView.subviews.first?.removeFromSuperview()
        }
        
        tabBarController.placeholderView.layoutIfNeeded()
        destinationController.didMoveToParentViewController(tabBarController)
        
        
    }
    
}
