//
//  DetailedImageViewController.swift
//  M.I.L.k
//
//  Created by noah davidson on 12/13/17.
//  Copyright © 2017 noah davidson. All rights reserved.
//

import UIKit

class DetailedImageViewController : UIViewController{
    
    var imageToPresent: UIImage!
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = imageToPresent
    }

}
