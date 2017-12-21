//
//  MapController.swift
//  M.I.L.k
//
//  Created by noah davidson on 12/20/17.
//  Copyright © 2017 noah davidson. All rights reserved.
//

import UIKit
import MapKit

class MapController : UIViewController, MKMapViewDelegate {
    
    var mapView: MKMapView?
    var statues: [Statue] = []
    let locationManager = CLLocationManager()
    
    let regionRadius: CLLocationDistance = 1000
    let initialLocation = CLLocation(latitude: 21.282778, longitude: -157.829444)
    
    let userLocationButton : UIButton = {
        let button = UIButton(type: UIButtonType.system)
        button.setImage(#imageLiteral(resourceName: "navigation").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleLocatePosition), for: .touchUpInside)
        return button
    }()
    
    @objc func handleLocatePosition(){
        centerMapOnLocation(location: locationManager.location!)
    }
    
    @objc func handleSelectStatue(){
        print("Picking Statue To GOTO")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        initializeMapView()
        mapView?.delegate = self

        mapView?.register(StatueMarkerView.self,
                        forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        
        loadInitialMapData()
        mapView?.addAnnotations(statues)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "bars").withRenderingMode(.alwaysOriginal), style: UIBarButtonItemStyle.plain, target: self, action: #selector(handleSelectStatue))

       mapView?.addSubview(userLocationButton)
        userLocationButton.anchor(top: nil, left: nil, bottom: mapView?.bottomAnchor, right: mapView?.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 12, paddingRight: 12, width: 40, height: 40)
        userLocationButton.layer.cornerRadius = 40/2
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        checkLocationAuthorizationStatus()
        
        centerMapOnLocation(location: locationManager.location!)
    }
    
    
    func checkLocationAuthorizationStatus() {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            mapView?.showsUserLocation = true
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  regionRadius, regionRadius)
        mapView?.setRegion(coordinateRegion, animated: true)
    }
    
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView,
                 calloutAccessoryControlTapped control: UIControl) {
        let location = view.annotation as! Statue
        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
        location.mapItem().openInMaps(launchOptions: launchOptions)
    }
    
    fileprivate func loadInitialMapData(){
        for index in 0...(Statue.StatueNames.count-1){
            let statue = Statue(title: Statue.StatueNames[index], locationName: "", discipline: "Statue", coordinate: Statue.StatueLocation[index])
            statues.append(statue)
        }
    }
    
    fileprivate func initializeMapView(){
        mapView = MKMapView()
        mapView?.mapType = .standard
        mapView?.isZoomEnabled = true
        mapView?.isScrollEnabled = true
        mapView?.center = view.center
        
        view.addSubview(mapView!)
        
        mapView?.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    }
}
