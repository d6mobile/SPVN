//
//  UIViewController+Extension.swift
//  AngelNet
//
//  Created by NTQ on 9/13/18.
//  Copyright © 2018 NTQ. All rights reserved.
//

import Foundation
import UIKit

func classDomain<T>(_ object: T.Type) -> String {
    return String(describing: object)
}

extension UIViewController {
    
    var isPortrait: Bool {
        let orientation = UIDevice.current.orientation
        switch orientation {
        case .portrait, .portraitUpsideDown:
            return true
        case .landscapeLeft, .landscapeRight:
            return false
        default: // unknown or faceUp or faceDown
            guard let window = self.view.window else { return false }
            return window.frame.size.width < window.frame.size.height
        }
    }
    
    class func controller<T: UIViewController>(from storyboard: String, storyboardID: String? = nil) -> T {
        // swiftlint:disable force_cast
        let storyboard = UIStoryboard(name: storyboard, bundle: nil)
        if let identifier = storyboardID {
            return storyboard.instantiateViewController(withIdentifier: identifier) as! T
        }
        
        if let instance = storyboard.instantiateViewController(withIdentifier:classDomain(T.self)) as? T {
            return instance
        } else {
            return storyboard.instantiateInitialViewController() as! T
        }
    }

    class func controller(from storyboard: String, storyboardID: String? = nil) -> Self {
        // swiftlint:disable force_cast
        let storyboard = UIStoryboard(name: storyboard, bundle: nil)
        var vc: UIViewController!
        if let identifier = storyboardID {
            vc = storyboard.instantiateViewController(withIdentifier: identifier)
        }
        else {
            vc = storyboard.instantiateInitialViewController()
        }

        return unsafeDowncast(vc, to: self)
    }

    class func topMostViewController() -> UIViewController? {
        return UIViewController.topViewControllerForRoot(rootViewController: UIApplication.shared.keyWindow?.rootViewController)
    }
    
    class func topMostViewControllerForChat() -> UIViewController? {
        //        return UIViewController.topViewControllerForChat(rootViewController: UIApplication.shared.keyWindow?.rootViewController)
        return self.topMostViewController()
    }
    
    class func topViewControllerForChat(rootViewController:UIViewController?) -> UIViewController? {
        guard let rootViewController = rootViewController else {
            return nil
        }
        
        guard let presented = rootViewController.presentedViewController else {
            switch rootViewController {
            case is UINavigationController:
                let navigationController:UINavigationController = rootViewController as! UINavigationController
                return navigationController.viewControllers.last
                
            case is UITabBarController:
                let tabBarController: UITabBarController = rootViewController as! UITabBarController
                return UIViewController.topViewControllerForChat(rootViewController: tabBarController.selectedViewController)
            default:
                return rootViewController
            }
        }
        
        switch presented {
        case is UINavigationController:
            let navigationController:UINavigationController = presented as! UINavigationController
            return navigationController.viewControllers.last
            
        case is UITabBarController:
            let tabBarController: UITabBarController = presented as! UITabBarController
            return UIViewController.topViewControllerForChat(rootViewController: tabBarController.selectedViewController)
            
        default:
            return presented
        }
    }
    
    
    class func topViewControllerForRoot(rootViewController:UIViewController?) -> UIViewController? {
        guard let rootViewController = rootViewController else {
            return nil
        }
        
        if rootViewController is UINavigationController {
            let navigationController:UINavigationController = rootViewController as! UINavigationController
            return UIViewController.topViewControllerForRoot(rootViewController: navigationController.viewControllers.last)
            
        } else if rootViewController is UITabBarController {
            let tabBarController:UITabBarController = rootViewController as! UITabBarController
            return UIViewController.topViewControllerForRoot(rootViewController: tabBarController.selectedViewController)
            
        } else if rootViewController.presentedViewController != nil {
            //            return rootViewController.presentedViewController
            return UIViewController.topViewControllerForRoot(rootViewController: rootViewController.presentedViewController)
        } else {
            return rootViewController
        }
    }

    func endEditing() { view.endEditing(true) }
}
