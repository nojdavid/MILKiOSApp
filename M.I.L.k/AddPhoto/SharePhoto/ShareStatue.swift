
//
//  ShareStatue.swift
//  M.I.L.k
//
//  Created by noah davidson on 1/15/18.
//  Copyright © 2018 noah davidson. All rights reserved.
//

import Foundation
import UIKit

protocol ShareStatueDelegate {
    func selectStatueCell(StatueName: String)
}

class ShareStatue : UITableViewController {
    
    var delegate: ShareStatueDelegate?
    
    public var navigationTitleFont = UIFont(name: "AvenirNext-DemiBold", size: 15)
    
    lazy var cancelButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        button.setTitleTextAttributes([NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14) ], for: .normal)
        button.tintColor = UIColor.black
        return button
    }()
    
    @objc func handleCancel(){
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    var items = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Statues"
        navigationController?.navigationBar.titleTextAttributes = [ NSAttributedStringKey.font: fusumaTitleFont ?? UIFont.systemFont(ofSize: 15)]
        
        
        items = Statue.StatueNames
        
        navigationItem.rightBarButtonItem = cancelButton
        
        tableView.register(StatueCell.self, forCellReuseIdentifier: StatueCell.identifier)
    }
    
    override var prefersStatusBarHidden: Bool{
        return true
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: StatueCell.identifier) as! StatueCell
        cell.textLabel?.text = items[indexPath.item]
        cell.selectionStyle = .none
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let statueName = tableView.cellForRow(at: indexPath)?.textLabel?.text else {return}
        delegate?.selectStatueCell(StatueName: statueName)
        navigationController?.dismiss(animated: true, completion: nil)
    }
}


class StatueCell : UITableViewCell {

    static var identifier = "StatueCell"
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
