//
//  AppColor.swift
//  SPVN
//
//  Created by ntq on 11/20/19.
//  Copyright © 2019 DuyDV. All rights reserved.
//

import Foundation
import UIKit

protocol AppColorProtocol {
    
}

final class AppColor: AppColorProtocol {
    
        /// For static instance
    static let shared = AppColor()

    let tintColorApp = 0xe8aa00
    let backgroundColor = UIColor(rgb: 0x0E1121)
}
