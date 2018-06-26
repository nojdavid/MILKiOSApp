//
//  SettingHeader.swift
//  M.I.L.k
//
//  Created by Noah Davidson on 6/25/18.
//  Copyright © 2018 noah davidson. All rights reserved.
//

import UIKit

protocol SettingsHeaderDelegate {
    func openImagePicker()
    func closeImagePicker()
}

class SettingsHeader: UITableViewHeaderFooterView {
    var delegate: SettingsHeaderDelegate?
    
    var userImage: UIImage? {
        didSet {
            print("--userImage", userImage)
            if (userImage != nil) {
                plusPhotoButton.setImage(userImage, for: .normal)
                
                plusPhotoButton.layer.cornerRadius = plusPhotoButton.frame.width/2
                plusPhotoButton.layer.masksToBounds = true
                plusPhotoButton.layer.borderColor = UIColor.black.cgColor
                plusPhotoButton.layer.borderWidth = 3
            }
        }
    }
    
    static let reuseIdentifer = "SettingsHeaderReuseIdentifier"
    let customLabel : UILabel = {
        let label = UILabel()
        label.isUserInteractionEnabled = true
        label.font = UIFont.boldSystemFont(ofSize: 13)
        label.textColor = UIColor.mainBlue()
        return label
    }()
    
    let plusPhotoButton : UIButton = {
        let button = UIButton(type: UIButtonType.system)
        button.setImage(#imageLiteral(resourceName: "plus_photo").withRenderingMode(.alwaysOriginal), for: UIControlState.normal)
        button.addTarget(self, action: #selector(handlePlusPhoto), for: .touchUpInside)
        return button
    }()
    
    @objc func handlePlusPhoto(){
        delegate?.openImagePicker()
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        print("SUCCESS IMAGE: ")
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage{
            plusPhotoButton.setImage(editedImage.withRenderingMode(.alwaysOriginal), for: .normal)
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage{
            plusPhotoButton.setImage(originalImage.withRenderingMode(.alwaysOriginal), for: .normal)
        }

        plusPhotoButton.layer.cornerRadius = plusPhotoButton.frame.width/2
        plusPhotoButton.layer.masksToBounds = true
        plusPhotoButton.layer.borderColor = UIColor.black.cgColor
        plusPhotoButton.layer.borderWidth = 3

        delegate?.closeImagePicker()
    }
    
    override public init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        setupHeaderUI()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handlePlusPhoto))
        customLabel.addGestureRecognizer(tap)
    }
    
    func setupHeaderUI() {
        
        let margins = contentView.layoutMarginsGuide
        
        self.backgroundView = UIView(frame: self.bounds)
        self.backgroundView?.backgroundColor = UIColor(white: 0.9, alpha: 0.5)
        
        let dividerView = UIView()
        dividerView.backgroundColor = UIColor.lightGray
        
        //Add profile Image Picker
        self.contentView.addSubview(plusPhotoButton)
        self.contentView.addSubview(customLabel)
        self.contentView.addSubview(dividerView)
        
        plusPhotoButton.anchor(top: margins.topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 100, height: 100)
        
        plusPhotoButton.centerXAnchor.constraint(equalTo: margins.centerXAnchor).isActive = true
        
        customLabel.anchor(top: plusPhotoButton.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: 10, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 20)
        
        customLabel.centerXAnchor.constraint(equalTo: margins.centerXAnchor).isActive = true
        
        dividerView.anchor(top: nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0.5)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
