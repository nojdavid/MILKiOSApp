//
//  MapController.swift
//  M.I.L.k
//
//  Created by noah davidson on 12/20/17.
//  Copyright © 2017 noah davidson. All rights reserved.
//

import UIKit
import MapKit

class MapController : UIViewController, MKMapViewDelegate, StatueSelectionControllerDelegate {

    var mapView: MKMapView?
    var statues: [Statue] = []
    let locationManager = CLLocationManager()
    
    let regionRadius: CLLocationDistance = 1000
    
    let userLocationButton : UIButton = {
        let button = UIButton(type: UIButtonType.system)
        button.setImage(#imageLiteral(resourceName: "navigation").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleLocatePosition), for: .touchUpInside)
        return button
    }()
    
    @objc func handleLocatePosition(){
        centerMapOnLocation(location: locationManager.location!)
    }
    
    var statueSelection: StatueSelectionController?
    @objc func handleSelectStatue(){
        print("Handling Selecting Statue...")
        /*
        statueSelection = StatueSelectionController(collectionViewLayout: UICollectionViewFlowLayout())
        statueSelection?.delegate = self
        present(CameraController(), animated: true, completion: nil)
        animateIn()
         */
    }
    
    func didSelectCell(statue: Statue){
        print("didSelectCell")
        animateOut()
        centerMapOnLocation(location: CLLocation(latitude: statue.coordinate.latitude, longitude: statue.coordinate.longitude))
    }
    
    func animateIn(){
        let view = statueSelection!.collectionView
        view?.alpha = 0
        view?.frame = CGRect(x: 0, y: 0, width: (mapView?.bounds.width)! / 2, height: (mapView?.bounds.height)! / 2)
        view?.center = (mapView?.center)!
        
        mapView?.addSubview((view)!)
        
        
        view?.transform = CGAffineTransform.init(scaleX: 1.3, y:1.3)
        
        UIView.animate(withDuration: 0.5) {
            view?.alpha = 1
            view?.transform = CGAffineTransform.identity
        }
    }
    
    func animateOut(){
        let view = statueSelection!.collectionView
        UIView.animate(withDuration: 0.3, animations: {
            view?.transform = CGAffineTransform.init(scaleX: 1.3, y:1.3)
            view?.alpha = 0
        }) { (success:Bool) in
            view?.removeFromSuperview()
            self.statueSelection?.dismiss(animated: false, completion: nil)
        }
    }
    
    var tap: UITapGestureRecognizer?
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
        
        tap = UITapGestureRecognizer(target: self, action: #selector(dismissStatueSelection))
        tap?.cancelsTouchesInView = false
        view.addGestureRecognizer(tap!)
    }
    
    @objc func dismissStatueSelection() {
        print("touched view")
        if statueSelection != nil {
            animateOut()
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        checkLocationAuthorizationStatus()
        
        centerMapOnLocation(location: locationManager.location!)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        view.removeGestureRecognizer(tap!)
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
        statues = Statue.getStatues()
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
