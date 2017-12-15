//
//  DetailedImageViewController.swift
//  M.I.L.k
//
//  Created by noah davidson on 12/13/17.
//  Copyright © 2017 noah davidson. All rights reserved.
//

import UIKit
class SelectedItem{
    var image: UIImage?
    var messages: [Message]?
    
    init(messages:[Message], image:UIImage){
        self.image = image
        self.messages = messages
    }
}

class DetailedImageViewController : UIViewController{
    
    //var imageToPresent: UIImage!
    @IBOutlet weak var imageView: UIImageView!
    
    var selectedItem : SelectedItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = selectedItem?.image
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "openCommentBoard" {
            let commentVC = segue.destination as! CommentBoardViewController
            commentVC.messages = selectedItem?.messages
        }
    }

}
