//
//  SettingCell.swift
//  M.I.L.k
//
//  Created by Noah Davidson on 6/25/18.
//  Copyright © 2018 noah davidson. All rights reserved.
//

import UIKit

class SettingsCell : UITableViewCell, UITextFieldDelegate {
    
    static let reuseIdentifer = "SettingsCell"
    
    var cellSetting: String? {
        didSet {
            label.text = cellSetting
            textField.placeholder = cellSetting
        }
    }
    
    let label: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        return label
    }()
    
    let textField: UITextField = {
        let tf = UITextField()
        tf.backgroundColor = UIColor.white
        tf.borderStyle = UITextBorderStyle.none
        tf.font = UIFont.systemFont(ofSize: 18)
        tf.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        return tf
    }()
    
    @objc func handleTextInputChange(){
//        let isFormValid = emailTextField.text?.count ?? 0 > 0 && userNameTextField.text?.count ?? 0 > 0 && passwordTextField.text?.count ?? 0 > 5
//        if isFormValid{
//            signUpButton.isEnabled = true
//            signUpButton.backgroundColor = UIColor.rgb(red: 17, green: 154, blue: 237)
//        }else{
//            signUpButton.isEnabled = false
//            signUpButton.backgroundColor = UIColor.rgb(red:149,green:204,blue:244)
//        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let dividerView = UIView()
        dividerView.backgroundColor = UIColor.unselectedGrey()
        
        addSubview(label)
        addSubview(textField)
        addSubview(dividerView)
        
        label.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 20, paddingBottom: 0, paddingRight: 0, width: 100, height: 50)
        
        label.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        textField.anchor(top: topAnchor, left: label.rightAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 20, paddingBottom: 0, paddingRight: 20, width: 0, height: 50)
        
        textField.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        dividerView.anchor(top: textField.bottomAnchor, left: textField.leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 10, width: 0, height: 0.5)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
