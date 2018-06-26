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
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage{
            userImage = editedImage.withRenderingMode(.alwaysOriginal)
            //plusPhotoButton.setImage( editedImage.withRenderingMode(.alwaysOriginal), for: .normal)
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage{
            userImage = originalImage.withRenderingMode(.alwaysOriginal)
            //plusPhotoButton.setImage(originalImage.withRenderingMode(.alwaysOriginal), for: .normal)
        }
        
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
        //let cell = tableView.dequeueReusableCell(withIdentifier: SettingsCell.reuseIdentifer, for: indexPath as IndexPath)
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
        self.navigationController?.dismiss(animated: true, completion:nil)
    }
    
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//
//        if emailTextField.isFirstResponder {
//            userNameTextField.becomeFirstResponder()
//            return false
//        }else {
//            view.endEditing(true)
//            return true
//        }
//    }
    
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
