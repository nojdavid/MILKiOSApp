//
//  CommentBoardViewController.swift
//  M.I.L.k
//
//  Created by noah davidson on 12/14/17.
//  Copyright © 2017 noah davidson. All rights reserved.
//

import UIKit

class CommentBoardViewController : UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    var messages: [Message]? {
        didSet {
            //messages = messages?.sorted(by: {$0.date!.compare($1.date!) == .orderedAscending})
        }
    }
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Comment"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = messages?.count{
            return count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? MessageBoardCell
        
        if cell == nil{
            cell = MessageBoardCell()
        }
        
        if let newMessage = messages?[indexPath.item]{
            cell?.textLabel?.text = newMessage.userName
            cell?.detailTextLabel?.text = newMessage.message
            cell?.imageView?.image = newMessage.userProfileImage
            //cell.message?.date = newMessage?.date
        }
        
        return cell!
    }
    
}
