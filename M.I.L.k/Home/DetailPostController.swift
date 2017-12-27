//
//  HomeController.swift
//  M.I.L.k
//
//  Created by noah davidson on 12/16/17.
//  Copyright © 2017 noah davidson. All rights reserved.
//

import UIKit

class DetailPostController : UICollectionViewController, UICollectionViewDelegateFlowLayout, HomePostCellDelegate{
    
    let cellId = "cellId"
    var post: Post?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.backgroundColor = .white
        
        collectionView?.register(DetailPostCell.self, forCellWithReuseIdentifier: cellId)
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        collectionView?.refreshControl = refreshControl
        
        navigationItem.title = "Photo"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "back_arrow"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(handleBack))
 
        renderPost()
    }
    
    @objc func handleBack(){
       navigationController?.popViewController(animated: true)
    }

    @objc func handleRefresh(){
        print("handle refresh...")
        posts.removeAll()
        renderPost()
    }
    
    var posts = [Post]()
    fileprivate func renderPost(){

        self.collectionView?.refreshControl?.endRefreshing()

        self.posts.append(post!)

        self.collectionView?.reloadData()
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! DetailPostCell
        
        cell.post = posts[indexPath.item]
        
        cell.delegate = self
        
        return cell
    }
    
    func didTabComment(post: Post) {
        hidesBottomBarWhenPushed = true
        let commentsController = CommentsController(collectionViewLayout: UICollectionViewFlowLayout())
        commentsController.post = post
        navigationController?.pushViewController(commentsController, animated: true)
        hidesBottomBarWhenPushed = false
    }
    
    func didLike(for cell: DetailPostCell) {
        
        guard let indexPath = collectionView?.indexPath(for: cell) else {return}
        
        var post = self.posts[indexPath.item]
        
        guard let postId = post.id else {return}
        
        //NEED TO DO: GET CURRENT USER ID
        //guard let uid = "1" else {return}
        
        //let values = [uid:post.hasLiked == true ? 0 : 1]
        
        //NEED TO DO: UPDATE LIKES FOR USER OF UID
        
        post.hasLiked = !post.hasLiked
        
        self.posts[indexPath.item] = post
        
        self.collectionView?.reloadItems(at: [indexPath])
    }
}
