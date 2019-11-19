//
//  BaseViewController.swift
//  SPVN
//
//  Created by ntq on 11/18/19.
//  Copyright © 2019 DuyDV. All rights reserved.
//

import Foundation
import UIKit

class BaseViewController: UIViewController {
    
    @IBOutlet private weak var banner: UIView!
    @IBOutlet private weak var heightBanner: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(rgb: 0x0E1121)
    }
}
