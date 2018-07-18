//
//  ShareController.swift
//  M.I.L.k
//
//  Created by noah davidson on 12/30/17.
//  Copyright © 2017 noah davidson. All rights reserved.
//

import UIKit
import AWSCore
import AWSS3

//
// MARK :- TableViewController
//
class ShareController: UITableViewController {
    
    var selectedImage: UIImage?{
        didSet{
            tableView.reloadData()
        }
    }
    
    //
    // MARK: BUTTONS
    //
    
    lazy var shareButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "Share", style: .plain, target: self, action: #selector(handleShare))
        button.setTitleTextAttributes([NSAttributedStringKey.font: navigationButtonFont ], for: .normal)
        button.tintColor = UIColor.mainBlue()
        return button
    }()
    
    lazy var backButton:UIBarButtonItem = {
        let button = UIBarButtonItem(image: #imageLiteral(resourceName: "back_arrow"), style: .plain, target: self, action: #selector(handleDismiss))
        button.tintColor = UIColor.black
        return button
    }()
    
    @objc func handleDismiss(){
        navigationController?.popViewController(animated: true)
    }
    
    //
    // MARK :- HEADER
    //
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 100
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: CustomTableViewHeader.identifier) as! CustomTableViewHeader
        
        header.selectedImage = self.selectedImage
        return header
    }
    
    //
    // MARK :- CELL
    //
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.item == 0 {
            if tableView.cellForRow(at: indexPath)?.selectionStyle != UITableViewCellSelectionStyle.none {
                let statueController = ShareStatue()
                statueController.delegate = tableView.cellForRow(at: indexPath) as! CustomTableCell
                let navController = UINavigationController(rootViewController: statueController)
                present(navController, animated: true, completion: nil)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: CustomTableCell.identifier, for: indexPath) as! CustomTableCell
        cell.selectionStyle = .default
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "New Post"
        //navigationController?.navigationBar.titleTextAttributes = [ NSAttributedStringKey.font: navigationTitleFont ?? UIFont.systemFont(ofSize: 20)]
        navigationItem.rightBarButtonItem = shareButton
        navigationItem.leftBarButtonItem = backButton
        
        setupTableView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func setupTableView() {
        tableView.backgroundColor = .white
        tableView.register(CustomTableViewHeader.self, forHeaderFooterViewReuseIdentifier: CustomTableViewHeader.identifier)
        tableView.register(CustomTableCell.self, forCellReuseIdentifier: CustomTableCell.identifier)
        
        tableView.separatorStyle = .none
        
        let view = UIView()
        view.backgroundColor = .white
        self.tableView.tableFooterView = view
    }
    
    static let updateFeedNotificationName = NSNotification.Name(rawValue: "UpdateFeed")
    
    @objc func handleShare(){
        guard let image = selectedImage else {return}

        guard let header = tableView.headerView(forSection: 0) as! CustomTableViewHeader? else {return}
        guard let caption = header.textView.text else {return }
        
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        
        createPost(image: image, caption: caption) { (result) in
            switch result {
            case .success(let post):
                print("SUCCESS POST: ", post)
                //Todo add upload progress bar
                DispatchQueue.main.async(execute: {
                    //Notify new post has been created
                    NotificationCenter.default.post(name: ShareController.updateFeedNotificationName, object: nil)
                    //cancel to home
                    self.dismiss(animated: true, completion: nil)
                })
                break
                
            case .failure(let error):
                print("FAILURE POST:", error)
                //Todo, need more advanced error handling
                
                //renable create if failure occurs
                DispatchQueue.main.async(execute: {
                    self.navigationItem.rightBarButtonItem?.isEnabled = true
                })
                break
            }
        }
        
    }
    
    override var prefersStatusBarHidden: Bool{
        return true
    }
}

//
// MARK :- HEADER
//
class CustomTableViewHeader: UITableViewHeaderFooterView, UITextViewDelegate {
    
    static var identifier  = "headerId"
    
    var selectedImage: UIImage?{
        didSet {
            self.imageView.image = selectedImage
        }
    }
    
    public var imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    var placeholderLabel: UILabel = {
        let holder = UILabel()
        holder.text = "Write a caption here..."
        holder.font = UIFont.systemFont(ofSize: 14)
        holder.sizeToFit()
        holder.textColor = UIColor.lightGray
        return holder
    }()
    
    var textView: UITextView = {
        let tv = UITextView()
        tv.font = UIFont.systemFont(ofSize: 14)
        return tv
    }()
    
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty
    }
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = .white

        addSubview(imageView)
        imageView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: nil, paddingTop: 8, paddingLeft: 8, paddingBottom: 8, paddingRight: 0, width: 84, height: 0)
    
        addSubview(textView)
        textView.delegate = self
        textView.anchor(top: topAnchor, left: imageView.rightAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 8, paddingLeft: 4, paddingBottom: 8, paddingRight: 0, width: 0, height: 0)
        
        textView.addSubview(placeholderLabel)
        placeholderLabel.frame.origin = CGPoint(x: 5, y: (textView.font?.pointSize)! / 2)
        placeholderLabel.isHidden = !textView.text.isEmpty
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//
// MARK :- CELL
//
class CustomTableCell: UITableViewCell, ShareStatueDelegate {
    
    lazy var removeStatueButton : UIButton = {
        let button = UIButton(type: UIButtonType.system)
        button.setImage(#imageLiteral(resourceName: "ic_close"), for: .normal)
        button.tintColor = UIColor.gray
        button.addTarget(self, action: #selector(removeStatue), for: .touchUpInside)
        return button
    }()
    
    @objc func removeStatue(){
        removeStatueButton.removeFromSuperview()
        
        accessoryType = .disclosureIndicator
        selectionStyle = .default
        textLabel?.text = "Add Statue Location"
    }
    
    func selectStatueCell(StatueName: String) {

        textLabel?.text = StatueName
        accessoryType = .none
        selectionStyle = .none
        
        self.addSubview(removeStatueButton)
        removeStatueButton.anchor(top: topAnchor, left: nil, bottom: bottomAnchor, right: rightAnchor, paddingTop: 30, paddingLeft: 0, paddingBottom: 30, paddingRight: 10, width: 20, height: 20)
    }
    
    
    static var identifier = "cellId"
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        textLabel?.text = "Add Statue Location"
        
        textLabel?.textAlignment = .left
        accessoryType = .disclosureIndicator
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
