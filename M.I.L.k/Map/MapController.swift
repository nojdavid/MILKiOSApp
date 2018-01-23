//
//  MapController.swift
//  M.I.L.k
//
//  Created by noah davidson on 12/20/17.
//  Copyright © 2017 noah davidson. All rights reserved.
//

import UIKit
import MapKit

protocol HandleMapSearch {
    func DisplayLocation(statue: Statue)
}

class MapController : UIViewController, MKMapViewDelegate, UISearchBarDelegate {

    //
    // MARK :- BUTTONS
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

    let locationManager = CLLocationManager()
    var mapView: MKMapView?
    var statues: [Statue] = []
    var resultSearchController : UISearchController? = nil
    var bottomSheetVC: StatueDetailSheetController? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    //MARK :- INITIAIZE MAP
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
        
        let statueSearchTable = StatueSelectionController()
        statueSearchTable.mapView = mapView
        statueSearchTable.handleMapSearchDelegate = self
        
        resultSearchController = UISearchController(searchResultsController: statueSearchTable)
        resultSearchController?.searchResultsUpdater = statueSearchTable
        
        let searchBar = resultSearchController!.searchBar
        searchBar.sizeToFit()
        searchBar.placeholder = "Search for Statues"
        navigationItem.titleView = resultSearchController?.searchBar
        
        searchBar.delegate = self
        
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
        
        view.addSubview(mapView!)
        
        mapView?.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    }
    
    //MARK :- SEARCH FUNCTIONS
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        if bottomSheetVC != nil {
            if mapView?.selectedAnnotations.isEmpty == false {
                mapView?.deselectAnnotation(mapView?.selectedAnnotations[0], animated: true)
            }
            removeBottomSheet()
            return
        }
    }
    
    //MARK :- MAP FUNCTIONS
    func centerMapOnLocation(location: CLLocationCoordinate2D) {
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: location, span: span)
        mapView?.setRegion(region, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if view.annotation is MKUserLocation
        {
            return
        }
        
        let statue = view.annotation as! Statue
        resultSearchController!.searchBar.text = statue.title
        //centerMapOnLocation(location: statue.coordinate)
        
        if bottomSheetVC != nil {
            updateBottomSheet(statue: statue)
        }else{
            addBottomSheetView(statue: statue)
        }
    }
    
    /*
     func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView,
     calloutAccessoryControlTapped control: UIControl) {
     let location = view.annotation as! Statue
     let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
     location.mapItem().openInMaps(launchOptions: launchOptions)
     }
     */
    
    //MARK :- SHEET FUNCTIONS
    func addBottomSheetView(statue: Statue) {

        // 1- Init bottomSheetVC
        bottomSheetVC = StatueDetailSheetController()
        bottomSheetVC?.delegate = self
        bottomSheetVC?.statue = statue
        
        // 2- Add bottomSheetVC as a child view
        self.addChildViewController(bottomSheetVC!)
        self.view.addSubview(bottomSheetVC!.view)
        bottomSheetVC?.didMove(toParentViewController: self)
        
        // 3- Adjust bottomSheet frame and initial position.
        let height = view.frame.height
        let width  = view.frame.width
        bottomSheetVC?.view.frame = CGRect(x: 0, y: self.view.frame.maxY, width: width, height: height)
    }
    
    func updateBottomSheet(statue: Statue){
        bottomSheetVC?.statue = statue
    }
    
    func removeBottomSheet(){
        resultSearchController!.searchBar.text = ""
        UIView.animate(withDuration: 0.6, animations: {
            let frame = self.view.frame
            self.bottomSheetVC?.view.frame = CGRect(x: 0, y: UIScreen.main.bounds.height, width: frame.width, height: frame.height)
        }) { (_) in
            self.bottomSheetVC?.view.removeFromSuperview()
            self.bottomSheetVC?.removeFromParentViewController()
            self.bottomSheetVC = nil
        }
    }
}

//MARK :- CLLocationManager
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

//MARK :- SHEET CLOSE BUTTON DELEGATE
extension MapController : HandleCloseSheetDelegate {
    func handleClose(statue: Statue) {
        removeBottomSheet()
        mapView?.deselectAnnotation(statue, animated: true)
    }
}

//MARK :- SEARCH TABLE CELL SELECT
extension MapController : HandleMapSearch {
    func DisplayLocation(statue: Statue) {
        if mapView?.selectedAnnotations.isEmpty == false {
            mapView?.deselectAnnotation(mapView?.selectedAnnotations[0], animated: true)
        }
        for s in (mapView?.annotations)! {
            if (statue.coordinate.latitude == s.coordinate.latitude) && (statue.coordinate.longitude == s.coordinate.longitude) {
                centerMapOnLocation(location: s.coordinate)
                mapView?.selectAnnotation( s, animated: true)
            }
        }
    }
}
