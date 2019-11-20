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
    private let reuseIdentifier = "albumCoCell"
    private let margin: CGFloat = 16.0
    private var albums = [AlbumModel]()
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupViewController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.fetchData()
        if let navi = self.navigationController as? BaseNaviController, navi.naviView != nil {
            navi.naviView.backButton.isHidden = true
            navi.naviView.titleLabel.text = navigationItem.title
            navi.naviView.imageRight = UIImage(named: "icon_plus")
            navi.naviView.callbackRightButton = {[weak self] in
                self?.creatFolder(placeholder: "Enter albums Name", title: "Create New Album", subTitle: "Enter a name for your new album") { (txfName) in
                    guard !txfName.isEmpty else {
                        return
                    }
                    self?.saveAlbums(titleAlbum: txfName)
                }
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    private func setupViewController() {
        if let navi = self.navigationController as? BaseNaviController, navi.naviView != nil {
            navi.naviView.titleLabel.text = "Albums"
        }
        setupCollectionView()
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
        return CGSize(width: (self.view.frame.width - 3*margin)/2, height: 2*(self.view.frame.width - 3*margin)/3)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailVC = DetailPhotosViewController(nibName: DetailPhotosViewController.className, bundle: nil)
        guard let navi = self.navigationController as? BaseNaviController else { return }
        detailVC.navigationItem.title = albums[indexPath.row].title
        detailVC.navigationItem.hidesBackButton = true
        navi.pushViewController(detailVC, animated: true)
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
        
        cell.fillDataToCell(self.albums[indexPath.row].title)
        return cell
    }
}
