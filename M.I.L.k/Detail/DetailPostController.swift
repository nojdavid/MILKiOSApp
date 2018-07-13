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
    var user: User?
    
    lazy var backButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: #imageLiteral(resourceName: "back_arrow").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleDismiss))
        return button
    }()
    
    @objc func handleDismiss(){
        navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.user = Store.shared().user
        
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
        
        cell.user = self.user
        cell.post = self.post
        cell.delegate = self
        
        return cell
    }
    
    func presentAlert(alert: UIAlertController) {
        present(alert, animated: true, completion: nil)
    }
    
    func closeAlert() {
        self.handleDismiss()
    }
    
    func didTabComment(post: Post) {
        hidesBottomBarWhenPushed = true
        let commentsController = CommentsController(collectionViewLayout: UICollectionViewFlowLayout())
        commentsController.post = post
        
        navigationController?.pushViewController(commentsController, animated: true)
        hidesBottomBarWhenPushed = false
    }
    
    //Like User Post
    func didLike(for cell: DetailPostCell) {
        guard let user_id = self.user?.id else {return}
        guard let post_id = self.post?.id else {return}
        let post_like = !cell.isLiked!
        
        guard let indexPath = collectionView?.indexPath(for: cell) else {return}
        
        let like = LikeConfig(is_liked: post_like)
        
        createLikePost(post_id: post_id, like: like)  { (result) in
            switch result {
            case .success(let like):
                print("SUCCESS LIKE:", like)
                break
            case .failure(let error):
                print("FAILURE POSTS:", error)
                break
            }
        }
        
        //remove or append Like to post list
        if (post_like) {
            post?.likes.append(Like(user_id: user_id))
        } else {
            let likes = post?.likes.filter { $0.user_id != user_id }
            post?.likes = likes!
        }
        
        cell.post = post
        
        self.collectionView?.reloadItems(at: [indexPath])
    }
}

//extension DetailPostController  {
//    
//}
