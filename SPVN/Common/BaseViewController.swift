//
//  BaseViewController.swift
//  SPVN
//
//  Created by ntq on 11/18/19.
//  Copyright © 2019 DuyDV. All rights reserved.
//

import Foundation
import UIKit
import SCLAlertView
import SnapKit
import BSImagePicker
import Photos
import CropViewController
import DKImagePickerController

class BaseViewController: UIViewController {
    
    @IBOutlet private weak var heightBanner: NSLayoutConstraint!
    
    // MARK: Properties
    private var picker: UIImagePickerController?
    
    lazy var banner = UIView()
    
    override func viewDidLoad() {
        setupViewController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let navi = self.navigationController as? BaseNaviController, navi.naviView != nil {
            navi.naviView.delegate = self
            navi.naviView.titleLabel.text = navigationItem.title
            guard (self is PhotosViewController) || (self is VideosViewController) || (self is ContactsViewController) || (self is SettingViewController) else {
                return
            }
            navi.naviView.backButton.isHidden = true
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    /// Creat Folder
    /// - Requires:
    /// - Parameter placeholder: --> Show placeholder textField
    /// - Parameter title: -->  Show title TextField
    /// - Parameter subTitle: -->  Show subTitle TextField
    /// - Parameter complete: Return text fill TextFiled
    /// - Returns: Void
    func creatFolder(placeholder: String, title: String, subTitle: String, complete: @escaping (String) -> Void) {
        var alertView = SCLAlertView()
        let appearance = SCLAlertView.SCLAppearance(
            showCloseButton: false
        )
        alertView = SCLAlertView(appearance: appearance)
        
        // Add a text field
        
        var txtFieldName = UITextField()
        
        
        txtFieldName = alertView.addTextField("")
        txtFieldName.placeholder = placeholder // 
        
        alertView.addButton("Save", action: {
            if let text = txtFieldName.text {
                complete(text)
            }
        })
        
        alertView.addButton("Cancel", action: {})
        alertView.showEdit(title, subTitle: subTitle, closeButtonTitle: nil, timeout: nil, colorStyle: UInt(AppColor.shared.tintColorApp), colorTextButton: 0xffffff, circleIconImage: nil, animationStyle: SCLAnimationStyle.bottomToTop)
    }
    
    private func setupViewController() {
        super.viewDidLoad()
        UIApplication.shared.statusBarUIView?.backgroundColor = AppColor.shared.backgroundColor
        self.view.addSubview(banner)
        banner.backgroundColor = .red
        banner.snp.makeConstraints { (make) in
            make.leading.trailing.bottom.equalTo(0)
            make.height.equalTo(UIDevice.current.userInterfaceIdiom == .pad ? 90.0 : 50.0)
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.willResignActive), name: UIApplication.willResignActiveNotification, object: nil)
        self.view.backgroundColor = AppColor.shared.backgroundColor
        if self is PhotosViewController {
            self.setAppLocker()
        }
    }
    
    // MARK: Applocker
    @objc private func willResignActive() {
        //        if !AppLocker.isEmptyPinCode, !appDelegate().isLocked {
        //            appDelegate().isLocked = true
        //            self.pin(.deactive, animated: false)
        //        }
    }
    
    private func setAppLocker() {
        //        if AppLocker.isEmptyPinCode {
        //            self.pin(.create, animated: false)
        //            appDelegate().isLocked = true
        //        } else if !AppLocker.isEmptyPinCode, !appDelegate().isLocked {
        //            appDelegate().isLocked = true
        //            self.pin(.validate, animated: false)
        //        }
    }
    
    func pin(_ mode: ALMode, animated: Bool = true) {
        
        var appearance = ALAppearance()
        appearance.image = UIImage(named: "face")!
        appearance.title = "Enter Passcode"
        appearance.isSensorsEnabled = true
        appearance.color = AppColor.shared.backgroundColor
        
        AppLocker.present(with: mode, and: appearance, style: .fullScreen, animated: animated)
    }
    
    func showCamera() {
        //Camera
        let spvnCameraVC = SPVNCameraViewController(nibName: SPVNCameraViewController.className, bundle: nil)
        spvnCameraVC.modalPresentationStyle = .fullScreen
        self.present(spvnCameraVC, animated: true, completion: nil)
        //        AVCaptureDevice.requestAccess(for: AVMediaType.video) { response in
        //            if response {
        //                //access granted
        //                DispatchQueue.main.async {
        //                    self.picker = UIImagePickerController()
        //                    guard let picker = self.picker else { return }
        //                    picker.allowsEditing = false
        //                    picker.sourceType = .camera
        //                    picker.cameraDevice = .rear
        //                    picker.cameraCaptureMode = .photo
        //                    picker.delegate = self
        //                    self.present(picker, animated: true, completion: nil)
        //                }
        //            } else {
        //                AlertView.shared.showAlert(title: "", message: "You must have access to the camera to use this", handerLeft: nil, handerRight: nil, title_btn_left: "OK", title_btn_right: nil, viewController: self)
        //            }
        //        }
    }
    
    // MARK: BSImagePicker
    func showPhotoSelect(isMultiple: Bool, nameAlbum: String, completion: @escaping () -> Void) {
        let vc = BSImagePickerViewController()
        vc.selectionCharacter = "✓"
        vc.selectionFillColor = .blue
        if !isMultiple {
            vc.maxNumberOfSelections = 1
        }
        let appearance = UINavigationBar.appearance(whenContainedInInstancesOf: [BSImagePickerViewController.self])
        appearance.setBackgroundImage(UIImage(color: UIColor(red: 14.0/255, green: 17.0/255, blue: 33.0/255, alpha: 1)), for: .any, barMetrics: .default)
        appearance.shadowImage = UIImage(color: UIColor(red: 14.0/255, green: 17.0/255, blue: 33.0/255, alpha: 1))
        appearance.tintColor = UIColor.white
        appearance.isTranslucent = false
        appearance.barStyle = .black
        appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white,
                                          NSAttributedString.Key.strokeColor: UIColor.white,
                                          NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18, weight: .medium)
        ]
        vc.albumButton.tintColor = UIColor.white
        vc.backgroundColor = AppColor.shared.backgroundColor
        vc.albumButton.setTitleColor(UIColor.white, for: .normal)
        vc.cancelButton.tintColor = UIColor.white
        vc.doneButton.tintColor = UIColor.white
        vc.modalPresentationStyle = .fullScreen
        bs_presentImagePickerController(vc, animated: true, select: nil, deselect: nil, cancel: { (assets) in
            completion()
        }, finish: { (assets) in
            DispatchQueue.global(qos: .userInitiated).async {
                let downloadGroup = DispatchGroup()
                if let path = Document().CreatFolderToDirectory(folderName: "\(ConstantKey.photos)/\(nameAlbum)") {
                    for asset in assets {
                        downloadGroup.enter()
                        asset.getData { (data) in
                            do {
                                try data?.write(to: path.appendingPathComponent(asset.originalFilename ?? "\(Int(Date().timeIntervalSince1970))"))
                                downloadGroup.leave()
                            }
                            catch let err {
                                LogError(err.localizedDescription)
                                downloadGroup.leave()
                            }
                        }
                    }
                    
                    downloadGroup.wait()
                    DispatchQueue.main.async {
                        completion()
                    }
                }
            }
        }, completion: {
            //TODO: - BSImagePickerViewController
        })
    }
    
    func showVideoSelect(isMultiple: Bool, nameAlbum: String, completion: @escaping () -> Void) {
        let pickerController = DKImagePickerController()
        let appearance = UINavigationBar.appearance(whenContainedInInstancesOf: [DKImagePickerController.self])
        appearance.setBackgroundImage(UIImage(color: UIColor(red: 14.0/255, green: 17.0/255, blue: 33.0/255, alpha: 1)), for: .any, barMetrics: .default)
        appearance.shadowImage = UIImage(color: UIColor(red: 14.0/255, green: 17.0/255, blue: 33.0/255, alpha: 1))
        appearance.tintColor = UIColor.white
        appearance.isTranslucent = false
        appearance.barStyle = .black
        appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white,
                                          NSAttributedString.Key.strokeColor: UIColor.white,
                                          NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18, weight: .medium)
        ]
        pickerController.allowSwipeToSelect = true
        pickerController.showsCancelButton = true
        pickerController.assetType = .allVideos
        pickerController.sourceType = .photo
        pickerController.modalPresentationStyle = .fullScreen
        pickerController.didSelectAssets = { (assets: [DKAsset]) in
            print("didSelectAssets")
            print(assets)
        }
        self.present(pickerController, animated: true, completion: nil)
    }
    
    func getAssetImage(asset: PHAsset) -> UIImage {
        let manager = PHImageManager.default()
        let option = PHImageRequestOptions()
        var thumbnail = UIImage()
        option.isNetworkAccessAllowed = true
        option.deliveryMode = .fastFormat
        option.isSynchronous = true
        manager.requestImage(for: asset, targetSize: CGSize(width: 1024, height: 1024), contentMode: .aspectFit, options: option, resultHandler: {(result, info) -> Void in
            if let res = result {
                thumbnail = res
            }
        })
        return thumbnail
    }
    
    /// Check file dulicate
    /// - Parameter fileList: arrays file object
    /// - Parameter name: string file object
    func checkDuplicateName(fileList: [FileModel], name: String) -> String {
        let arr = fileList.filter {
            $0.fileName == name
        }
        if arr.count > 1 {
            return name  + "(\(arr.count + 1))"
        }
        return name
    }
}

// MARK: NaviViewProtocol
extension BaseViewController: NaviViewProtocol {
    func backDidTouch() {
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK: - Scroll View Delegates
extension BaseViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if let navi = navigationController as? BaseNaviController {
            //Compare with standard height of navigation bar.
            if navi.navigationBar.frame.height > 44.0 {
                navi.naviView.titleLabel.isHidden = true
            } else {
                navi.naviView.titleLabel.isHidden = false
            }
        }
    }
}

extension BaseViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        //        guard let chosenImage = info[UIImagePickerControllerOriginalImage] as? UIImage, let data = UIImageJPEGRepresentation(chosenImage, 0.75) else {
        //            dismiss(animated: true, completion: nil)
        //            return
        //        }
        //        dismiss(animated: true) {
        //            if self.validateFileMoreThanTenMB(data: data) {
        //                return
        //            }
        //            let model = ImageModel(data: data, imageName: "", type: .image)
        //            model.fileName = self.checkDuplicateName(name: model.url?.absoluteString.lastPathComponent.decodeUrl() ?? "\(Int64(Date().timeIntervalSince1970)).jpg")
        //            self.imageList.append(model)
        //            self.imageCollectionView.reloadData()
        //        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

