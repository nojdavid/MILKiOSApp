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

    //
    // MARK :- BUTTON
    //
    let userLocationButton : UIButton = {
        let button = UIButton(type: UIButtonType.system)
        button.setImage(#imageLiteral(resourceName: "navigation").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleLocatePosition), for: .touchUpInside)
        return button
    }()
    
    @objc func handleLocatePosition(){
        guard let location = locationManager.location?.coordinate else {return}
        centerMapOnLocation(location: location)
    }
    
    /*
    func animateIn(){
        containerView.alpha = 0
        containerView.transform = CGAffineTransform.init(scaleX: 1.3, y:1.3)
        UIView.animate(withDuration: 0.5) {
            self.containerView.alpha = 1
            self.containerView.transform = CGAffineTransform.identity
            
            //self.mapView?.alpha = 0.6
            //self.mapView?.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        }
    }
    
    func animateOut(){
        UIView.animate(withDuration: 0.3, animations: {
            self.containerView.transform = CGAffineTransform.init(scaleX: 1.3, y:1.3)
            self.containerView.alpha = 0
            
            //self.mapView?.alpha = 1
            //self.mapView?.backgroundColor = UIColor.black.withAlphaComponent(0)
        }) { (success:Bool) in
            self.statueSelection?.removeFromParentViewController()
        }
    }
    */

    let locationManager = CLLocationManager()
    var mapView: MKMapView?
    var statues: [Statue] = []
    var resultSearchController : UISearchController? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //navigationItem.title = "Map"
        view.backgroundColor = .white
        
        initializeMapView()
        initializeLocationManager()
        
        //MARK :- Add Subviews
        initializeSearchBar()
        
        mapView?.addSubview(userLocationButton)
        userLocationButton.anchor(top: nil, left: nil, bottom: mapView?.bottomAnchor, right: mapView?.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 15, paddingRight: 15, width: 40, height: 40)
        
        
        
        //MARK :- Add pin info
        loadInitialMapData()
    }
    
    func centerMapOnLocation(location: CLLocationCoordinate2D) {
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: location, span: span)
        mapView?.setRegion(region, animated: true)
    }
 
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView,
                 calloutAccessoryControlTapped control: UIControl) {
        let location = view.annotation as! Statue
        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
        location.mapItem().openInMaps(launchOptions: launchOptions)
    }
    
    fileprivate func loadInitialMapData(){
        mapView?.register(StatueMarkerView.self,
                          forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        statues = Statue.getStatues()
        mapView?.addAnnotations(statues)
    }
    
    fileprivate func initializeLocationManager(){
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters//FOR BEST ACCURACY: kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
    
    fileprivate func initializeSearchBar(){
        
        let statueSearchTable = StatueSelectionController(collectionViewLayout: UICollectionViewFlowLayout())
        statueSearchTable.mapView = mapView
        resultSearchController = UISearchController(searchResultsController: statueSearchTable)
        resultSearchController?.searchResultsUpdater = statueSearchTable
        
        let searchBar = resultSearchController!.searchBar
        searchBar.sizeToFit()
        searchBar.placeholder = "Search for Statues"
        navigationItem.titleView = resultSearchController?.searchBar
        
        resultSearchController?.hidesNavigationBarDuringPresentation = false
        resultSearchController?.dimsBackgroundDuringPresentation = true
        definesPresentationContext = true
    }
    
    fileprivate func initializeMapView(){
        
        mapView = MKMapView()
        
        mapView?.delegate = self
        mapView?.mapType = .standard
        mapView?.showsUserLocation = true
        
        mapView?.isZoomEnabled = true
        mapView?.isScrollEnabled = true
        //mapView?.center = view.center
        
        view.addSubview(mapView!)
        
        mapView?.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    }
}

extension MapController : CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            print("locaiton:: (location)")
            centerMapOnLocation(location: location.coordinate)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error:: (error)")
    }
}

extension MapController : StatueSelectionControllerDelegate {
    func didSelectCell(statue: Statue){
        print("didSelectCell")
        //animateOut()
        centerMapOnLocation(location: statue.coordinate)
    }
}
