//
//  ButtonHit.swift
//  Music Apps
//
//  Created by Duy Dang on 9/14/18.
//  Copyright © 2018 YCN Co.,Ltd. All rights reserved.
//

import UIKit

class ButtonHit: UIButton {

    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let expandMargin: CGFloat = 20
        let extendedFrame = CGRect(x: 0 - expandMargin, y: 0 - expandMargin, width: self.frame.size.width + (expandMargin * 2), height: self.frame.size.height + (expandMargin * 2))
        return (extendedFrame.contains(point)) ? self : nil
    }    
}
