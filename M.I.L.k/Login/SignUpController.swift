//
//  ProfileViewController.swift
//  M.I.L.k
//
//  Created by noah davidson on 12/14/17.
//  Copyright © 2017 noah davidson. All rights reserved.
//

import UIKit

class SignUpController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    let plusPhotoButton : UIButton = {
        let button = UIButton(type: UIButtonType.system)
        button.setImage(#imageLiteral(resourceName: "plus_photo").withRenderingMode(.alwaysOriginal), for: UIControlState.normal)
        button.addTarget(self, action: #selector(handlePlusPhoto), for: .touchUpInside)
        return button
    }()
    
    @objc func handlePlusPhoto(){
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        present(imagePickerController,animated:  true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage{
            plusPhotoButton.setImage( editedImage.withRenderingMode(.alwaysOriginal), for: .normal)
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage{
            plusPhotoButton.setImage(originalImage.withRenderingMode(.alwaysOriginal), for: .normal)
        }
        
        plusPhotoButton.layer.cornerRadius = plusPhotoButton.frame.width/2
        plusPhotoButton.layer.masksToBounds = true
        plusPhotoButton.layer.borderColor = UIColor.black.cgColor
        plusPhotoButton.layer.borderWidth = 3
        
        dismiss(animated: true, completion: nil)
    }
    
    let emailTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Email"
        tf.backgroundColor = UIColor(white:0, alpha:0.03)
        tf.borderStyle = UITextBorderStyle.roundedRect
        tf.font = UIFont.systemFont(ofSize: 14)
        
        tf.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        
        return tf
    }()
    
    let userNameTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Username"
        tf.backgroundColor = UIColor(white:0, alpha:0.03)
        tf.borderStyle = UITextBorderStyle.roundedRect
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        return tf
    }()
    
    let passwordTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "passowrd"
        tf.isSecureTextEntry = true
        tf.backgroundColor = UIColor(white:0, alpha:0.03)
        tf.borderStyle = UITextBorderStyle.roundedRect
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        return tf
    }()
    
    let signUpButton: UIButton = {
        let button = UIButton(type: UIButtonType.system)
        button.setTitle("Sign Up", for: UIControlState.normal)
        button.backgroundColor = UIColor.rgb(red:149,green:204,blue:244)
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(.white, for: .normal)
        
        button.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        
        button.isEnabled = false
        return button
    }()
    
    @objc func handleTextInputChange(){
        let isFormValid = emailTextField.text?.count ?? 0 > 0 && userNameTextField.text?.count ?? 0 > 0 && passwordTextField.text?.count ?? 0 > 0
        if isFormValid{
            signUpButton.isEnabled = true
            signUpButton.backgroundColor = UIColor.rgb(red: 17, green: 154, blue: 237)
        }else{
            signUpButton.isEnabled = false
            signUpButton.backgroundColor = UIColor.rgb(red:149,green:204,blue:244)
        }
    }
    
    @objc func handleSignUp(){
        //NEED TO UPDATE: VALIDATE EMAIL BETTER
        guard let email = emailTextField.text, email.count > 0 else {return}
        //NEED TO UPDATE: CHECK USER NAME FOR VALID AND NOT OFFENSIVE
        guard let username = userNameTextField.text, username.count > 0 else {return}
        //NEED TO UPDATE: VALIDATE STRENGTH OF PASSWORD
        guard let password = passwordTextField.text, password.count > 0 else {return}
        
        guard let image = plusPhotoButton.imageView?.image else {return}
        guard let uploadData = UIImageJPEGRepresentation(image, 0.3) else {return}
        
        let user = User(username: username, password: password, email: email)
        signUpUser(user: user) { (error) in
            if let error = error{
                fatalError(error.localizedDescription)
            }
        }
        
        //NEED TO UPDATE:
        //------------------------------
        //CREATE USER PROFILE IN DB HERE
        //------------------------------
        
        //GET IMAGE URL
        //guard let profileImageUrl = metaData?.downloadURL()?.absoluateString else {return}
        
        //UID IS USERS HASHED ID
        //gaurd let uid = user?iuid else {return}
        
        //GET AND COMPRESSES IMAGE OR STORAGE
        //guard let image = plusPhotoButton.imageView?.image else {return}
        //guard let uploadData = UIImageJPEGRepresentation(image, 0.3) else {return}
        
        //NEED TO UPDATE:
        //------------------------
        //SAVE USERINFO TO DB HERE
        //------------------------
        //DICT OF key:"username" value:user's entered name
        //let dictionaryValues = ["username":username, "profileImageUrl":profileImageUrl]
        
        //DICT OF HASHED ID w/ DICT USERNAME
        //let values = [uid:dictionaryValues]
        
        print("successfully made an account")
        
        //get reference to maintab bar
        guard let mainTabBarController = UIApplication.shared.keyWindow?.rootViewController as? MainTabBarController else {return}
        //reset all views
        mainTabBarController.setupViewController()
        
        self.dismiss(animated: true, completion: nil)
    }
    
    let alreadyHaveAccountButton: UIButton = {
        let button = UIButton(type: UIButtonType.system)
        
        let attributedTitle = NSMutableAttributedString(string: "Already have an account?   ", attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14), NSAttributedStringKey.foregroundColor:UIColor.lightGray])
        
        attributedTitle.append(NSAttributedString(string: "Sign in", attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14), NSAttributedStringKey.foregroundColor: UIColor.rgb(red: 17, green: 154, blue: 237)]))
        
        button.setAttributedTitle(attributedTitle, for: .normal)
        
        button.addTarget(self, action: #selector(handleShowAlreadyHaveAccount), for: .touchUpInside)
        return button
    }()
    
    @objc func handleShowAlreadyHaveAccount(){
        _ = navigationController?.popViewController(animated: true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        view.addSubview(alreadyHaveAccountButton)
        
        alreadyHaveAccountButton.anchor(top: nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 50)
        
        view.addSubview(plusPhotoButton)
        
        plusPhotoButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 40, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 140, height: 140)
        
        plusPhotoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        setUpInputFields()
    }
    
    fileprivate func setUpInputFields(){
        
        let stackView = UIStackView(arrangedSubviews: [emailTextField, userNameTextField, passwordTextField, signUpButton])
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.spacing = 10
        
        view.addSubview(stackView)
        
        stackView.anchor(top: plusPhotoButton.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 20, paddingLeft: 40, paddingBottom: 40, paddingRight: 40, width: 0, height: 200)
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}



