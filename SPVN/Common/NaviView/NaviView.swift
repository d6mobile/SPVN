//
//  NaviView.swift
//  SPVN
//
//  Created by ntq on 11/21/19.
//  Copyright © 2019 DuyDV. All rights reserved.
//

import UIKit

protocol NaviViewProtocol: class {
    func backDidTouch()
}

final class NaviView: UIView {
    
    // MARK: IBOutlet
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var rightBarButton: UIButton!
    
    var callbackRightButton: (() -> ())?
    weak var delegate: NaviViewProtocol?
    var imageRight: UIImage? {
        didSet {
            self.rightBarButton.setImage(imageRight, for: .normal)
        }
    }
    
    // MARK: Properties
    let kCONTENT_XIB_NAME = "NaviView"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        Bundle.main.loadNibNamed(kCONTENT_XIB_NAME, owner: self, options: nil)
        contentView.backgroundColor = AppColor.shared.backgroundColor
        contentView.fixInView(self)
    }
    
    @IBAction private func backDidTouch(_ sender: UIButton) {
        delegate?.backDidTouch()
    }
    
    @IBAction private func rightBarButtonDidTouch(_ sender: UIButton) {
        self.callbackRightButton?()
    }
}
