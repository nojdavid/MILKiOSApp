//
//  SharePhotoView.swift
//  M.I.L.k
//
//  Created by noah davidson on 12/29/17.
//  Copyright © 2017 noah davidson. All rights reserved.
//

import Foundation
import UIKit

class SharePhotoView : UIView{
    
    @IBOutlet weak var previewViewContainer: UIView!
    @IBOutlet weak var selectedImage: UIImageView!
    @IBOutlet weak var textView: UITextView!
    
    @objc static func instance() -> SharePhotoView {
        
        return UINib(nibName: "SharePhotoView", bundle: Bundle(for: self.classForCoder())).instantiate(withOwner: self, options: nil)[0] as! SharePhotoView
    }
    
    @objc func initialize() {
        
    }
}
