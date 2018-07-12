//
//  Statues.swift
//  M.I.L.k
//
//  Created by noah davidson on 12/20/17.
//  Copyright © 2017 noah davidson. All rights reserved.
//

import Foundation
import MapKit
import Contacts


class Statue: NSObject, MKAnnotation {
    let title: String?
    let locationName: String
    let discipline: String
    let coordinate: CLLocationCoordinate2D
    var placeMark: MKPlacemark?
    
    init(title: String, locationName: String, discipline: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.locationName = locationName
        self.discipline = discipline
        self.coordinate = coordinate
        //self.placeMark = placeMark
        
        super.init()
    }
    
    var imageName: String? {
        if discipline == "Sculpture" { return "Statue" }
        return "Flag"
    }
    
    var subtitle: String? {
        return locationName
    }
    
    func mapItem() -> MKMapItem {
        let addressDict = [CNPostalAddressStreetKey: subtitle!]
        let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: addressDict)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = title
        return mapItem
    }
    
    static func getPlacemark(forLocation location: CLLocationCoordinate2D, completionHandler: @escaping (CLPlacemark?, String?) -> ()) {
        let newLocation = CLLocation(latitude: location.latitude, longitude: location.longitude)
        let geocoder = CLGeocoder()
        
        geocoder.reverseGeocodeLocation(newLocation, completionHandler: {
            placemarks, error in
            
            if let err = error {
                completionHandler(nil, err.localizedDescription)
            } else if let placemarkArray = placemarks {
                if let placemark = placemarkArray.first {
                    completionHandler(placemark, nil)
                } else {
                    completionHandler(nil, "Placemark was nil")
                }
            } else {
                completionHandler(nil, "Unknown error")
            }
        })
        
    }
    
    static func generateStatues(statueModels: [StatueModel]) -> [Statue]{
        var statues = [Statue]()
        print("--generateStatues")
        for model in statueModels {
            print("MODEL:", model.title)
            guard let location = model.location else {
                continue
            }
            
            var locArr = location.components(separatedBy: ":")
            if locArr.count < 2 {
                continue
            }
            
//            print("locArr", locArr)
            
            guard let lat = Double(locArr[0].replacingOccurrences(of: "\"", with: "", options: NSString.CompareOptions.literal, range: nil)) else {
                continue
            }
            
            guard let long = Double(locArr[1].replacingOccurrences(of: "\"", with: "", options: NSString.CompareOptions.literal, range: nil)) else {
                continue
            }
 
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            
            let statue = Statue(title: model.title!, locationName: "", discipline: "Statue", coordinate: coordinate)
            
            getPlacemark(forLocation: statue.coordinate, completionHandler: { (placemark, nil) in
                if let addressDict = placemark?.postalAddress, let coordinate = placemark?.location?.coordinate {
                    statue.placeMark = MKPlacemark(coordinate: coordinate, postalAddress: addressDict)
                }
            })
            statues.append(statue)
        }
        
        return statues
    }
    
    static func parseAddress(selectedItem:MKPlacemark) -> String {
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
    
    static var StatueNames :[String] = ["Staples Center", "The Grove", "Coldwater Canyon Park", "Downtown LA Arts District", "Hammer Museum",
    "Abbot Kinney","3rd Street Promenade"," L.A. Union Station","Balboa Park", "Manhattan Beach Blvd"]
    
    /// <summary>
    /// Get Latitude and Longitutde for statue locations
    /// </summary>
    static var StatueLocation :[CLLocationCoordinate2D] = [ CLLocationCoordinate2D(latitude: 34.043017, longitude: -118.267254 ), CLLocationCoordinate2D(latitude: 34.072092, longitude: -118.357845 ), CLLocationCoordinate2D( latitude: 34.091012, longitude: -118.411746), CLLocationCoordinate2D(latitude: 34.041175,longitude: -118.238043), CLLocationCoordinate2D(latitude: 34.059646,longitude: -118.443765), CLLocationCoordinate2D(latitude: 33.989914,longitude: -118.463797), CLLocationCoordinate2D(latitude: 34.016102,longitude: -118.49654), CLLocationCoordinate2D(latitude: 34.056219,longitude: -118.236502),CLLocationCoordinate2D(latitude: 32.734148,longitude: -117.144553), CLLocationCoordinate2D(latitude: 33.887185,longitude: -118.347614)]
    /// <summary>
    /// Used to Index Statue Names and Statue Locations. 0 index all start with null
    /// </summary>
    private enum Location
    {
        case Staples_Center, The_Grove, Coldwater_Canyon_Park, Downtown_LA_Arts_Distric, Hammer_Museum, Abbot_Kinney, Third_Street_Promenade, LA_Union_Station, Balboa_Park, Manhattan_Beach_Blvd
    }

}
