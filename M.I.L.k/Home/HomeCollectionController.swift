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
    var page: Int = 1
    var totalCells: Int? = 0
    var posts = [Post]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initPage()
        
        //UPDATE FEED WHEN SOMEONE SHARES A NEW PHOTO
        NotificationCenter.default.addObserver(self, selector: #selector(handleUpdateFeed), name: ShareController.updateFeedNotificationName, object: nil)
        
        //MANUAL SCROLL REFRESH
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        collectionView?.refreshControl = refreshControl
        
        collectionView?.backgroundColor = .white
        
        navigationItem.titleView = UIImageView(image: #imageLiteral(resourceName: "logo2"))
        
        collectionView?.register(HomeCollectionPostCell.self, forCellWithReuseIdentifier: cellId)
    }
    
    fileprivate func initPage(){
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
        self.page = 1
        fetchAllPosts()
    }

    fileprivate func fetchAllPosts(){
        // Update UI
        //DispatchQueue.main.async {
            self.collectionView?.refreshControl?.endRefreshing()
        // }
        
        let dict = ["limit":"24","page":"\(self.page)"]
        FetchPosts(dict: dict) { (result) in
            switch result {
            case .success(let posts):
                guard let total = posts.count else {return}
                guard let objects = posts.rows else {return}
                
                //remove all posts and restart list if pagination is from beginning
                if (self.page == 1) {
                     self.posts.removeAll()
                }
                
                //TODO REMOVE THIS LOGIC AND ALWAYS HAVE POSTS WITH IMAGES
                for (_, post) in objects.enumerated() {
                    if post.images.count > 0 {
                        self.posts.append(post)
                    } else {
                        //if not valid image, lower total
                        self.totalCells = total - 1
                    }
                }
                
                //self.posts = posts
                
//                self.posts.sort { (p1, p2) -> Bool in
//                    return p1.created_at?.compare(p2.created_at!) == .orderedDescending
//                }
                
                self.collectionView?.reloadData()
                return
                
            case .failure(let error):
                print("FAILURE POSTS:", error)
                return
            }
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let post = posts[indexPath.item]
        
        let detailHomeController = DetailPostController(collectionViewLayout: UICollectionViewFlowLayout())
        detailHomeController.post = post
        
        navigationController?.pushViewController(detailHomeController, animated: true)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! HomeCollectionPostCell
            cell.post = self.posts[indexPath.item]
            return cell
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        guard let totalCells = self.totalCells else {return}
        if indexPath.row == self.posts.count - 1 { // last cell
            if totalCells > self.posts.count { // more items to fetch
                print("GET MORE")
                self.page += 1
                fetchAllPosts()
            }
        }
        
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
