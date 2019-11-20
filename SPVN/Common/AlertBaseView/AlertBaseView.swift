//
//  AlertBaseView.swift
//  SPVN
//
//  Created by ntq on 11/26/19.
//  Copyright © 2019 DuyDV. All rights reserved.
//

import Foundation
import UIKit

class AlertView {
    static let shared = AlertView()
    typealias handler = () -> ()
    
    func genarateMessage(messages: [String]) -> String {
        var displayMessage = ""
        for (i, element) in messages.enumerated() {
            displayMessage = displayMessage + element
            if i < messages.count - 1 {
                
                displayMessage = displayMessage + "\n"
            }
        }
        
        return displayMessage
    }
    
    func showAlert(title: String? = nil, message: String? = nil, handerLeft: handler? = nil, handerRight: handler? = nil, title_btn_left: String? = nil, title_btn_right: String? = nil, viewController: UIViewController? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        if title_btn_left != nil {
            let okAction = UIAlertAction(title: title_btn_left, style: .default) { (action:UIAlertAction) in
                handerLeft?()
            }
            alertController.addAction(okAction)
        }
        
        if title_btn_right != nil {
            let cancelAction = UIAlertAction(title: title_btn_right, style: .default) { (action:UIAlertAction) in
                handerRight?()
            }
            alertController.addAction(cancelAction)
        }
        
        
        if viewController != nil {
            viewController?.present(alertController, animated: true, completion: nil)
        } else {
            appDelegate().window?.rootViewController?.present(alertController, animated: true, completion: nil)
        }
    }
    
    func showActionSheet(title: String? = nil, message: String? = nil, handerCameraRoll: handler? = nil, handerCloud: handler? = nil, title_btn_camera_roll: String? = nil, title_btn_cloud: String? = nil, viewController: UIViewController? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        if title_btn_camera_roll != nil {
            let cameraRollAction = UIAlertAction(title: title_btn_camera_roll, style: .default) { (action:UIAlertAction) in
                handerCameraRoll?()
            }
            alertController.addAction(cameraRollAction)
        }
        if title_btn_cloud != nil {
            let cloudlAction = UIAlertAction(title: title_btn_cloud, style: .default) { (action:UIAlertAction) in
                handerCloud?()
            }
            alertController.addAction(cloudlAction)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default) { (action: UIAlertAction) in }
        alertController.addAction(cancelAction)
        if viewController != nil {
            viewController?.present(alertController, animated: true, completion: nil)
        } else {
            appDelegate().window?.rootViewController?.present(alertController, animated: true, completion: nil)
        }
    }
}

