//
//  HomePostCell.swift
//  M.I.L.k
//
//  Created by noah davidson on 12/16/17.
//  Copyright © 2017 noah davidson. All rights reserved.
//

import UIKit

protocol HomePostCellDelegate {
    func didTabComment(for cell: DetailPostCell)
    func didLike(for cell: DetailPostCell)
    func presentAlert(alert: UIAlertController)
    func closeAlert()
}

class DetailPostCell : UICollectionViewCell{
    
    var delegate: HomePostCellDelegate?
    var user: User?
    
    var post: Post?{
        didSet{
            guard let post = post else {return}
            guard let user_id = self.user?.id else {return}
            guard let postImageUrl = post.images[0].url else {return}
            print("--Post", post)
            photoImageView.loadImage(urlString: postImageUrl)

            //TODO MAKE THIS THE POST AUTHOR USERNAME
            usernameLabel.text = "MY USERNAME HERE"
            
            //guard let profileImageUrl = post?.user.profileImageUrl else {return}
            //userProfileImageView.loadImage(urlString: profileImageUrl)
            
            print("POST LIKES:", post.likes, user_id)
            let isLiked = post.likes.first(where: {$0.user_id == user_id})
            self.isLiked = (isLiked != nil) ? true : false
            
            captionLabel.text = post.caption
            setupAttributedCaption()
        }
    }
    
    var isLiked : Bool? {
        didSet {
            if isLiked == true {
                likeButton.setImage(#imageLiteral(resourceName: "like_selected").withRenderingMode(.alwaysTemplate), for: .normal)
                likeButton.tintColor = UIColor.red
            } else {
                likeButton.setImage( #imageLiteral(resourceName: "like_unselected").withRenderingMode(.alwaysOriginal), for: .normal)
            }
        }
    }
    
    fileprivate func setupAttributedCaption(){
        
        guard let post = self.post else {return}
        
        //TODO put post.username insteda of post.user_id
        let attributedText = NSMutableAttributedString(string: "USERNAME HERE ", attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 14)])
        
        
        attributedText.append(NSAttributedString(string: post.caption != nil ? post.caption! : "", attributes:[NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14)]))
        
        attributedText.append(NSAttributedString(string: "\n\n",attributes:[NSAttributedStringKey.font: UIFont.systemFont(ofSize: 4)]))

        let timeAgoDisplay = post.created_at?.timeAgoDisplay()
        attributedText.append(NSAttributedString(string: timeAgoDisplay!, attributes:[NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14), NSAttributedStringKey.foregroundColor: UIColor.gray]))
        
        self.captionLabel.attributedText = attributedText
    }
    
    let userProfileImageView: CustomImageView = {
        let iv = CustomImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .blue
        return iv
    }()
    
    
    let photoImageView: CustomImageView = {
        let iv = CustomImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .unselectedGrey()
        return iv
    }()
    
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.text = "Username"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    //TODO options button is not responsive
    lazy var optionsButton: UIButton = {
        let button = UIButton(type: UIButtonType.system)
        button.setTitle("•••", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(handleOptions), for: .touchUpInside)
        return button
    }()
    
    lazy var likeButton: UIButton = {
        let button = UIButton(type: UIButtonType.system)
        button.setImage(#imageLiteral(resourceName: "like_unselected").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleLike), for: .touchUpInside)
        return button
    }()
    
    @objc func handleOptions() {
        //post options alert
         let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        guard let post = self.post else {return}
        
        if self.post?.user_id == self.user?.id {
            alertController.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { (_) in
                //Todo add add DELETE route here
                DeletePost(post_id: post.id!) { (result) in
                    switch result {
                    case .success(let posts):
                         self.delegate?.closeAlert()
                        return
                        
                    case .failure(let error):
                        print("FAILURE POSTS:", error)
                        return
                    }
                }
            }))
        } else {
            alertController.addAction(UIAlertAction(title: "Report", style: .destructive, handler: { (_) in
                //TODO ADD reporting
//                DeletePost(post_id: post.id!) { (result) in
//                    switch result {
//                    case .success(let posts):
//                        self.delegate?.closeAlert()
//                        return
//
//                    case .failure(let error):
//                        print("FAILURE POSTS:", error)
//                        return
//                    }
//                }
            }))
        }
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.delegate?.presentAlert(alert: alertController)
    }
    
    @objc func handleLike(){
        delegate?.didLike(for: self)
    }
    
    lazy var commentButton: UIButton = {
        let button = UIButton(type: UIButtonType.system)
        button.setImage(#imageLiteral(resourceName: "comment").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleComment), for: .touchUpInside)
        return button
    }()
    
    @objc func handleComment(){
        delegate?.didTabComment(for: self)
    }
    
//    let sendMessageButton: UIButton = {
//        let button = UIButton(type: UIButtonType.system)
//        button.setImage(#imageLiteral(resourceName: "send2").withRenderingMode(.alwaysOriginal), for: .normal)
//        return button
//    }()
    
    let captionLabel : UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(userProfileImageView)
        addSubview(usernameLabel)
        addSubview(optionsButton)
        addSubview(photoImageView)
        
        userProfileImageView.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 8, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 40, height: 40)
        userProfileImageView.layer.cornerRadius = 40/2
        
        usernameLabel.anchor(top: topAnchor, left: userProfileImageView.rightAnchor, bottom: photoImageView.topAnchor, right: nil, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        optionsButton.anchor(top: nil, left: nil, bottom: nil, right: photoImageView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 8, width: 40, height: 40)
        optionsButton.centerYAnchor.constraint(equalTo: usernameLabel.centerYAnchor).isActive = true
        
        photoImageView.anchor(top: userProfileImageView.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 8, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        photoImageView.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 1).isActive = true

        setupActionButtons()
        
        addSubview(captionLabel)
        captionLabel.anchor(top: likeButton.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 8, width: 0, height: 0)
    }
    
    fileprivate func setupActionButtons(){
        let stackView = UIStackView(arrangedSubviews: [likeButton, commentButton/*, sendMessageButton*/])
        
        stackView.distribution = .fillEqually
        
        addSubview(stackView)
        stackView.anchor(top: photoImageView.bottomAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 80, height: 50)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
