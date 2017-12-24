//
//  CommentCell.swift
//  M.I.L.k
//
//  Created by noah davidson on 12/18/17.
//  Copyright © 2017 noah davidson. All rights reserved.
//

import UIKit

class CommentCell: UICollectionViewCell {
    
    var comment: Comment?{
        didSet{
            guard let comment = comment else {return}

            let attributedText = NSMutableAttributedString(string: comment.user.username, attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 14)])
            
            attributedText.append(NSAttributedString(string: " " + comment.text, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14)]))
            
            textView.attributedText = attributedText

            //guard let image = comment.user.profileImageUrl else {return}
            //profileImageView.loadImage(urlString: image)
        }
    }
    
    let profileImageView : CustomImageView = {
        let iv = CustomImageView()
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = .yellow
        return iv
    }()
    
    let textView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 14)
        textView.isScrollEnabled = false
        return textView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(profileImageView)
        profileImageView.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 8, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 40, height: 40)
        profileImageView.layer.cornerRadius = 40/2
        
        addSubview(textView)
        textView.anchor(top: topAnchor, left: profileImageView.rightAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 4, paddingLeft: 4, paddingBottom: 4, paddingRight: 4, width: 0, height: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
