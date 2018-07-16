//
//  UserSearchController.swift
//  M.I.L.k
//
//  Created by noah davidson on 12/17/17.
//  Copyright © 2017 noah davidson. All rights reserved.
//

import UIKit

class UserSearchController : UICollectionViewController, UICollectionViewDelegateFlowLayout, UISearchBarDelegate{
    
    let cellId = "cellId"
    
    lazy var searchBar : UISearchBar = {
        let sb = UISearchBar()
        sb.placeholder = "Enter username"
        sb.barTintColor = .gray
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).backgroundColor = UIColor.rgb(red: 230, green: 230, blue: 230)
        sb.delegate = self
        return sb
    }()
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText.isEmpty {
            filteredUsers = users
        }else {
            filteredUsers = self.users.filter { (user) -> Bool in
                return (user.username.lowercased().contains(searchText.lowercased()))
            }
        }

        self.collectionView?.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.backgroundColor = .white
        
        navigationController?.navigationBar.addSubview(searchBar)
        
        let navBar = navigationController?.navigationBar
        
        searchBar.anchor(top: navBar?.topAnchor, left: navBar?.leftAnchor, bottom: navBar?.bottomAnchor, right: navBar?.rightAnchor, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 8, width: 0, height: 0)
        
        collectionView?.register(UserSearchCell.self, forCellWithReuseIdentifier: cellId)
        
        collectionView?.alwaysBounceVertical = true
        collectionView?.keyboardDismissMode = .onDrag
        
        fetchUsers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        searchBar.isHidden = false
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        searchBar.isHidden = true
        searchBar.resignFirstResponder()
        
        let user = filteredUsers[indexPath.item]
        
        let userProfileController = UserProfileController(collectionViewLayout: UICollectionViewFlowLayout())
        userProfileController.userId = user.id
        navigationController?.pushViewController(userProfileController, animated: true)
    }
    
    var filteredUsers = [User]()
    var users = [User]()
    fileprivate func fetchUsers(){
        //NEED TO DO: FETCH ALL USERS IN DB
        
        //NEED TO DO: STORE ALL USERS IN THIS DICT
        //guard let dictionaries = value as? [String:Any]() else {return}
        
        //CYCLE THROUGH ALL USERS AND ADD TO DATA SOURCE FOR THIS COLLECTION VIEW
        /*
        dictionaries.forEach { (key,value) in
         
            //DONT SHOW USER THAT IS YOURSELF IN SEARCH
             if key == MY USER ID {
                return
             }
         
            guard let userDictionary = value as? [String: Any] else {return }
            let user = User(uid:key, dictionary: userDictionary)
            self.users.append(user)
        }
        */
        
        //THIS IS A DUMMY USER, DESTORY THIS ONCE CORRECT IMPLEMENTATION IS DONE
        let user = User(dictionary: ["id": "123", "username": "Billy Bob"])
        self.users.append(user)
        
        //sort list alphabetically
        self.users.sort { (u1, u2) -> Bool in
            return u1.username.compare(u2.username) == .orderedAscending
        }
        
        //gives filtered users master list of users until filtered
        self.filteredUsers = self.users
        
        self.collectionView?.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 66)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredUsers.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! UserSearchCell
        
        cell.user = filteredUsers[indexPath.item]
        
        return cell
    }
}
