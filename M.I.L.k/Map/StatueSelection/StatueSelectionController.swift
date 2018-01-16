//
//  StatueSelectionController.swift
//  M.I.L.k
//
//  Created by noah davidson on 12/20/17.
//  Copyright © 2017 noah davidson. All rights reserved.
//

import MapKit
import UIKit

protocol StatueSelectionControllerDelegate {
    func didSelectCell(statue: Statue)
}

class StatueSelectionController : UICollectionViewController, UICollectionViewDelegateFlowLayout  {

    var delegate: StatueSelectionControllerDelegate?
    
    let cellId = "cellId"
    
    var statues = [Statue]()
    var filteredStatues = [Statue]()

    var mapView: MKMapView? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.backgroundColor = .white
        collectionView?.layer.cornerRadius = 10
        collectionView?.register(StatueSelectionCell.self, forCellWithReuseIdentifier: cellId)
        initializeStatues()
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("touched")
        delegate?.didSelectCell(statue: filteredStatues[indexPath.item])
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 40)
    }
    
    fileprivate func initializeStatues(){
        statues = Statue.getStatues()
        filteredStatues = statues
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredStatues.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! StatueSelectionCell
        
        cell.statue = filteredStatues[indexPath.item]
        
        return cell
    }
    
    func parseAddress(selectedItem:MKPlacemark) -> String {
        // put a space between "4" and "Melrose Place"
        let firstSpace = (selectedItem.subThoroughfare != nil && selectedItem.thoroughfare != nil) ? " " : ""
        // put a comma between street and city/state
        let comma = (selectedItem.subThoroughfare != nil || selectedItem.thoroughfare != nil) && (selectedItem.subAdministrativeArea != nil || selectedItem.administrativeArea != nil) ? ", " : ""
        // put a space between "Washington" and "DC"
        let secondSpace = (selectedItem.subAdministrativeArea != nil && selectedItem.administrativeArea != nil) ? " " : ""
        let addressLine = String(
            format:"%@%@%@%@%@%@%@",
            // street number
            selectedItem.subThoroughfare ?? "",
            firstSpace,
            // street name
            selectedItem.thoroughfare ?? "",
            comma,
            // city
            selectedItem.locality ?? "",
            secondSpace,
            // state
            selectedItem.administrativeArea ?? ""
        )
        return addressLine
    }
}

extension StatueSelectionController : UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        
        guard let searchBarText = searchController.searchBar.text else {return}
        
        if searchBarText.isEmpty {
            filteredStatues = statues
        }else {
            filteredStatues = self.statues.filter { (statue) -> Bool in
                guard let result = statue.title?.lowercased().contains(searchBarText.lowercased()) else {return false}
                return result
            }
        }
        
        self.collectionView?.reloadData()
    }
}
