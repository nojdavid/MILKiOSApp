//
//  ShareController.swift
//  M.I.L.k
//
//  Created by noah davidson on 12/30/17.
//  Copyright © 2017 noah davidson. All rights reserved.
//

import UIKit
//
// MARK :- TableViewController
//
class ShareController: UITableViewController {
    
    public var navigationTitleFont = UIFont(name: "AvenirNext-DemiBold", size: 15)
    var selectedImage: UIImage?{
        didSet{
            tableView.reloadData()
        }
    }
    
    private let headerId = "headerId"
    private let cellId = "cellId"
    
    //
    // MARK: BUTTONS
    //
    
    lazy var shareButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "SHARE", style: .plain, target: self, action: #selector(handleShare))
        button.setTitleTextAttributes([NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14) ], for: .normal)
        button.tintColor = UIColor.white
        return button
    }()
    
    lazy var backButton:UIBarButtonItem = {
        let button = UIBarButtonItem(image: #imageLiteral(resourceName: "back_arrow"), style: .plain, target: self, action: #selector(handleDismiss))
        button.tintColor = UIColor.white
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
        
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: headerId) as! CustomTableViewHeader
        
        header.selectedImage = self.selectedImage
        return header
    }
    
    //
    // MARK :- CELL
    //
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print(indexPath.item)
        if indexPath.item == 0 {
            let locationController = UIViewController()
            let navController = UINavigationController(rootViewController: locationController)
            present(navController, animated: true, completion: nil)
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 75
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! CustomTableCell
        cell.selectionStyle = .none
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "NEW POST"
        navigationController?.navigationBar.titleTextAttributes = [ NSAttributedStringKey.font: fusumaTitleFont ?? UIFont.systemFont(ofSize: 15)]
        navigationItem.rightBarButtonItem = shareButton
        navigationItem.leftBarButtonItem = backButton
        
        setupTableView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func setupTableView() {
        tableView.backgroundColor = .white
        tableView.register(CustomTableViewHeader.self, forHeaderFooterViewReuseIdentifier: headerId)
        tableView.register(CustomTableCell.self, forCellReuseIdentifier: cellId)
        
        let view = UIView()
        view.backgroundColor = .white
        self.tableView.tableFooterView = view
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
        
        //TODO: GET CAPTION
        //UNCOMMENTING THIS BREAKS SHARE FUNCTION AND CRASHES APP
        //GET TEXT ANOTHER WAY
        //guard let caption = (self.tableView.tableHeaderView as! CustomTableViewHeader).textView.text else {return}
        
        //NEED TO DO: RENABLE THIS IF ERROR OCCURS IN UPLOAD
        navigationItem.rightBarButtonItem?.isEnabled = false
        
        //NEED TO DO: UPLOAD IMAGE DATA TO DATA BASE
        //UPLOAD IMAGE, COMMENT STRING, Date Posted, & UPLOAD USER ID WITH IMAGE
        
        self.dismiss(animated: true, completion: nil)
        
        NotificationCenter.default.post(name: ShareController.updateFeedNotificationName, object: nil)
    }
    
    override var prefersStatusBarHidden: Bool{
        return true
    }
}

//
// MARK :- HEADER
//
class CustomTableViewHeader: UITableViewHeaderFooterView {
    
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
    
    public var textView: UITextView = {
        let tv = UITextView()
        tv.font = UIFont.systemFont(ofSize: 14)
        return tv
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = .white
        
        addSubview(imageView)
        imageView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: nil, paddingTop: 8, paddingLeft: 8, paddingBottom: 8, paddingRight: 0, width: 84, height: 0)
        
        addSubview(textView)
        textView.anchor(top: topAnchor, left: imageView.rightAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 8, paddingLeft: 4, paddingBottom: 8, paddingRight: 0, width: 0, height: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//
// MARK :- CELL
//
class CustomTableCell: UITableViewCell {
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        textLabel?.text = "Statue Location"
        
        textLabel?.textAlignment = .left
        accessoryType = .disclosureIndicator
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
