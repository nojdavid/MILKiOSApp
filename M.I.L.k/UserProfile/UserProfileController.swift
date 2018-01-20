//
//  UserProfileController.swift
//  M.I.L.k
//
//  Created by noah davidson on 12/14/17.
//  Copyright © 2017 noah davidson. All rights reserved.
//

import UIKit

class UserProfileController : UICollectionViewController/*, UICollectionViewDelegateFlowLayout, UserProfileHeaderDelegate*/{
    
    /*
    public enum ProfileMode: Int {
        case postView
        case likeView
        case factView
    }
    
    fileprivate var mode: ProfileMode = .postView
    */
    var userId: Int?

    /*
    func didChangeToGridView() {
        mode = .postView
        collectionView?.reloadData()
    }
    
    func didChangeToLikeListView() {
        mode = .likeView
        collectionView?.reloadData()
    }
    
    func didChangeToFactsView() {
        mode = .factView
    }
    */

    var userProfileViewModel : UserProfileViewModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        //NEED TO UPDATE: fetch User tree from DB and store user info in user struct
        
        fetchUser()
        
        guard let user = self.user else {return}
        
        print("Successful User")
        userProfileViewModel = UserProfileViewModel(user: user)
        
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
        
        //userProfileViewModel.user = user
        //userProfileViewModel?.profileDelegate = self
        
        collectionView?.dataSource = userProfileViewModel
        collectionView?.delegate = userProfileViewModel
        
        collectionView?.backgroundColor = .white

        collectionView?.register(UserProfileHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: UserProfileHeader.identifier)
        collectionView?.register(UserProfileFactHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: UserProfileFactHeader.identifier)
        
        collectionView?.register(UserProfilePhotoCell.self, forCellWithReuseIdentifier: UserProfilePhotoCell.identifier)
        collectionView?.register(UserProfileFactCell.self, forCellWithReuseIdentifier: UserProfileFactCell.identifier)
        
        setupLogoutButton()
        print("View did load")
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
        
        let post = Post(user: user, dictionary: dictionary)

        //self.posts.insert(post, at: 0)
        self.posts.append(post)
        
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
    
    var user: User?
    fileprivate func fetchUser(){
        
        var currentUser: User?
        currentUser = getUserFromDisk()

        self.user = currentUser
        self.navigationItem.title = self.user?.username
        
        self.collectionView?.reloadData()
        
        //self.fetchOrderedPosts()
        
        //IS IT NEEDED TO CHECK USER IN DATABASE HERE??
        /*
        let username = user?.username ?? (currentUser?.username ?? "")
        getUserFromDB(for: username) { (result) in
            switch result {
            case .success(let user):
                self.user = user
                self.navigationItem.title = self.user?.username
                
                self.collectionView?.reloadData()
                
                self.fetchOrderedPosts()
                
            case .failure(let error):
                print("USER PROFILE GET USER ERROR")
                print("error: \(error.localizedDescription)")
                return
            }
        }
        */
    }
    
    /*
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if mode == .postView || mode == .likeView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UserProfilePhotoCell.identifier, for: indexPath) as! UserProfilePhotoCell
            cell.post = posts[indexPath.item]
            return cell
        }else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UserProfileFactCell.identifier, for: indexPath) as! UserProfileFactCell
            
            cell.fact = posts[indexPath.item].fact
            
            return cell
                
        }
    }
    */
    
    /*
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if mode == .postView || mode == .likeView {
            let width = (view.frame.width - 2) / 3
            return CGSize(width: width, height:width)
        } else {
            let height: CGFloat = 50
            let width = (view.frame.width - 2)
            return CGSize(width: width, height: height)
        }
    }
 */
    
    /*
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: UserProfileHeader.identifier, for: indexPath) as! UserProfileHeader
        
        header.user = self.user
        header.delegate = self
        
        return header
    }
 
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        print("HEADER SIZE 1::", CGSize(width: view.frame.width, height: 200))
        return CGSize(width: view.frame.width, height: 200)
    }
 */
}
