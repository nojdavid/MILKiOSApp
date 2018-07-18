//
//  UserProfileController.swift
//  M.I.L.k
//
//  Created by noah davidson on 12/14/17.
//  Copyright © 2017 noah davidson. All rights reserved.
//

import UIKit

class UserProfileController : UICollectionViewController, UserProfileViewModelDelegate{
    
    var posts = [Post]()
    var user: User?
    var userId: Int?

    var userProfileViewModel : UserProfileViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        if let user = Store.shared().user {
            self.user = user
        } else {
            return
        }
        
        self.navigationItem.title = self.user?.username
        
        userProfileViewModel = UserProfileViewModel(user: user!)
        userProfileViewModel?.delegate = self
        userProfileViewModel?.reloadSections = { [weak self] (section: Int,numberOfItems: Int ,collapsed: Bool) in
            print("reloadSections")
            self?.collectionView?.performBatchUpdates({
                if !collapsed {
                    self?.collectionView?.insertItems(at: (0..<numberOfItems).map {
                        IndexPath(item: $0, section: section)
                    })
                }else{
                    self?.collectionView?.deleteItems(at:(0..<numberOfItems).map {
                        IndexPath(item: $0, section: section)
                        })
                }
                
            }, completion: { (success) in
                self?.collectionView?.reloadItems(at: (0..<(self?.collectionView?.numberOfItems(inSection: section))!).map {
                    IndexPath(item: $0, section: section)
                })
            })
 
        }
        
        userProfileViewModel?.reloadAllSections = { [weak self] () in
            print("reloadALLSections")
            self?.collectionView?.reloadData()
        }

        collectionView?.dataSource = userProfileViewModel
        collectionView?.delegate = userProfileViewModel
        
        //Update user profileModel
        userProfileViewModel?.didChangeToGridView()
        
        collectionView?.backgroundColor = .white

        collectionView?.register(UserProfileHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: UserProfileHeader.identifier)
        collectionView?.register(UserProfileFactHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: UserProfileFactHeader.identifier)
        
        collectionView?.register(UserProfilePhotoCell.self, forCellWithReuseIdentifier: UserProfilePhotoCell.identifier)
        collectionView?.register(UserProfileFactCell.self, forCellWithReuseIdentifier: UserProfileFactCell.identifier)
        
        setupLogoutButton()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidLoad()

        userProfileViewModel?.refreshActiveSection()
    }
    
    fileprivate func setupLogoutButton(){
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "gear").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleLogout))
    }
    
    func selectPost(viewController: UIViewController) {
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func handleGoToSettings(settingsViewController: SettingsController) {
        settingsViewController.user = user
        let navController = UINavigationController(rootViewController: settingsViewController)
        present(navController, animated: true, completion: nil)
    }
    
    @objc func handleLogout(){
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        alertController.addAction(UIAlertAction(title: "Log Out", style: .destructive, handler: { (_) in

            //MAKE SURE THIS FUNCTIONALITY IS ONLY PRESENT IF THE PROFILE IS YOURS!!!!!!!!!
            /*
            guard let user = self.user else {return}
            logoutUserFromDB(user: user, completion: { (error) in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
            })
            */
            deleteUserFromDisk()
            
            
            let loginController = LoginController()
            let navController = UINavigationController(rootViewController: loginController)
            self.present(navController, animated: true, completion: nil)
        }))
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(alertController, animated: true, completion: nil)
    }
}
