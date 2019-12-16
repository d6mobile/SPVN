//
//  VideosViewController.swift
//  SPVN
//
//  Created by DuyDV on 11/18/19.
//  Copyright © 2019 DuyDV. All rights reserved.
//

import UIKit
import Photos
import ViewAnimator
import MobileCoreServices
import CropViewController

final class VideosViewController: BaseViewController {
    
    // MARK IBOutlet
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var indicatorView: UIActivityIndicatorView!
    
    //MARK: Properties
    private let animations = [AnimationType.zoom(scale: 0.2),
                              AnimationType.from(direction: .right, offset: 30.0)]
    private let reuseIdentifier = "detailVideoCell"
    private let margin: CGFloat = 5.0
    var fileList: [FileModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupViewController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let navi = self.navigationController as? BaseNaviController, navi.naviView != nil {
            navi.naviView.titleLabel.text = navigationItem.title
            navi.naviView.imageRight = UIImage(named: "icon_edit")
            navi.naviView.callbackRightButton = {[weak self] in
                LogDebug("rightBarButton")
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    private func setupViewController() {
        if let navi = navigationController as? BaseNaviController {
            navi.naviView.backButton.isHidden = false
            navi.naviView.titleLabel.text = navigationItem.title
        }
        
        indicatorView.hidesWhenStopped = true
        indicatorView.startAnimating()
        setupCollectionView()
        DispatchQueue.main.async {
            self.fetchData()
            self.collectionView.performBatchUpdates({
                UIView.animate(views: self.collectionView!.orderedVisibleCells,
                               animations: self.animations, completion: nil)
            }) { (finish) in
                self.collectionView.collectionViewLayout.invalidateLayout()
            }
        }
    }
    
    override func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        super.imagePickerController(picker, didFinishPickingMediaWithInfo: info)
        print("Camera")


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
    
    private func fetchData() {
        if let object = Document().fetListFileFromDirectory(name: ConstantKey.photos + "/\(navigationItem.title!)") {
            self.fileList = object
            self.collectionView.reloadData()
            indicatorView.stopAnimating()
        }
    }
    
    private func setupCollectionView() {
        collectionView.register(UINib(nibName: DetailPhotosCollectionViewCell.className, bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    private func cameraRoll() {
        let photos = PHPhotoLibrary.authorizationStatus()
        switch photos {
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization({status in
                if status == .authorized {
                    DispatchQueue.main.async {
                        self.showPhotoSelect(isMultiple: true, nameAlbum: self.navigationItem.title!) {[weak self] in
                            self?.fetchData()
                        }
                    }
                } else {
                    self.showAlertDenyPermission(message: "You must have access to the photo library to use it.")
                }
            })
        case .authorized:
            DispatchQueue.main.async {
                self.showPhotoSelect(isMultiple: true, nameAlbum: self.navigationItem.title!) {[weak self] in
                    self?.fetchData()
                }
            }
        default:
            self.showAlertDenyPermission(message: "You must have access to the photo library to use it.")
        }
        
    }
    
    private func showAlertDenyPermission(message: String) {
        if !message.isEmpty {
            AlertView.shared.showAlert(title: "", message: message, handerLeft: nil, handerRight: {
                if let url = URL(string:UIApplication.openSettingsURLString) {
                    if UIApplication.shared.canOpenURL(url) {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    }
                }
            },title_btn_left: "Cancel", title_btn_right: "Open Setting", viewController: self)
        }
    }
    
    private func cloudService(_ sender: UIButton) {
        let importMenu = UIDocumentPickerViewController(documentTypes: ["public.image"], in: .import)
        importMenu.delegate = self
        importMenu.modalPresentationStyle = .formSheet
        
        if let popoverPresentationController = importMenu.popoverPresentationController {
            popoverPresentationController.sourceView = sender
            // popoverPresentationController.sourceRect = sender.bounds
        }
        importMenu.modalPresentationStyle = .fullScreen
        self.present(importMenu, animated: true, completion: nil)
    }
    
    // MARK: IBAction
    @IBAction private func importDidTouch(_ sender: UIButton) {
        AlertView.shared.showActionSheet(title: nil, message: "Select Photos", handerCameraRoll: {[weak self] in
            self?.cameraRoll()
            }, handerCloud: {[weak self] in
                self?.cloudService(sender)
            }, title_btn_camera_roll: "Camera Roll", title_btn_cloud: "Cloud service", viewController: self)
    }
    
    @IBAction private func cameraDidTouch(_ sender: UIButton) {
       self.showCamera()
    }
}

// MARK: CropViewControllerDelegate
extension VideosViewController: CropViewControllerDelegate {
    func cropViewController(_ cropViewController: CropViewController, didCropImageToRect rect: CGRect, angle: Int) {
        
    }
}

// MARK: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate
extension VideosViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: margin, left: margin, bottom: margin, right: margin)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return margin
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return margin
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (self.view.frame.width - 32.0 - 4*margin)/3, height: (self.view.frame.width - 32.0 - 4*margin)/3)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //        let detailVC = DetailPhotosViewController(nibName: DetailPhotosViewController.className, bundle: nil)
        //        guard let navi = self.navigationController as? BaseNaviController else { return }
        //        detailVC.navigationItem.title = albums[indexPath.row].title
        //        detailVC.navigationItem.hidesBackButton = true
        //        navi.pushViewController(detailVC, animated: true)
    }
}

// MARK: UICollectionViewDataSource
extension VideosViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fileList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? DetailPhotosCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.fillDataToCell(fileList[indexPath.row], nameAlbum: navigationItem.title!)
        return cell
    }
}

//MARK: - UIDocumentPickerDelegate
extension VideosViewController : UIDocumentPickerDelegate {
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
        
        DispatchQueue.main.async {
            let theFileName = self.checkDuplicateName(fileList: self.fileList, name: url.absoluteString.lastPathComponent.decodeUrl() ?? "")
            if let data = try? Data(contentsOf: url) {
                // TODO: ...process
                if let path = Document().CreatFolderToDirectory(folderName: "\(ConstantKey.photos)" + "/\(self.navigationItem.title!)") {
                    do {
                        try data.write(to: path.appendingPathComponent(theFileName))
                        self.fetchData()
                    }
                    catch let err {
                        LogError(err.localizedDescription)
                    }
                }
            }
        }
    }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
}
