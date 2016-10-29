import UIKit

class CabNavSegue: UIStoryboardSegue {
    
    override func perform() {
        
        let CabBarController = self.source as! CabController
        let destinationController = self.destination as UIViewController
        
        for view in CabBarController .placeholderView.subviews as [UIView] {
            view.removeFromSuperview()
        }
        
        
      CabBarController.currentViewController = destinationController
      CabBarController.placeholderView.addSubview(destinationController.view)
        
        CabBarController.placeholderView.translatesAutoresizingMaskIntoConstraints = false
        destinationController.view.translatesAutoresizingMaskIntoConstraints = false
        
        let horizontalConstraint = NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[v1]-0-|", options: .alignAllTop, metrics: nil, views: ["v1": destinationController.view])
        
        CabBarController.placeholderView.addConstraints(horizontalConstraint)
        
        let verticalConstraint = NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[v1]-0-|", options: .alignAllTop, metrics: nil, views: ["v1": destinationController.view])
        
        CabBarController.placeholderView.addConstraints(verticalConstraint)
        
        CabBarController.placeholderView.layoutIfNeeded()
        destinationController.didMove(toParentViewController: CabBarController)
        
        
    }
    
}
