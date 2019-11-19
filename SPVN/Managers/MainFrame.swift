//
//  MainFrame.swift
//  SPVN
//
//  Created by DuyDV on 11/18/19.
//  Copyright © 2019 DuyDV. All rights reserved.
//

import Foundation
import UIKit

protocol MainFrameProtocol {
    
    func makeMainScreen(window: UIWindow)
}

final class MainFrame: MainFrameProtocol {
    
     func makeMainScreen(window: UIWindow) {
            let tabbar = UITabBarController()
            
            let photosVC: PhotosViewController = PhotosViewController(nibName: PhotosViewController.className, bundle: nil)
            photosVC.navigationItem.title = "Albums"
            let naviPhotos = BaseNaviController(rootViewController: photosVC)
            naviPhotos.imageView = UIImageView(image: UIImage(named: "icon_plus"))
            
            let tabbarItemPhotos = UITabBarItem(title: "Photos", image: nil, selectedImage: nil)
            naviPhotos.tabBarItem = tabbarItemPhotos
            
            let videosVC: VideosViewController = VideosViewController(nibName: VideosViewController.className, bundle: nil)
            videosVC.navigationItem.title = "Videos"
            let naviVideos = BaseNaviController(rootViewController: videosVC)
            let tabbarItemVideos = UITabBarItem(title: "Videos", image: nil, selectedImage: nil)
            naviVideos.tabBarItem = tabbarItemVideos
            
            let contactsVC: ContactsViewController = ContactsViewController(nibName: ContactsViewController.className, bundle: nil)
            contactsVC.navigationItem.title = "Contacts"
            let naviContacts = BaseNaviController(rootViewController: contactsVC)
            let tabbarItemContacts = UITabBarItem(title: "Contacts", image: nil, selectedImage: nil)
            naviContacts.tabBarItem = tabbarItemContacts
            
            let settingVC: SettingViewController = SettingViewController(nibName: SettingViewController.className, bundle: nil)
            let naviSetting = BaseNaviController(rootViewController: settingVC)
            settingVC.navigationItem.title = "Setting"
            let tabbarItemSetting = UITabBarItem(title: "Setting", image: nil, selectedImage: nil)
            naviSetting.tabBarItem = tabbarItemSetting
            
            tabbar.tabBar.isTranslucent = false
            tabbar.tabBar.barTintColor = UIColor(rgb: 0x0E1121)
            tabbar.viewControllers = [naviPhotos, naviVideos, naviContacts, naviSetting]
            window.rootViewController = tabbar
            window.makeKeyAndVisible()
        }
}
