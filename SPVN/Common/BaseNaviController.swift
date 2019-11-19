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

extension BaseNaviController {
    /// WARNING: Change these constants according to your project's design
    private struct Const {
        /// Image height/width for Large NavBar state
        static let ImageSizeForLargeState: CGFloat = 20
        /// Margin from right anchor of safe area to right anchor of Image
        static let ImageRightMargin: CGFloat = 16
        /// Margin from bottom anchor of NavBar to bottom anchor of Image for Large NavBar state
        static let ImageBottomMarginForLargeState: CGFloat = 12
        /// Margin from bottom anchor of NavBar to bottom anchor of Image for Small NavBar state
        static let ImageBottomMarginForSmallState: CGFloat = 8
        /// Image height/width for Small NavBar state
        static let ImageSizeForSmallState: CGFloat = 16
        /// Height of NavBar for Small state. Usually it's just 44
        static let NavBarHeightSmallState: CGFloat = 20
        /// Height of NavBar for Large state. Usually it's just 96.5 but if you have a custom font for the title, please make sure to edit this value since it changes the height for Large state of NavBar
        static let NavBarHeightLargeState: CGFloat = 96.5
        /// Image height/width for Landscape state
        static let ScaleForImageSizeForLandscape: CGFloat = 0.65
    }
}

class BaseNaviController: UINavigationController {
    
    var imageView: UIImageView! {
        didSet {
            setupUI()
            observeAndHandleOrientationMode()
            
            if UIDevice.current.orientation.isLandscape {
                shoulResize = false
            } else {
                 shoulResize = true
            }
        }
    }
    var shoulResize: Bool?
    var darkMode = false
    
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
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.shadowImage = UIImage()
        navigationBar.isTranslucent = true
    }
    
    // MARK: - Private methods
    
    private func setupUI() {
        title = "Resizing image 👉"
        
        // Initial setup for image for Large NavBar state since the the screen always has Large NavBar once it gets opened
        navigationBar.addSubview(imageView)
//        imageView.layer.cornerRadius = Const.ImageSizeForLargeState / 2
//        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.rightAnchor.constraint(equalTo: navigationBar.rightAnchor,
                                             constant: -Const.ImageRightMargin),
            imageView.bottomAnchor.constraint(equalTo: navigationBar.bottomAnchor,
                                              constant: -Const.ImageBottomMarginForLargeState),
            imageView.heightAnchor.constraint(equalToConstant: Const.ImageSizeForLargeState),
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor)
        ])
    }
    
    private func creatRightBarButton(image: UIImageView) {
        
    }
    
    private func observeAndHandleOrientationMode() {
        NotificationCenter.default.addObserver(forName: UIDevice.orientationDidChangeNotification, object: nil, queue: OperationQueue.current) { [weak self] _ in
            
            if UIDevice.current.orientation.isPortrait {
                self?.moveAndResizeImageForPortrait()
                self?.shoulResize = true
            } else if UIDevice.current.orientation.isLandscape {
                self?.resizeImageForLandscape()
                self?.shoulResize = false
            }
        }
    }
    
    func moveAndResizeImageForPortrait() {
        let coeff: CGFloat = {
            let delta = navigationBar.frame.height - Const.NavBarHeightSmallState
            let heightDifferenceBetweenStates = (Const.NavBarHeightLargeState - Const.NavBarHeightSmallState)
            return delta / heightDifferenceBetweenStates
        }()
        
        let factor = Const.ImageSizeForSmallState / Const.ImageSizeForLargeState
        
        let scale: CGFloat = {
            let sizeAddendumFactor = coeff * (1.0 - factor)
            return min(1.0, sizeAddendumFactor + factor)
        }()
        
        // Value of difference between icons for large and small states
        let sizeDiff = Const.ImageSizeForLargeState * (1.0 - factor) // 8.0
        
        let yTranslation: CGFloat = {
            /// This value = 14. It equals to difference of 12 and 6 (bottom margin for large and small states). Also it adds 8.0 (size difference when the image gets smaller size)
            let maxYTranslation = Const.ImageBottomMarginForLargeState - Const.ImageBottomMarginForSmallState + sizeDiff
            return max(0, min(maxYTranslation, (maxYTranslation - coeff * (Const.ImageBottomMarginForSmallState + sizeDiff))))
        }()
        
        let xTranslation = max(0, sizeDiff - coeff * sizeDiff)
        
        imageView.transform = CGAffineTransform.identity
            .scaledBy(x: scale, y: scale)
            .translatedBy(x: xTranslation, y: yTranslation)
    }
    
    private func resizeImageForLandscape() {
        let yTranslation = Const.ImageSizeForLargeState * Const.ScaleForImageSizeForLandscape
        imageView.transform = CGAffineTransform.identity
            .scaledBy(x: Const.ScaleForImageSizeForLandscape, y: Const.ScaleForImageSizeForLandscape)
            .translatedBy(x: 0, y: yTranslation)
    }
    
    /// Show or hide the image from NavBar while going to next screen or back to initial screen
    ///
    /// - Parameter show: show or hide the image from NavBar
    func showImage(_ show: Bool) {
        UIView.animate(withDuration: 0.2) {
            self.imageView.alpha = show ? 1.0 : 0.0
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return darkMode ? .default : .lightContent
    }
}


