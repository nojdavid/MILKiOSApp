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
    
    lazy var backButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: #imageLiteral(resourceName: "back_arrow").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleDismiss))
        return button
    }()
    
    @objc func handleDismiss(){
        navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.backgroundColor = .white
        
        collectionView?.register(DetailPostCell.self, forCellWithReuseIdentifier: cellId)

        navigationItem.title = "Photo"
        
        navigationItem.leftBarButtonItem = backButton
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var height: CGFloat = 40 + 8 + 8 //username and userprofileImageview
        height += view.frame.width
        height += 50
        height += 60
        
        return CGSize(width: view.frame.width, height: height)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! DetailPostCell
        
        cell.post = post
        
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
        
        guard let post = post else {return}
        guard let indexPath = collectionView?.indexPath(for: cell) else {return}

        //guard let postId = post.id else {return}
        
        //NEED TO DO: GET CURRENT USER ID
        //guard let uid = "1" else {return}
        
        //let values = [uid:post.hasLiked == true ? 0 : 1]
        
        //NEED TO DO: UPDATE LIKES FOR USER OF UID
        self.post?.hasLiked = !post.hasLiked

        self.collectionView?.reloadItems(at: [indexPath])
    }
}
