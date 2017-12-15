//
//  UserProfileController.swift
//  M.I.L.k
//
//  Created by noah davidson on 12/14/17.
//  Copyright © 2017 noah davidson. All rights reserved.
//

import UIKit

class UserProfileController : UICollectionViewController, UICollectionViewDelegateFlowLayout{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.backgroundColor = .red
        
        //NEED TO UPDATE: fetch User tree from DB and store user info in user struct
        fetchUser()

        collectionView?.register(UserProfileHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "headerId")
    }
    
    var user: User?
    fileprivate func fetchUser(){
        //Assumed loged in get user ID
        //guard let uid = currentUser?.uid else {return}
        
        //GET ALL USER PROFILE DATA HERE AND STORE IT
        //NEED TO UPDATE: GET USERNAME FROM USER ID HASH
        
        //This creates user element to store fetched data in
        //self.user = User(dictionary: dictionary)
        
        //remove this once you have DB objects
        let username = "User Profile"
        self.navigationItem.title = username
        //Set title with user object username
        //self.navigationItem.title = self.user?.username
        //self.collectionView?.reloadData()
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headerId", for: indexPath) as! UserProfileHeader

        header.user = self.user
        
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 200)
    }
}

struct User{
    let username: String
    let profileImageUrl: String
    
    init(dictionary: [String: Any]){
        self.username = dictionary["Username"] as? String ?? ""
        self.profileImageUrl = dictionary["profileImageUrl"] as? String ?? ""
    }
}


