//
//  UserProfileController.swift
//  M.I.L.k
//
//  Created by noah davidson on 12/14/17.
//  Copyright © 2017 noah davidson. All rights reserved.
//

import UIKit

class UserProfileController : UICollectionViewController, UserProfileViewModelDelegate{
    func selectPost(viewController: UIViewController) {
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func handleGoToSettings(settingsViewController: SettingsController) {
        settingsViewController.user = user
        let navController = UINavigationController(rootViewController: settingsViewController)
        present(navController, animated: true, completion: nil)
    }
    
    var user: User?
    var userId: Int?

    var userProfileViewModel : UserProfileViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //NEED TO UPDATE: fetch User tree from DB and store user info in user struct
        
        fetchUser()
        
        guard let user = self.user else {return}
        
        userProfileViewModel = UserProfileViewModel(user: user)
        userProfileViewModel?.delegate = self
        userProfileViewModel?.reloadSections = { [weak self] (section: Int,numberOfItems: Int ,collapsed: Bool) in

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
            self?.collectionView?.reloadData()
        }

        collectionView?.dataSource = userProfileViewModel
        collectionView?.delegate = userProfileViewModel
        
        collectionView?.backgroundColor = .white

        collectionView?.register(UserProfileHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: UserProfileHeader.identifier)
        collectionView?.register(UserProfileFactHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: UserProfileFactHeader.identifier)
        
        collectionView?.register(UserProfilePhotoCell.self, forCellWithReuseIdentifier: UserProfilePhotoCell.identifier)
        collectionView?.register(UserProfileFactCell.self, forCellWithReuseIdentifier: UserProfileFactCell.identifier)
        
        setupLogoutButton()
    }


    var posts = [Post]()
    fileprivate func fetchOrderedPosts(){
        
        guard let uid = user?.id else {return}
        
        //NEED TO DO: GET REFERENCE TO ALL POSTS FROM UID
        //NEED TO DO: GET ALL POSTS FOR USER IN ORDER OF DATE POSTED
        //NEED TO DO: PARSE USER POST IMAGE DICT
        
        //THIS VALUE NEED TO BE IMAGE POST INFO. REMOVE WHEN HAVE DB INFO
        let value = [String: Any]()
        
        //NEED TO DO: GET IMAGE POST VALUES AND SAVE IT TO THIS VARIABLE
        guard let dictionary = value as? [String : Any] else {return}

        //SAVE IMAGE INFO IN POST OBJ
        guard let user = self.user else {return}

        FetchPosts(dict: nil) { (result) in
            switch result {
            case .success(let posts):
                print("SUCCESS POSTS: ", posts)
                self.posts = posts
                return
            case .failure(let error):
                print("FAILURE POSTS:", error)
                return
            }
        }
        
        self.collectionView?.reloadData()
    }
    

    
    fileprivate func setupLogoutButton(){
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "gear").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleLogout))
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
    
    fileprivate func fetchUser(){
        
        var currentUser: User?
        currentUser = getUserFromDisk()

        self.user = currentUser
        self.navigationItem.title = self.user?.username
        
        self.collectionView?.reloadData()
        
        //self.fetchOrderedPosts()
    }
}
