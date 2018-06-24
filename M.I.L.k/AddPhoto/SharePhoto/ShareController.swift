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
        print(navigationTitleFont)
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
        
        //GET USER ID AUTHENTICATION ID
        
        guard let image = selectedImage else {return}
        let imageSize = CGSize(width: image.size.width, height: image.size.height)
        //image to upload
        let creationDate = Date().timeIntervalSince1970 as Any
        guard let uploadData = UIImagePNGRepresentation(image) else {return}
        
        //this is randomly generated filename for image
        let filename = NSUUID().uuidString
        
        //TODO: GET CAPTION
        //UNCOMMENTING THIS BREAKS SHARE FUNCTION AND CRASHES APP
        //GET TEXT ANOTHER WAY
        //guard let caption = (self.tableView.tableHeaderView as! CustomTableViewHeader).textView.text else {return}
        
        //NEED TO DO: RENABLE THIS IF ERROR OCCURS IN UPLOAD
        navigationItem.rightBarButtonItem?.isEnabled = false
        
        uploadImage(data: uploadData, filename: filename)
        //NEED TO DO: UPLOAD IMAGE DATA TO DATA BASE
        //UPLOAD IMAGE, COMMENT STRING, Date Posted, & UPLOAD USER ID WITH IMAGE
        
        self.dismiss(animated: true, completion: nil)
        
        NotificationCenter.default.post(name: ShareController.updateFeedNotificationName, object: nil)
    }
    
    func uploadImage(data: Data, filename: String) {
        let expression = AWSS3TransferUtilityUploadExpression()
        expression.progressBlock = {(task, progress) in
            DispatchQueue.main.async(execute: {
                // Do something e.g. Update a progress bar.
                print("progress: \(progress)")
            })
        }
        
        var completionHandler: AWSS3TransferUtilityUploadCompletionHandlerBlock?
        completionHandler = { (task, error) -> Void in
            DispatchQueue.main.async(execute: {
                // Do something e.g. Alert a user for transfer completion.
                // On failed uploads, `error` contains the error object.
                //print("Error: \(String(describing: error))")
            })
        }
        
        let transferUtility = AWSS3TransferUtility.default()
        
        transferUtility.uploadData(data,
                                   bucket: S3BucketName,
                                   key: "uploads/"+filename+".png",
                                   contentType: "image/png",
                                   expression: expression,
                                   completionHandler: completionHandler).continueWith {
                                    (task) -> AnyObject! in
                                    if let error = task.error {
                                        print("Error: \(error.localizedDescription)")
                                    }
                                    
                                    if let _ = task.result {
                                        print("Upload Started!")
                                    }
                                    
                                    print("TASK: ", task)
                                    return nil;
        }
    }
    
    override var prefersStatusBarHidden: Bool{
        return true
    }
}

//
// MARK :- HEADER
//
class CustomTableViewHeader: UITableViewHeaderFooterView {
    
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
