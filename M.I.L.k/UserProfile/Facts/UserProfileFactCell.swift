//
//  UserProfileFactCell.swift
//  M.I.L.k
//
//  Created by noah davidson on 1/18/18.
//  Copyright © 2018 noah davidson. All rights reserved.
//

import UIKit

class UserProfileFactCell : UICollectionViewCell{
    
    static let identifier = "UserProfileFactCell"
    
    var fact: String? {
        didSet{
            let attributedText = NSMutableAttributedString(string: fact!, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 15)])
            factLabel.attributedText = attributedText
        }
    }
    
    let factLabel: UILabel = {
        let label = UILabel()
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 5
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
         let bottomSeperator = UIView()
        bottomSeperator.backgroundColor = UIColor.gray
        
        addSubview(factLabel)
        addSubview(bottomSeperator)
        
        factLabel.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 20, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        bottomSeperator.anchor(top: nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 8, width: 0, height: 0.5)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
