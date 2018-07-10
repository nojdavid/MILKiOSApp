//
//  CommentsController.swift
//  M.I.L.k
//
//  Created by noah davidson on 12/18/17.
//  Copyright © 2017 noah davidson. All rights reserved.
//

import UIKit

class CommentsController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var comments = [Comment]()
    var post: Post? {
        didSet {
            //Todo change this once GET comments is patched in !!!!!!!!
            comments = (post?.comments)!
        }
    }
    
    let cellId = "cellId"
    var user: User?
    
    lazy var backButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: #imageLiteral(resourceName: "back_arrow").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleDismiss))
        return button
    }()
    
    @objc func handleDismiss(){
        navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Comments"
        navigationItem.leftBarButtonItem = backButton
        
        collectionView?.backgroundColor = .white
        collectionView?.alwaysBounceVertical = true
        collectionView?.keyboardDismissMode = .interactive

        collectionView?.register(CommentCell.self, forCellWithReuseIdentifier: cellId)

        //TODO::REMOVE THIS ONCE YOU GET USER THE RIGHT WAY
        user = getUserFromDisk()
        
        fetchComments()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        commentTextField.becomeFirstResponder()
        scrollToBottomAnimated(animated: true)
    }

    @objc func handleBack(){
        navigationController?.popViewController(animated: true)
    }
    
    
    fileprivate func fetchComments(){
        //TODO: FETCH ALL COMMENTS FOR THIS POST
        
        self.collectionView?.reloadData()
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return comments.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
        let dummyCell = CommentCell(frame: frame)
        dummyCell.comment = comments[indexPath.item]
        dummyCell.layoutIfNeeded()
        
        let targetSize = CGSize(width: view.frame.width, height: 1000)
        let estimatedSize = dummyCell.systemLayoutSizeFitting(targetSize)
        
        let height = max(40 + 8 + 8, estimatedSize.height)
        return CGSize(width: view.frame.width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! CommentCell
        
        cell.comment = self.comments[indexPath.item]
        
        return cell
    }
    
    
    lazy var containerView: UIView = {
        let containerView = UIView()
        containerView.backgroundColor = .white
        containerView.frame = CGRect(x: 0, y: 0, width: 100, height: 50)
        
        containerView.addSubview(submitButton)
        submitButton.anchor(top: containerView.topAnchor, left: nil, bottom: containerView.bottomAnchor, right: containerView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 12, width: 50, height: 0)
        
        containerView.addSubview(commentTextField)
        commentTextField.anchor(top: containerView.topAnchor, left: containerView.leftAnchor, bottom: containerView.bottomAnchor, right: submitButton.leftAnchor, paddingTop: 0, paddingLeft: 12, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        let lineSeparatorView = UIView()
        lineSeparatorView.backgroundColor = UIColor.rgb(red: 230, green: 230, blue: 230)
        containerView.addSubview(lineSeparatorView)
        lineSeparatorView.anchor(top: containerView.topAnchor, left: containerView.leftAnchor, bottom: nil, right: containerView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0.5)
        
        return containerView
    }()
    
    let submitButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Send", for: .normal)
        button.setTitleColor(UIColor.unselectedGrey(), for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
        button.isEnabled = false
        return button
    }()
    
    let commentTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter Comment"
        textField.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        return textField
    }()
    
    @objc func handleTextInputChange(){
        let isFormValid = !((commentTextField.text?.trimmingCharacters(in: .whitespaces).isEmpty)!)
        if isFormValid{
            submitButton.isEnabled = true
            submitButton.setTitleColor(.black, for: .normal)
        }else if !isFormValid || isFormValid == nil {
            submitButton.isEnabled = false
            submitButton.setTitleColor(UIColor.unselectedGrey(), for: .normal)
        }
    }
    
    func emptyContainerView(){
        commentTextField.text = ""
        submitButton.isEnabled = false
        submitButton.setTitleColor(UIColor.unselectedGrey(), for: .normal)
    }
    
    @objc func handleSend() {
        
        guard let post_id = self.post?.id else {
            print("--failed to fetch user name in comments")
            return
        }
        
        let values = ["text": commentTextField.text] as [String:Any]

        emptyContainerView()
        
        //REMOVE THIS GET USER AND PROPEGATE USERS THROUGH NAV CONTROLLER
        let comment = Comment(dictionary: values)

        sendCommentToDB(post_id: post_id,comment: comment) { (result) in
            switch result {
            case .success(let comment):
                print("SUCCESS COMMENT: ", comment)
                //reload comments when comment is returned
                //can take out optionally
                //self.collectionView?.reloadData()
                
                return
            case .failure(let error):
                print("FAILURE POSTS:", error)
                return
            }
        }
        
        //Add comment in real time
        comments.append(comment)
        self.collectionView?.reloadData()
        
        scrollToBottomAnimated(animated: true)
    }
    
    override var inputAccessoryView: UIView? {
        get {
            return containerView
        }
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    func scrollToBottomAnimated(animated: Bool) {
        guard (self.collectionView?.numberOfSections)! > 0 else{
            return
        }
        
        let items = self.collectionView?.numberOfItems(inSection: 0)
        if items == 0 { return }
        
        let collectionViewContentHeight = self.collectionView?.collectionViewLayout.collectionViewContentSize.height
        let isContentTooSmall: Bool = (collectionViewContentHeight! < self.collectionView!.bounds.size.height)
        
        if isContentTooSmall {
            self.collectionView?.scrollRectToVisible(CGRect(x: 0, y: collectionViewContentHeight! - 1, width: 1, height: 1), animated: animated)
            return
        }
        
        self.collectionView?.scrollToItem(at: NSIndexPath(item: items! - 1, section: 0) as IndexPath, at: .bottom, animated: animated)
        
    }
}
