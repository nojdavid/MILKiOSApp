//
//  HomeController.swift
//  M.I.L.k
//
//  Created by noah davidson on 12/16/17.
//  Copyright © 2017 noah davidson. All rights reserved.
//

import UIKit

class HomeController : UICollectionViewController, UICollectionViewDelegateFlowLayout{
    
    let cellId = "cellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(handleUpdateFeed), name: SharePhotoController.updateFeedNotificationName, object: nil)
        
        collectionView?.backgroundColor = .white
        
        collectionView?.register(HomePostCell.self, forCellWithReuseIdentifier: cellId)
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        collectionView?.refreshControl = refreshControl
        
        setupNavigationItems()
        
        //NEED TO DO: FETCH POSTS FOR ENTIRE APP & FIGURE OUT HOW TO LOAD PROPERLY
        fetchAllPosts()
    }
    
    @objc func handleUpdateFeed(){
        handleRefresh()
    }
    
    @objc func handleRefresh(){
        print("handle refresh...")
        posts.removeAll()
        fetchAllPosts()
    }
    
    //IOS9
    //let refreshControl = UIRefreshControl()
    
    var posts = [Post]()
    fileprivate func fetchAllPosts(){
        //NEED TO DO: GET ALL POSTS FOR APP LOAD PROPERLY!!!!!
        
        //THIS VALUE NEED TO BE IMAGE POST INFO. REMOVE WHEN HAVE DB INFO
        let value = [String: Any]()
        
        self.collectionView?.refreshControl?.endRefreshing()
        
        //NEED TO DO: GET IMAGE POST VALUES AND SAVE IT TO THIS VARIABLE
        guard let dictionary = value as? [String : Any] else {return}
        
        //THIS DUMMY USER NEEDS TO BE UPDATED TO REAL USER
        let dummyUser = User(uid: "123", dictionary: ["username": "Noah Davidson"])

        //SAVE IMAGE INFO IN POST OBJ
        let post = Post(user: dummyUser, dictionary: dictionary)
        
        //POST ALL POSTS NOT JUST FROM USER THAT IS LOGGED IN ON THIS DEVICE
        self.posts.append(post)
        
        self.posts.sort { (p1, p2) -> Bool in
            return p1.creationDate.compare(p2.creationDate) == .orderedDescending
        }
        
        self.collectionView?.reloadData()
        
        
    }
    
    func setupNavigationItems(){
        navigationItem.titleView = UIImageView(image: #imageLiteral(resourceName: "logo2"))
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "camera").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleCamera))
    }
    
    @objc func handleCamera(){
        let cameraController = CameraController()
        present(cameraController, animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var height: CGFloat = 40 + 8 + 8 //username and userprofileImageview
        height += view.frame.width
        height += 50
        height += 60
        
        return CGSize(width: view.frame.width, height: height)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! HomePostCell
        
        cell.post = posts[indexPath.item]
        
        return cell
    }
    
}
