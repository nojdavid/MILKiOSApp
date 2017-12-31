//
//  ShareDetialsController.swift
//  M.I.L.k
//
//  Created by noah davidson on 12/30/17.
//  Copyright © 2017 noah davidson. All rights reserved.
//

import UIKit

class ShareDetailsController : UICollectionViewController {
    
    let statuesCell = "StatuesCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.backgroundColor = .yellow
        
        collectionView?.register(UICollectionViewCell.self, forCellWithReuseIdentifier: statuesCell)
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: statuesCell, for: indexPath)
        return cell
    }
    
}
