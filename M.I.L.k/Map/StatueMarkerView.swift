//
//  StatueMarkerView.swift
//  M.I.L.k
//
//  Created by noah davidson on 12/20/17.
//  Copyright © 2017 noah davidson. All rights reserved.
//

import Foundation
import MapKit

class StatueMarkerView: MKMarkerAnnotationView {
    
    var statue: Statue?
    
    override var annotation: MKAnnotation? {
        willSet {
            guard let statue = newValue as? Statue else { return }
            self.statue = statue
            canShowCallout = false
            calloutOffset = CGPoint(x: -5, y: 5)
            let mapsButton = UIButton(frame: CGRect(origin: CGPoint.zero,
                                                    size: CGSize(width: 30, height: 30)))
            mapsButton.layer.cornerRadius = 30/2
            mapsButton.layer.borderColor = UIColor.mainBlue().cgColor
            mapsButton.setBackgroundImage(UIImage(named: "map_icon"), for: UIControlState())
            rightCalloutAccessoryView = mapsButton
            
            let detailLabel = UILabel()
            detailLabel.numberOfLines = 0
            detailLabel.font = detailLabel.font.withSize(12)
            detailLabel.text = statue.subtitle
            detailCalloutAccessoryView = detailLabel
            
            //Custom Image Inside Pin
            /*
            if let imageName = statue.imageName {
                glyphImage = UIImage(named: imageName)
            } else {
                glyphImage = nil
            }
            */
        }
    }
}

//FOR PINS WITH CUSTOM IMAGES. REGISTER THESE IN MAP CONTROLLER
/*
class StatueView: MKAnnotationView {
    override var annotation: MKAnnotation? {
        willSet {
            guard let statue = newValue as? Statue else {return}
            canShowCallout = true
            calloutOffset = CGPoint(x: -5, y: 5)
            rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            
            if let imageName = statue.imageName {
                image = UIImage(named: imageName)
            } else {
                image = nil
            }
        }
    }
}
 */
