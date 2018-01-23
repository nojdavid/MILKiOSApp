
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

    lazy var cancelButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        button.setTitleTextAttributes([NSAttributedStringKey.font: navigationButtonFont ], for: .normal)
        button.tintColor = UIColor.black
        return button
    }()
    
    @objc func handleCancel(){
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    var items = [Statue]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Statues"
        //navigationController?.navigationBar.titleTextAttributes = [ NSAttributedStringKey.font: navigationTitleFont ?? UIFont.systemFont(ofSize: 20)]

        items = AppDelegate.Statues
        navigationItem.rightBarButtonItem = cancelButton
        
        tableView.register(StatueSelectionCell.self, forCellReuseIdentifier: StatueSelectionCell.identifier)
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
        let cell = tableView.dequeueReusableCell(withIdentifier: StatueSelectionCell.identifier, for: indexPath) as! StatueSelectionCell
        
        cell.statue = items[indexPath.item]

        cell.statueLabel.text = items[indexPath.item].title
        
        guard let placeMark = (cell.statue?.placeMark) else {return cell}
        cell.locationLabel.text = Statue.parseAddress(selectedItem: placeMark)
        
        cell.selectionStyle = .none
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let statueName = (tableView.cellForRow(at: indexPath) as! StatueSelectionCell).statueLabel.text else {return}
        delegate?.selectStatueCell(StatueName: statueName)
        navigationController?.dismiss(animated: true, completion: nil)
    }
}

/*
class StatueCell : UITableViewCell {

    static var identifier = "StatueCell"
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
*/
