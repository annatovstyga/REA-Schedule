import UIKit

class MainNavigationSegue: UIStoryboardSegue {
    
    override func perform() {
        
        let tabBarController = self.source as! MMSwiftTabBarController
        let destinationController = self.destination as UIViewController
        
        for view in tabBarController.placeholderView.subviews as [UIView] {
            view.removeFromSuperview()
        }
        
      
        tabBarController.currentViewController = destinationController
        tabBarController.placeholderView.addSubview(destinationController.view)
        
        
        tabBarController.placeholderView.translatesAutoresizingMaskIntoConstraints = false
        destinationController.view.translatesAutoresizingMaskIntoConstraints = false
        
        let horizontalConstraint = NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[v1]-0-|", options: .alignAllTop, metrics: nil, views: ["v1": destinationController.view])
        
        tabBarController.placeholderView.addConstraints(horizontalConstraint)
        
        let verticalConstraint = NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[v1]-0-|", options: .alignAllTop, metrics: nil, views: ["v1": destinationController.view])
        
        tabBarController.placeholderView.addConstraints(verticalConstraint)

        tabBarController.placeholderView.layoutIfNeeded()
        destinationController.didMove(toParentViewController: tabBarController)

    }

}
