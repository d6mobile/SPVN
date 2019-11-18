//
//  SecurityViewController.swift
//  SPVN
//
//  Created by ntq on 11/18/19.
//  Copyright © 2019 DuyDV. All rights reserved.
//

import UIKit

class SecurityViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    static func pin(_ mode: ALMode, animated: Bool = true) {
      
      var appearance = ALAppearance()
      appearance.image = UIImage(named: "face")!
      appearance.title = "Enter Passcode"
      appearance.isSensorsEnabled = true

      AppLocker.present(with: mode, and: appearance, style: .fullScreen, animated: animated)
    }
}
