//
//  HomeViewController.swift
//  M.I.L.k
//
//  Created by noah davidson on 12/13/17.
//  Copyright © 2017 noah davidson. All rights reserved.
//

import UIKit

/*
class HomeViewController : UIViewController, UICollectionViewDataSource, UICollectionViewDelegate{
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    var collectionViewLayout: CustomImageFlowLayout!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionViewLayout = CustomImageFlowLayout()
        collectionView.collectionViewLayout = collectionViewLayout
        collectionView.backgroundColor = .white
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 25
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ImageCollectionViewCell
        
        let imageName = (indexPath.row % 2 == 0) ? "image1" : "image2"
        
        cell.imageView.image = UIImage(named: imageName)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "openDetailView", sender: collectionView.cellForItem(at: indexPath))
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "openDetailView" {
            let cell = sender as? ImageCollectionViewCell
            let detailVC = segue.destination as! DetailedImageViewController

            //THIS IS WHERE YOU DO GET REQUEST ON MESSAGES AND WHATEVER YOU NEED TO PASS FROM CELL DATA

            detailVC.selectedItem = SelectedItem(messages: [Message(name: "BOB", text:"Hello, why is this not showing up Hello, why is this not showing up Hello, why is this not showing up Hello, why is this not showing up Hello, why is this not showing up Hello, why is this not showing up Hello, why is this not showing up Hello, why is this not showing up Hello, why is this not showing up"), Message(name: "Jerry", text:"Because i said so")], image: (cell?.imageView.image)!)
        }
    }

}
 */
