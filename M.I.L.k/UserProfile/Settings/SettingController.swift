//
//  SettingsController
//  M.I.L.k
//
//  Created by Noah Davidson on 6/25/18.
//  Copyright © 2018 noah davidson. All rights reserved.
//
import UIKit

class SettingsController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var user: User?
    
    //remove this once use has image
    var userImage: UIImage?
    
    private let settings: [String] = ["Email", "Username"]
    private var tableView: UITableView!
    
    var tap: UITapGestureRecognizer?
    
    func handleOpenImagePicker() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        present(imagePickerController,animated:  true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        var finalImage: UIImage?
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage{
            userImage = editedImage.withRenderingMode(.alwaysOriginal)
            finalImage = editedImage
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage{
            userImage = originalImage.withRenderingMode(.alwaysOriginal)
            finalImage = originalImage
        }
        
        //if no image then gtfo
        guard let image = finalImage else {return}
        
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        
        UpdateProfileImage(image: image) { (result) in
            switch result {
            case .success(let user):
                print("SUCCESS USER IMAGE: ", user)
                //Todo add upload progress bar
                DispatchQueue.main.async(execute: {
                    //Notify new post has been created
                    NotificationCenter.default.post(name: ShareController.updateFeedNotificationName, object: nil)
                    //cancel to home
                    self.dismiss(animated: true, completion: nil)
                    self.tableView.reloadData()
                })
                break
                
            case .failure(let error):
                print("FAILURE USER IMAGE:", error)
                //renable create if failure occurs
                DispatchQueue.main.async(execute: {
                    self.navigationItem.rightBarButtonItem?.isEnabled = true
                })
                break
            }
        }
        
        //TODO move these inside success
        dismiss(animated: true, completion: nil)
        tableView.reloadData()
    }
    
    func handleCloseImagePicker() {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
        
        let barHeight: CGFloat = UIApplication.shared.statusBarFrame.size.height
        let displayWidth: CGFloat = self.view.frame.width
        let displayHeight: CGFloat = self.view.frame.height
        
        tableView = UITableView(frame: CGRect(x: 0, y: barHeight, width: displayWidth, height: displayHeight - barHeight), style: .grouped)

        tableView.register(SettingsCell.self, forCellReuseIdentifier: SettingsCell.reuseIdentifer)
        tableView.register(SettingsHeader.self, forHeaderFooterViewReuseIdentifier: SettingsHeader.reuseIdentifer)
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        tableView.backgroundColor = UIColor.white
        
        self.view.addSubview(tableView)
        
        navigationItem.leftBarButtonItem = closeButton
        navigationItem.rightBarButtonItem = doneButton
        
        tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap?.cancelsTouchesInView = false
        view.addGestureRecognizer(tap!)
        
        self.view.addSubview(tableView)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: SettingsHeader.reuseIdentifer) as? SettingsHeader else {
            return nil
        }
        
        header.customLabel.text = "Change your picture"
        header.userImage = userImage
        header.delegate = self
        return header
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 150.0
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print("Num: \(indexPath.row)")
//        print("Value: \(settings[indexPath.row])")
//    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SettingsCell.reuseIdentifer) as? SettingsCell
        let setting = settings[indexPath.row]
        cell?.cellSetting = setting
        cell?.selectionStyle = UITableViewCellSelectionStyle.none
        
        switch(setting) {
            case "Email":
                cell?.textField.text = user?.email
            case "Username":
                cell?.textField.text = user?.username
            default:
                cell?.textField.text = ""
        }
        
        return cell!
    }
    
    lazy var closeButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleClose))
        button.setTitleTextAttributes([NSAttributedStringKey.font: navigationButtonFont ], for: .normal)
        button.tintColor = UIColor.black
        return button
    }()
    
    @objc func handleClose(){
        self.navigationController?.dismiss(animated: true, completion:nil)
    }
    
    lazy var doneButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(handleDone))
        button.setTitleTextAttributes([NSAttributedStringKey.font: navigationButtonFont ], for: .normal)
        button.tintColor = UIColor.black
        return button
    }()
    
    @objc func handleDone(){
        var email: String?
        var username: String?
        let cells = self.tableView.visibleCells as! Array<SettingsCell>
        
        //get all setting sinfo from the cells
        for cell in cells {
            guard let setting = cell.cellSetting else {continue}
            guard let text = cell.textField.text else {continue}
            switch(setting) {
                case "Email":
                    email = text
                    break
                case "Username":
                    username = text
                    break
                default:
                    break
            }
        }
        //check values arent nil
        if email == nil || user == nil {return}
        
        //save if different from user info
        if (self.user?.email != email && self.user?.username != username) {
            let settings = Settings(email: email!, username: username!)
            
            UpdateUserSettings(settings: settings) { (result) in
                switch result {
                case .success(let user):
                    print("SUCCESS SETTINGS", user)
                    Store.shared().user = user
//                  self.navigationController?.dismiss(animated: true, completion:nil)
                    break
                case .failure(let error) :
                    print("SETTINGS ERROR", error)
                    break
                }
            }
        }
        
        self.navigationController?.dismiss(animated: true, completion:nil)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension SettingsController : SettingsHeaderDelegate {
    func openImagePicker() {
       handleOpenImagePicker()
    }
    
    func closeImagePicker() {
        handleCloseImagePicker()
    }
}
