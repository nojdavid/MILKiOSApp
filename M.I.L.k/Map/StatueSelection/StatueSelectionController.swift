//
//  StatueSelectionController.swift
//  M.I.L.k
//
//  Created by noah davidson on 12/20/17.
//  Copyright © 2017 noah davidson. All rights reserved.
//

import Foundation
import UIKit

protocol StatueSelectionControllerDelegate {
    func didSelectCell(statue: Statue)
}

class StatueSelectionController : UICollectionViewController, UICollectionViewDelegateFlowLayout  {

    var delegate: StatueSelectionControllerDelegate?
    
    let cellId = "cellId"
    let headerId = "headerId"
    var statues = [Statue]()

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.backgroundColor = .white
        collectionView?.layer.cornerRadius = 10
        collectionView?.register(StatueSelectionCell.self, forCellWithReuseIdentifier: cellId)
        initializeStatues()
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("touched")
        delegate?.didSelectCell(statue: statues[indexPath.item])
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 40)
    }
    
    fileprivate func initializeStatues(){
        statues = Statue.getStatues()
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return statues.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! StatueSelectionCell
        
        cell.statue = statues[indexPath.item]
        
        return cell
    }
}
