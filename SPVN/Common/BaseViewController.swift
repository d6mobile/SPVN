//
//  BaseViewController.swift
//  SPVN
//
//  Created by ntq on 11/18/19.
//  Copyright © 2019 DuyDV. All rights reserved.
//

import Foundation
import UIKit
import SCLAlertView

class BaseViewController: UIViewController {
    
    @IBOutlet private weak var banner: UIView!
    @IBOutlet private weak var heightBanner: NSLayoutConstraint!
    @IBOutlet private weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        setupViewController()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard let navi = self.navigationController as? BaseNaviController else { return }
        if navi.imageView != nil {
            navi.showImage(true)
        }
    }
    
    /// Creat Folder
    /// - Requires:
    /// - Parameter placeholder: --> Show placeholder textField
    /// - Parameter title: -->  Show title TextField
    /// - Parameter subTitle: -->  Show subTitle TextField
    /// - Parameter complete: Return text fill TextFiled
    /// - Returns: Void
    func creatFolder(placeholder: String, title: String, subTitle: String, complete: @escaping (String) -> Void) {
        var alertView = SCLAlertView()
        let appearance = SCLAlertView.SCLAppearance(
            showCloseButton: false)
        alertView = SCLAlertView(appearance: appearance)
        
        // Add a text field
        
        var txtFieldName = UITextField()
        
        
        txtFieldName = alertView.addTextField("")
        txtFieldName.placeholder = placeholder // 
        
        alertView.addButton("Save", action: {
            if let text = txtFieldName.text {
                complete(text)
            }
        })
        
        alertView.addButton("Cancel", action: {})
        alertView.showEdit(title, subTitle: subTitle, closeButtonTitle: nil, timeout: nil, colorStyle: UInt(AppColor.shared.tintColorApp), colorTextButton: 0xffffff, circleIconImage: nil, animationStyle: SCLAnimationStyle.bottomToTop)
    }
    
    private func setupViewController() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(self.willResignActive), name: UIApplication.willResignActiveNotification, object: nil)
        self.view.backgroundColor = UIColor(rgb: 0x0E1121)
//        self.setAppLocker()
        if scrollView != nil {
            self.scrollView?.delegate = self
        }
    }
    
    @objc private func willResignActive() {
        if !AppLocker.isEmptyPinCode, !appDelegate().isLocked {
            appDelegate().isLocked = true
            self.pin(.validate, animated: false)
        }
    }
    
    private func setAppLocker() {
        if AppLocker.isEmptyPinCode {
            self.pin(.create, animated: false)
            appDelegate().isLocked = true
        } else if !AppLocker.isEmptyPinCode, !appDelegate().isLocked {
            appDelegate().isLocked = true
            self.pin(.validate, animated: false)
        }
    }
    
    func pin(_ mode: ALMode, animated: Bool = true) {
        
        var appearance = ALAppearance()
        appearance.image = UIImage(named: "face")!
        appearance.title = "Enter Passcode"
        appearance.isSensorsEnabled = true
        
        AppLocker.present(with: mode, and: appearance, style: .fullScreen, animated: animated)
    }
}

// MARK: - Scroll View Delegates
extension BaseViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let navi = self.navigationController as? BaseNaviController, navi.imageView != nil, let shoulResize = navi.shoulResize
            else { print("shoulResize wasn't set. reason could be non-handled device orientation state"); return }
        
        if shoulResize {
            navi.moveAndResizeImageForPortrait()
        }
    }
}
