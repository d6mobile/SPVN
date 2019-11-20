//
//  BaseNaviController.swift
//  SPVN
//
//  Created by ntq on 11/18/19.
//  Copyright © 2019 DuyDV. All rights reserved.
//

import UIKit

protocol BaseNaviControllerProtocol {
    
}

class BaseNaviController: UINavigationController {
    
    var darkMode = false
    var naviView: NaviView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupNaviController()
    }
    
    private func setupNaviController() {
        self.navigationBar.prefersLargeTitles = true
        self.navigationItem.largeTitleDisplayMode = .never
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        UINavigationBar.appearance().largeTitleTextAttributes = textAttributes
        navigationBar.titleTextAttributes = textAttributes
        navigationBar.setBackgroundImage(UIImage(color: UIColor(red: 14.0/255, green: 17.0/255, blue: 33.0/255, alpha: 1)), for: .default)
        navigationBar.shadowImage = UIImage(color: UIColor(red: 14.0/255, green: 17.0/255, blue: 33.0/255, alpha: 1))
        navigationBar.isTranslucent = true
        naviView = NaviView(frame: CGRect(x: 0, y: 0, width: navigationBar.bounds.width, height: 56.0))
        navigationBar.addSubview(naviView)
        navigationItem.hidesBackButton = true
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return darkMode ? .default : .lightContent
    }
}


