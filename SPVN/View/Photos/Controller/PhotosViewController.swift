//
//  PhotosViewController.swift
//  SPVN
//
//  Created by ntq on 11/18/19.
//  Copyright © 2019 DuyDV. All rights reserved.
//

import UIKit
import ViewAnimator

final class PhotosViewController: BaseViewController {
    
    // MARK IBOutlet
    @IBOutlet private weak var collectionView: UICollectionView!
    
    // MARK: Properties
    private let animations = [AnimationType.from(direction: .bottom, offset: 30.0)]
    private let reuseIdentifier = "albumCoCell"
    private let margin: CGFloat = 16.0
    private var albums = [AlbumModel]()
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupViewController()
    }
    
    
    private func setupViewController() {
        setupCollectionView()
        if let navi = self.navigationController as? BaseNaviController {
            navi.delegateBaseNavi = self
        }
        self.fetchData()
        UIView.animate(views: collectionView!.orderedVisibleCells,
                            animations: animations, reversed: true,
                            initialAlpha: 1.0,
                            finalAlpha: 0.0,
                            completion: {
                             self.collectionView?.reloadData()
             })
    }
    
    private func setupCollectionView() {
        collectionView.register(UINib(nibName: AlbumCollectionViewCell.className, bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    private func fetchData() {
        guard let object = AppCenter.shared.spvn.getObjectUserDefault(key: UserDefaultKey.albums) as? [AlbumModel], object.count > 0 else { return }
        albums = object
        self.collectionView.reloadData()
    }
    
    private func saveAlbums(titleAlbum: String) {
        let title = titleAlbum.trimmingCharacters(in: .whitespaces)
        var model: [AlbumModel] = []
        albums.removeAll()
        guard let object = AppCenter.shared.spvn.getObjectUserDefault(key: UserDefaultKey.albums) as? [AlbumModel] else {
            model.append(AlbumModel(iTitle: title))
            AppCenter.shared.spvn.saveObjectUserDefault(key: UserDefaultKey.albums, value: model)
            self.fetchData()
            return
        }
        
        model = object
        if object.count > 0 {
            if object.contains(where: {$0.title == title}) {
                print("The name playlist duplicated")
            } else {
                model.append(AlbumModel(iTitle: title))
            }
        } else {
            model.append(AlbumModel(iTitle: title))
        }
        
        AppCenter.shared.spvn.saveObjectUserDefault(key: UserDefaultKey.albums, value: model)
        self.fetchData()
    }
}

// MARK: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate
extension PhotosViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: margin, left: margin, bottom: margin, right: margin)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return margin
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (self.view.frame.width - 3*margin)/2, height: (self.view.frame.width - 60)/2)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailVC = DetailPhotosViewController(nibName: DetailPhotosViewController.className, bundle: nil)
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
}

// MARK: UICollectionViewDataSource
extension PhotosViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return albums.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? AlbumCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        return cell
    }
}

// MARK: BaseNaviControllerProtocol
extension PhotosViewController: BaseNaviControllerProtocol {
    
    func imageViewResizeDidTouch() {
        self.creatFolder(placeholder: "Enter albums Name", title: "Create New Album", subTitle: "Enter a name for your new album") { (txfName) in
            self.saveAlbums(titleAlbum: txfName)
        }
    }
}

