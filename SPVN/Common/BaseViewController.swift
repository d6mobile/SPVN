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
    @IBOutlet private weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        setupViewController()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        guard let navi = self.navigationController as? BaseNaviController else { return }
        navi.showImage(false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard let navi = self.navigationController as? BaseNaviController else { return }
        navi.showImage(true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        guard let navi = self.navigationController as? BaseNaviController, navi.imageView != nil, let shoulResize = navi.shoulResize
            else { print("shoulResize wasn't set. reason could be non-handled device orientation state"); return }
        
        if shoulResize {
            navi.moveAndResizeImageForPortrait()
        }
    }
    
    private func setupViewController() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(rgb: 0x0E1121)
        if scrollView != nil {
            self.scrollView?.delegate = self
        }
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
