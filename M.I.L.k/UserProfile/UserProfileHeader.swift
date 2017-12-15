//
//  UserProfileHeader.swift
//  M.I.L.k
//
//  Created by noah davidson on 12/15/17.
//  Copyright © 2017 noah davidson. All rights reserved.
//

import UIKit

class UserProfileHeader: UICollectionViewCell{
    
    let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .red
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .blue
        
        addSubview(profileImageView)
        profileImageView.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 12, paddingLeft: 12, paddingBottom: 0, paddingRight: 0, width: 80, height: 80)
        
        profileImageView.layer.cornerRadius = 80 / 2
        profileImageView.clipsToBounds = true
        
    }
    
    var user: User? {
        didSet{
            //print("Did set \(user?.username)")
            //make fetch for image here
            setupProfileImage()
        }
    }
    
    fileprivate func setupProfileImage(){
        //NEED TO DO: SET UP USER IMAGE FOR PROFILEIMAGEVIEW
        //let url = URL(string: String)
        
        //make sure cell changes are happening in the correct thread
        //dispatchqueue.main.async{
            //self.profileImageView.image = image
        //}
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
