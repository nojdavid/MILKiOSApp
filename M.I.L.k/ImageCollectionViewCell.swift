//
//  ImageCollectionViewCell.swift
//  M.I.L.k
//
//  Created by noah davidson on 12/13/17.
//  Copyright © 2017 noah davidson. All rights reserved.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
}
