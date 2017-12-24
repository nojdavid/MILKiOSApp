//
//  HomeCollectionController.swift
//  M.I.L.k
//
//  Created by noah davidson on 12/20/17.
//  Copyright © 2017 noah davidson. All rights reserved.
//

import UIKit

class HomeCollectionController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let cellId = "cellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //UPDATE FEED WHEN SOMEONE SHARES A NEW PHOTO
        NotificationCenter.default.addObserver(self, selector: #selector(handleUpdateFeed), name: SharePhotoController.updateFeedNotificationName, object: nil)
        
        //MANUAL SCROLL REFRESH
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        collectionView?.refreshControl = refreshControl
        
        collectionView?.backgroundColor = .white
        
        navigationItem.titleView = UIImageView(image: #imageLiteral(resourceName: "logo2"))
        
        collectionView?.register(HomeCollectionPostCell.self, forCellWithReuseIdentifier: cellId)
        
        fetchAllPosts()
    }
    
    //UPDATE FEED WHEN SOMEONE SHARES A NEW PHOTO
    @objc func handleUpdateFeed(){
        print("Shared a new photo")
        handleRefresh()
    }
    
    //MANUAL SCROLL REFRESH
    @objc func handleRefresh(){
        print("handle refresh...")
        posts.removeAll()
        fetchAllPosts()
    }
    
    var posts = [Post]()
    fileprivate func fetchAllPosts(){
        //NEED TO DO: GET ALL POSTS FOR APP LOAD PROPERLY!!!!!
        
        //THIS VALUE NEED TO BE IMAGE POST INFO. REMOVE WHEN HAVE DB INFO
        let value = [String: Any]()
        
        self.collectionView?.refreshControl?.endRefreshing()
        
        //NEED TO DO: GET IMAGE POST VALUES AND SAVE IT TO THIS VARIABLE
        guard let dictionary = value as? [String : Any] else {return}
        
        
        for index in 1...20{
            //THIS DUMMY USER NEEDS TO BE UPDATED TO REAL USER
            let dummyUser = User(dictionary: ["id": String(index), "username": "Noah Davidson "+String(index)])
            
            //SAVE IMAGE INFO IN POST OBJ
            var post = Post(user: dummyUser, dictionary: dictionary)
            post.id = "SOMEDUMMYKEY"
            
            //NEED TO DO:FOR EACH POST CHECK IF USER HAS LIKED THEM AND SET EACH POST ACCORDINGLY
            self.posts.append(post)
        }
        
        
        self.posts.sort { (p1, p2) -> Bool in
            return p1.creationDate.compare(p2.creationDate) == .orderedDescending
        }
        
        self.collectionView?.reloadData()
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let post = posts[indexPath.item]
        let detailHomeController = HomeController(collectionViewLayout: UICollectionViewFlowLayout())
        detailHomeController.post = post
        navigationController?.pushViewController(detailHomeController, animated: true)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! HomeCollectionPostCell
            cell.post = posts[indexPath.item]
            return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = (view.frame.width - 2) / 3
        return CGSize(width: width, height:width)
    }
    
}
