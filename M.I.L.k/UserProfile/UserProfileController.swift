//
//  UserProfileController.swift
//  M.I.L.k
//
//  Created by noah davidson on 12/14/17.
//  Copyright © 2017 noah davidson. All rights reserved.
//

import UIKit

class UserProfileController : UICollectionViewController, UICollectionViewDelegateFlowLayout, UserProfileHeaderDelegate{
    
    let cellId = "cellId"
    let headerId = "headerId"
    let homePostCellId = "homePostCellId"
    
    var userId: Int?
    
    var isGridView = true
    
    func didChangeToGridView() {
        isGridView = true
        collectionView?.reloadData()
    }
    
    func didChangeToListView() {
        isGridView = false
        collectionView?.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.backgroundColor = .white

        collectionView?.register(UserProfileHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerId)
        collectionView?.register(UserProfilePhotoCell.self, forCellWithReuseIdentifier: cellId)
        collectionView?.register(DetailPostCell.self, forCellWithReuseIdentifier: homePostCellId)
        
        setupLogoutButton()
        
        //NEED TO UPDATE: fetch User tree from DB and store user info in user struct
        fetchUser()
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
        
        self.fetchOrderedPosts()
        
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
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if isGridView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! UserProfilePhotoCell
            cell.post = posts[indexPath.item]
            return cell
        }else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: homePostCellId, for: indexPath) as! DetailPostCell
            cell.post = posts[indexPath.item]
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if isGridView {
            let width = (view.frame.width - 2) / 3
            return CGSize(width: width, height:width)
        }else {
            var height: CGFloat = 40 + 8 + 8 //username and userprofileImageview
            height += view.frame.width
            height += 50
            height += 60
            
            return CGSize(width: view.frame.width, height: height)
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as! UserProfileHeader
        
        header.user = self.user
        header.delegate = self
        
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 200)
    }
}
