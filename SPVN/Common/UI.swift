//
//  UI.swift
//  SPVN
//
//  Created by DuyDV on 11/18/19.
//  Copyright © 2019 DuyDV. All rights reserved.
//

import UIKit

class Indicator: UIView {
    var isNeedClear = false
     //initWithFrame to init view from code
    override init(frame: CGRect) {
      super.init(frame: frame)
      setupView()
    }
    
    //initWithCode to init view from xib or storyboard
    required init?(coder aDecoder: NSCoder) {
      super.init(coder: aDecoder)
      setupView()
    }
    
    //common func to init our view
    private func setupView() {
      layer.borderWidth = 1.0
      layer.cornerRadius = frame.height/2
      layer.borderColor = UIColor.white.cgColor

    }
    override func draw(_ rect: CGRect) {
//        super.draw(rect)
//        drawCircle(rect)
    }
}

class PinIndicator: UIButton {
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        drawCircle(rect, color: UIColor(red: 54.0/255, green: 55.0/255, blue: 70.0/255, alpha: 1), strokeColor: .clear)
    }
}

class PhotoImageView: UIImageView {
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        drawCircle(rect)
    }
}

extension UIView {
    func drawCircle(_ rect:CGRect, color: UIColor? = nil, strokeColor: UIColor = UIColor.lightGray) {
        guard let context = UIGraphicsGetCurrentContext() else {return}
        let rect = CGRect(x: rect.origin.x+0.5,
                          y: rect.origin.y+0.5,
                          width: rect.width-1.5,
                          height: rect.height-1.5)
        
        context.setLineWidth(1)
        if let cgColor = color?.cgColor {
            context.setFillColor(cgColor)
            context.fillEllipse(in: rect)
        }
        context.setStrokeColor(strokeColor.cgColor)
        context.strokeEllipse(in: rect)
    }
    
    func shake(delegate: CAAnimationDelegate) {
        let animationKeyPath = "transform.translation.x"
        let shakeAnimation = "shake"
        let duration = 0.6
        let animation = CAKeyframeAnimation(keyPath: animationKeyPath)
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animation.duration = duration
        animation.values = [-20.0, 20.0, -20.0, 20.0, -10.0, 10.0, -5.0, 5.0, 0.0]
        animation.delegate = delegate
        layer.add(animation, forKey: shakeAnimation)
    }
}


