
import UIKit

extension UINavigationController {
    
    // For Xcode 9 users, childForStatusBarStyle is equal to childViewControllerForStatusBarStyle
    open override var childForStatusBarStyle: UIViewController? {
        return topViewController
    }
}
