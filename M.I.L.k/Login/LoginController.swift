//
//  LoginController.swift
//  M.I.L.k
//
//  Created by noah davidson on 12/15/17.
//  Copyright © 2017 noah davidson. All rights reserved.
//

import UIKit

class LoginController : UIViewController, UITextFieldDelegate{
    
    let logoContainerView: UIView = {
        let view = UIView()
        
        let logoImageView = UIImageView(image: #imageLiteral(resourceName: "Instagram_logo_white"))
        logoImageView.contentMode = .scaleAspectFill
        view.addSubview(logoImageView)
        logoImageView.anchor(top: nil, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 200, height: 50)
        logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true;
        logoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true;
        
        view.backgroundColor = UIColor.rgb(red: 0, green: 120, blue: 175)
        return view
    }()
    
    let emailTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Email"
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
    
    @objc func handleTextInputChange(){
        let isFormValid = emailTextField.text?.count ?? 0 > 0  && passwordTextField.text?.count ?? 0 > 0
        if isFormValid{
            loginButton.isEnabled = true
            loginButton.backgroundColor = UIColor.rgb(red: 17, green: 154, blue: 237)
        }else{
            loginButton.isEnabled = false
            loginButton.backgroundColor = UIColor.rgb(red:149,green:204,blue:244)
        }
    }
    
    let userErrorLabel: UILabel = {
        let label = UILabel()
        let attributedTitle = NSMutableAttributedString(string: "", attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 12), NSAttributedStringKey.foregroundColor: UIColor.red])
        label.attributedText = attributedTitle
        label.isEnabled = false
        label.numberOfLines = 0
        label.textAlignment = NSTextAlignment.center
        return label
    }()
    
    func estimatedHeightOfLabel(text: String) -> CGFloat {
        let size = CGSize(width: view.frame.width - 80, height: 1000)

        let attributes = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 12)]
        
        let rectangleHeight = String(text).boundingRect(with: size, options: [], attributes: attributes, context: nil).height
        
        return ceil(rectangleHeight)
    }
    
    let loginButton: UIButton = {
        let button = UIButton(type: UIButtonType.system)
        button.setTitle("Login", for: UIControlState.normal)
        button.backgroundColor = UIColor.rgb(red:149,green:204,blue:244)
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(.white, for: .normal)
        
        button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        
        button.isEnabled = false
        return button
    }()
    
    @objc func handleLogin(){
        guard let email = emailTextField.text else {return}
        guard let password = passwordTextField.text else {return}

        loginUserToDB(user: LoginUser(email: email, password: password)) { (result) in
            switch result {
                case .success(let user):
                    
                    //save user to disk
                    saveUserToDisk(user: user)

                    //get reference to maintab bar
                    guard let mainTabBarController = UIApplication.shared.keyWindow?.rootViewController as? MainTabBarController else {return}
                    //reset all views
                    mainTabBarController.setupViewController(user: user)
                    
                    self.dismiss(animated: true, completion: nil)
                
                case .failure(let error):
                    print("LOG IN FAILURE", error)
                    print("error: \(error.localizedDescription)")
                    
                    let message = error.localizedDescription
                    
                    if self.userErrorLabel.isDescendant(of: self.stackView!) == true {
                        self.stackView?.removeFromSuperview()
                    }

                    let attributedTitle = NSMutableAttributedString(string: message, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 12), NSAttributedStringKey.foregroundColor: UIColor.red])
                    self.userErrorLabel.attributedText = attributedTitle

                    self.present(customUserError(title: "Login Failed", message: message), animated: true, completion: nil)
                    
                    return
            }
        }
    }
    
    let dontHaveAccountButton: UIButton = {
        let button = UIButton(type: UIButtonType.system)
        
        let attributedTitle = NSMutableAttributedString(string: "Dont't have an account?   ", attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14), NSAttributedStringKey.foregroundColor:UIColor.lightGray])
        
        attributedTitle.append(NSAttributedString(string: "Sign Up", attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14), NSAttributedStringKey.foregroundColor: UIColor.rgb(red: 17, green: 154, blue: 237)]))
        
        button.setAttributedTitle(attributedTitle, for: .normal)
        
        button.addTarget(self, action: #selector(handleShowSignUp), for: .touchUpInside)
        return button
    }()
    
    @objc func handleShowSignUp(){
        let signUpController = SignUpController()
        navigationController?.pushViewController(signUpController, animated: true)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    var tap: UITapGestureRecognizer?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(logoContainerView)
        logoContainerView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 150)
        
        navigationController?.isNavigationBarHidden = true
        view.backgroundColor = .white
        
        view.addSubview(dontHaveAccountButton)
        dontHaveAccountButton.anchor(top: nil, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 50)
        
        setupInputFields()
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap?.cancelsTouchesInView = false
        view.addGestureRecognizer(tap!)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if emailTextField.isFirstResponder {
            passwordTextField.becomeFirstResponder()
            return false
        }else {
            view.endEditing(true)
            return true
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        view.removeGestureRecognizer(tap!)
    }
    
    var stackView: UIStackView?
    var stackHeight: CGFloat = 140
    var heightConstraint: NSLayoutConstraint?
    
    func updateStackViewHeight(height: CGFloat?){
        self.stackView?.removeConstraint(self.heightConstraint!)
        if height == nil {
            self.heightConstraint = self.stackView?.heightAnchor.constraint(equalToConstant: stackHeight)
        }else{
            self.heightConstraint = self.stackView?.heightAnchor.constraint(equalToConstant: stackHeight + height!)
        }
        self.stackView?.addConstraints([self.heightConstraint!])
        self.stackView?.setNeedsLayout()
    }
    
    fileprivate func setupInputFields(){
        
        stackView = UIStackView(arrangedSubviews: [emailTextField, passwordTextField, loginButton])
        
        stackView?.axis = .vertical
        stackView?.spacing = 10
        stackView?.distribution = .fillEqually
        
        view.addSubview(stackView!)
        stackView?.translatesAutoresizingMaskIntoConstraints = false
        heightConstraint = stackView?.heightAnchor.constraint(equalToConstant: stackHeight)
        stackView?.addConstraints([heightConstraint!])
        stackView?.anchor(top: logoContainerView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 40, paddingLeft: 40, paddingBottom: 0, paddingRight: 40, width: 0, height: 0)
        
    }
}
