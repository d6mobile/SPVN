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

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupNaviController()
    }
    
    private func setupNaviController() {
        self.navigationBar.prefersLargeTitles = true
        self.navigationItem.largeTitleDisplayMode = .never
        UINavigationBar.appearance().largeTitleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.black
        ]
    }
}
