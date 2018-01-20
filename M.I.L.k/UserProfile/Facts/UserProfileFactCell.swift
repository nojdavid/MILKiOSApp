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
            let attributedText = NSMutableAttributedString(string: fact!, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 16)])
            
            factLabel.attributedText = attributedText
        }
    }
    
    let factLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(factLabel)
        factLabel.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 20, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
