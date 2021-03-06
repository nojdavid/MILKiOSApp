//
//  UserProfileHeader.swift
//  M.I.L.k
//
//  Created by noah davidson on 12/15/17.
//  Copyright © 2017 noah davidson. All rights reserved.
//

import UIKit

protocol UserProfileHeaderDelegate {
    func didChangeToLikeListView()
    func didChangeToGridView()
    func didChangeToFactsView()
    func didChangeToSettingsView()
}

class UserProfileHeader: UICollectionViewCell{
    
    static let identifier = "UserProfileHeader"
    
    var delegate: UserProfileHeaderDelegate?
    
    var user: User? {
        didSet{
            //guard let profileImageUrl = user?.profileImageUrl else {return}
            //profileImageView.loadImage(urlString: profileImageUrl)
            
            usernameLabel.text = user?.username
            
            setupEditButton()
        }
    }
    
    fileprivate func setupEditButton(){
        guard let currentLoggedInUser = getUserFromDisk() else {return}
        
        guard let userId = user?.id else {return}
        
        if currentLoggedInUser.id == userId {
            //edit profile button
            editProfileButton.isEnabled = true
            editProfileButton.backgroundColor = .white
        }else {
            //hide edit profile
            editProfileButton.isEnabled = true
            editProfileButton.setTitleColor(.white, for: .normal)
            editProfileButton.layer.borderColor = UIColor.white.cgColor
        }
    }
    
    let profileImageView: CustomImageView = {
        let iv = CustomImageView()
        iv.backgroundColor = .red
        return iv
    }()
    
    lazy var gridButton: UIButton = {
        let button = UIButton(type: UIButtonType.system)
        button.setImage(#imageLiteral(resourceName: "grid"), for: .normal)
        button.addTarget(self, action: #selector(handleChangeToGridView), for: .touchUpInside)
        return button
    }()
    
    @objc func handleChangeToGridView(){
        print("change to grid view")
        
        gridButton.tintColor = .mainBlue()
        likeListButton.tintColor = UIColor(white:0, alpha:0.2)
        factsButton.tintColor = UIColor(white:0, alpha:0.2)
        
        delegate?.didChangeToGridView()
    }
    
    lazy var likeListButton: UIButton = {
        let button = UIButton(type: UIButtonType.system)
        button.setImage(#imageLiteral(resourceName: "unselected_like_list"), for: .normal)
        button.tintColor = UIColor(white: 0, alpha: 0.2)
        button.addTarget(self, action: #selector(handleChangeToLikeListView), for: .touchUpInside)
        return button
    }()
    
    @objc func handleChangeToLikeListView(){
        print("change to Like view")
        
        likeListButton.tintColor = .mainBlue()
        gridButton.tintColor = UIColor(white:0, alpha:0.2)
        factsButton.tintColor = UIColor(white:0, alpha:0.2)
        
        delegate?.didChangeToLikeListView()
    }
    
    lazy var factsButton: UIButton = {
        let button = UIButton(type: UIButtonType.system)
        button.setImage(#imageLiteral(resourceName: "list"), for: .normal)
        button.tintColor = UIColor(white: 0, alpha: 0.2)
        button.addTarget(self, action: #selector(handleChangeToFactsView), for: .touchUpInside)
        return button
    }()
    
    @objc func handleChangeToFactsView(){
        print("change to Facts view")
        
        factsButton.tintColor = .mainBlue()
        likeListButton.tintColor = UIColor(white:0, alpha:0.2)
        gridButton.tintColor = UIColor(white:0, alpha:0.2)
        
        delegate?.didChangeToFactsView()
    }
    
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.text = "username"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    let postsLabel: UILabel = {
        let label = UILabel()
        
        let attributedText = NSMutableAttributedString(string: "0\n", attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 14)])
        
        attributedText.append(NSAttributedString(string: "posts", attributes: [NSAttributedStringKey.foregroundColor: UIColor.lightGray, NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14)]))
        
        
        label.attributedText = attributedText
        
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    
    let followersLabel: UILabel = {
        let label = UILabel()
        
        let attributedText = NSMutableAttributedString(string: "0\n", attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 14)])
        
        attributedText.append(NSAttributedString(string: "followers", attributes: [NSAttributedStringKey.foregroundColor: UIColor.lightGray, NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14)]))
        
        label.attributedText = attributedText
        
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    let followingLabel: UILabel = {
        let label = UILabel()
        
        let attributedText = NSMutableAttributedString(string: "0\n", attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 14)])
        
        attributedText.append(NSAttributedString(string: "following", attributes: [NSAttributedStringKey.foregroundColor: UIColor.lightGray, NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14)]))
        
        label.attributedText = attributedText
        
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    lazy var editProfileButton: UIButton = {
        let button = UIButton(type: UIButtonType.system)
        button.setTitle("Edit Profile", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 3
        button.addTarget(self, action: #selector(handleEditProfile), for: .touchUpInside)
        return button
    }()
    
    @objc func handleEditProfile(){
        print("Handle Edit Profile")
        delegate?.didChangeToSettingsView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        //ADD PROFILE IMAGE AND ANCHOR TO VIEW
        addSubview(profileImageView)
        profileImageView.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 12, paddingLeft: 12, paddingBottom: 0, paddingRight: 0, width: 80, height: 80)
        profileImageView.layer.cornerRadius = 80 / 2
        profileImageView.clipsToBounds = true
        
        //CREATE TOOLBAR
        setupBottomToolbar()
        
        //ADD USERNAME LABEL AND ANCHOR TO VIEW
        addSubview(usernameLabel)
        usernameLabel.anchor(top: profileImageView.bottomAnchor, left: leftAnchor, bottom: gridButton.topAnchor, right: rightAnchor, paddingTop: 4, paddingLeft: 12, paddingBottom: 0, paddingRight: 12, width: 0, height: 0)
        
        //ADD STACKVIEW FOR: POSTS, FOLLOWERS, FOLLOWING
        setupUserStats()
        
        //ADD VIEW FOR EDIT PROF BUTTON UNDER POSTS
        addSubview(editProfileButton)
        editProfileButton.anchor(top: postsLabel.bottomAnchor, left: postsLabel.leftAnchor, bottom: nil, right: followingLabel.rightAnchor, paddingTop: 2, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 34)
    }
    
    fileprivate func setupUserStats(){
        let stackView = UIStackView(arrangedSubviews: [postsLabel, followersLabel, followingLabel])
        stackView.distribution = .fillEqually
        
        addSubview(stackView)
        stackView.anchor(top: topAnchor, left: profileImageView.rightAnchor, bottom: nil, right: rightAnchor, paddingTop: 12, paddingLeft: 12, paddingBottom: 0, paddingRight: 12, width: 0, height: 50)
    }
    
    fileprivate func setupBottomToolbar(){
        
        let topDividerView = UIView()
        topDividerView.backgroundColor = UIColor.lightGray
        
        let bottomDividerView = UIView()
        bottomDividerView.backgroundColor = UIColor.lightGray
        
        let stackView = UIStackView(arrangedSubviews: [gridButton, likeListButton, factsButton])
        
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        
        addSubview(stackView)
        addSubview(topDividerView)
        addSubview(bottomDividerView)
        
        stackView.anchor(top: nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 50)
        
        topDividerView.anchor(top: stackView.topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0.5)
        
        bottomDividerView.anchor(top: stackView.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0.5)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
