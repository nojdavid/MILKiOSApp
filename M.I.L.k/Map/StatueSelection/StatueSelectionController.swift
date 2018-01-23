//
//  StatueSelectionController.swift
//  M.I.L.k
//
//  Created by noah davidson on 12/20/17.
//  Copyright © 2017 noah davidson. All rights reserved.
//

import MapKit
import UIKit

class StatueSelectionController : UITableViewController  {

    var handleMapSearchDelegate: HandleMapSearch? = nil

    var statues = [Statue]()
    var filteredStatues = [Statue]()

    var mapView: MKMapView? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView?.keyboardDismissMode = .onDrag
        tableView?.backgroundColor = .white
        tableView?.layer.cornerRadius = 10
        tableView.register(StatueSelectionCell.self, forCellReuseIdentifier: StatueSelectionCell.identifier )
        initializeStatues()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let statue = filteredStatues[indexPath.item]
        handleMapSearchDelegate?.DisplayLocation(statue: statue)
        dismiss(animated: true, completion: nil)
    }
    
    fileprivate func initializeStatues(){
        statues = Statue.getStatues()
        filteredStatues = statues
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredStatues.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: StatueSelectionCell.identifier, for: indexPath) as! StatueSelectionCell
        cell.statue = filteredStatues[indexPath.item]
        let selectedItem = filteredStatues[indexPath.item].mapItem()

        cell.statueLabel.text = selectedItem.name
        
        guard let placeMark = (cell.statue?.placeMark) else {return cell}
        cell.locationLabel.text = self.parseAddress(selectedItem: placeMark)

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
        
        self.tableView?.reloadData()
    }
}
