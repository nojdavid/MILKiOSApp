//
//  UserProfileFactHeader.swift
//  M.I.L.k
//
//  Created by noah davidson on 1/18/18.
//  Copyright © 2018 noah davidson. All rights reserved.
//

import UIKit

protocol UserProfileFactHeaderDelegate {
    func toggleSection(header: UserProfileFactHeader, section: Int)
}

class UserProfileFactHeader : UICollectionViewCell{
    
    var delegate: UserProfileFactHeaderDelegate?
    static let identifier = "UserProfileFactHeader"
    var section: Int = 0
    var item: FactViewModelItem? {
        didSet{
            guard let item = item else {return}
            
            let attributedText = NSMutableAttributedString(string: item.sectionTitle, attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 20)])
            
            sectionLabel.attributedText = attributedText

            setCollapsed(collapsed: item.isCollapsed)
        }
    }
    
    
    let arrowLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor(patternImage: UIImage(named: "drop_down_arrow")!)
        return label
    }()
 
    
    let arrowImage: UIImageView = {
        let image = UIImageView(image: UIImage(named: "drop_down_arrow")!)
        return image
    }()
    
    let sectionLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapHeader)))
        
        addSubview(arrowImage)
        arrowImage.anchor(top: nil, left: nil, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 15, width: 20, height: 25)
        arrowImage.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        addSubview(sectionLabel)
        sectionLabel.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: arrowImage.leftAnchor, paddingTop: 0, paddingLeft: 15, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        sectionLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    func setCollapsed(collapsed: Bool){
        //print("ROTATING IMAGE", collapsed, section)
        arrowImage.rotate(collapsed ? 0.0 : .pi)
    }
    
    @objc private func didTapHeader(){
        //print("DIDTAP::", section)
        delegate?.toggleSection(header: self, section: section)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension UIView {
    func rotate(_ toValue: CGFloat, duration: CFTimeInterval = 0.2) {
        let animation = CABasicAnimation(keyPath: "transform.rotation")
        
        animation.toValue = toValue
        animation.duration = duration
        animation.isRemovedOnCompletion = false
        animation.fillMode = kCAFillModeForwards
        
        self.layer.add(animation, forKey: nil)
    }
}
