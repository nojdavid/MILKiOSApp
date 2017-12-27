//
//  SharePhotoController.swift
//  M.I.L.k
//
//  Created by noah davidson on 12/16/17.
//  Copyright © 2017 noah davidson. All rights reserved.
//

import UIKit

class SharePhotoController : UIViewController{
    
    var selectedImage: UIImage?{
        didSet {
            self.imageView.image = selectedImage
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.rgb(red: 240, green: 240, blue: 240)
        
        navigationItem.title = "New Post"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Share", style: .plain, target: self, action: #selector(handleShare))
        
        setupImageAndTextViews()
    }
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    let textView: UITextView = {
        let tv = UITextView()
        tv.font = UIFont.systemFont(ofSize: 14)
        return tv
    }()
    
    fileprivate func setupImageAndTextViews(){
       
        let containerView = UIView()
        containerView.backgroundColor = .white
        
        view.addSubview(containerView)
        
        
        containerView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 100)
        
        containerView.addSubview(imageView)
        imageView.anchor(top: containerView.topAnchor, left: containerView.leftAnchor, bottom: containerView.bottomAnchor, right: nil, paddingTop: 8, paddingLeft: 8, paddingBottom: 8, paddingRight: 0, width: 84, height: 0)
        
        containerView.addSubview(textView)
        textView.anchor(top: containerView.topAnchor, left: imageView.rightAnchor, bottom: containerView.bottomAnchor, right: containerView.rightAnchor, paddingTop: 0, paddingLeft: 4, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    }
    
    static let updateFeedNotificationName = NSNotification.Name(rawValue: "UpdateFeed")
    
    @objc func handleShare(){
        
        //GET USER ID AUTHENTICATION ID
        
        guard let image = selectedImage else {return}
        let imageSize = CGSize(width: image.size.width, height: image.size.height)
        //image to upload
        let creationDate = Date().timeIntervalSince1970 as Any
        guard let uploadData = UIImageJPEGRepresentation(image, 0.3) else {return}
        
        //this is randomly generated filename for image
        let filename = NSUUID().uuidString
        
        guard let caption = textView.text else {return}
        
        //NEED TO DO: RENABLE THIS IF ERROR OCCURS IN UPLOAD
        navigationItem.rightBarButtonItem?.isEnabled = false
        
        //NEED TO DO: UPLOAD IMAGE DATA TO DATA BASE
        //UPLOAD IMAGE, COMMENT STRING, Date Posted, & UPLOAD USER ID WITH IMAGE
        
        self.dismiss(animated: true, completion: nil)
        
        NotificationCenter.default.post(name: SharePhotoController.updateFeedNotificationName, object: nil)
    }
    
    override var prefersStatusBarHidden: Bool{
        return true
    }
}
