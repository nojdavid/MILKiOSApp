//
//  PhotoSelectorTabBarController.swift
//  M.I.L.k
//
//  Created by noah davidson on 12/19/17.
//  Copyright © 2017 noah davidson. All rights reserved.
//

import UIKit

class PhotoSelectorTabBarController: UITabBarController, UITabBarControllerDelegate {
    
    var onPhotoView : Bool = false
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        let selectedIndex = viewControllers?.index(of: viewController)
        
        //SET ALL TABBARITEMS TO COLOR WHEN ONE IS SELECTED
        for controller in viewControllers! {
            if viewControllers?.index(of: controller) == selectedIndex {
                setTabBarItem(tabBarItem: controller.tabBarItem, color: UIColor.black, text: controller.tabBarItem.title!)
            }else {
                setTabBarItem(tabBarItem: controller.tabBarItem, color: UIColor.unselectedGrey(), text: controller.tabBarItem.title!)
            }
        }
        
        //IF CAMERA IS ALREADY SELECTED DO NOTHING
        if selectedIndex == 1 && onPhotoView == true {
            return false
        }else if selectedIndex == 1 {
        //ELSE IS SELECTED AND NOT CAMERA VIEW SO GO THERE
            onPhotoView = true
            let cameraController = PhotoSelectorCameraController()
            photoSelectorNavController?.pushViewController(cameraController, animated: true)
            return false
        }
        
        //SOMETHING BESIDES CAMERA IS SELECTED
        onPhotoView = false
        return true
    }
    
    var photoSelectorNavController: UINavigationController?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        
        self.tabBar.tintColor = UIColor.lightGray
        
        let layout =  UICollectionViewFlowLayout()
        let photoSelectorController = PhotoSelectorController(collectionViewLayout: layout)
        
        //DUMMY TAB
        let cameraNavController = UIViewController()
        
        photoSelectorNavController = UINavigationController(rootViewController: photoSelectorController)
        
        setTabBarItem(tabBarItem: (photoSelectorNavController?.tabBarItem)!, color:  UIColor.black, text: "Library")
        
        setTabBarItem(tabBarItem: (cameraNavController.tabBarItem)!, color: UIColor.unselectedGrey(), text: "Camera")

        viewControllers = [photoSelectorNavController!, cameraNavController]

        guard let items = tabBar.items else {return}
        for item in items {
            item.titlePositionAdjustment = UIOffset(horizontal:0, vertical:-10)
        }
    }
    
    fileprivate func setTabBarItem(tabBarItem: UITabBarItem, color: UIColor, text: String){
        tabBarItem.title = text
        tabBarItem.setTitleTextAttributes([NSAttributedStringKey.font: UIFont.systemFont(ofSize: 16), NSAttributedStringKey.foregroundColor: color], for: .normal)
    }
}

