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
        for vs in self.childViewControllers{
            if vs.isKind(of: StatueSelectionController.self){
                return
            }
        }
        statueSelection = StatueSelectionController(collectionViewLayout: UICollectionViewFlowLayout())
        statueSelection?.delegate = self
        
        addChildViewController(statueSelection!)
        containerView.addSubview((statueSelection?.collectionView)!)
        statueSelection?.collectionView?.anchor(top: containerView.topAnchor, left: containerView.leftAnchor, bottom: containerView.bottomAnchor, right: containerView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        statueSelection?.didMove(toParentViewController: self)
        animateIn()
    }
    
    //DELEGATE PROTOCOL FROM STATUE SELECTION CONTROLLER
    func didSelectCell(statue: Statue){
        print("didSelectCell")
        animateOut()
        centerMapOnLocation(location: CLLocation(latitude: statue.coordinate.latitude, longitude: statue.coordinate.longitude))
    }
    
    func animateIn(){
        containerView.alpha = 0
        containerView.transform = CGAffineTransform.init(scaleX: 1.3, y:1.3)
        UIView.animate(withDuration: 0.5) {
            self.containerView.alpha = 1
            self.containerView.transform = CGAffineTransform.identity
        }
    }
    
    func animateOut(){
        UIView.animate(withDuration: 0.3, animations: {
            self.containerView.transform = CGAffineTransform.init(scaleX: 1.3, y:1.3)
            self.containerView.alpha = 0
        }) { (success:Bool) in
            self.statueSelection?.removeFromParentViewController()
        }
    }
    
    lazy var tap: UITapGestureRecognizer = {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(dismissStatueSelection))
        gesture.cancelsTouchesInView = false
        return gesture
    }()
    
    @objc func dismissStatueSelection() {
        for vs in self.childViewControllers{
            if vs.isKind(of: StatueSelectionController.self){
                animateOut()
            }
        }
    }
    
    var containerView = UIView()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        initializeMapView()
        mapView?.delegate = self
        
        setupMapUI()

        mapView?.register(StatueMarkerView.self,
                        forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        
        loadInitialMapData()
        mapView?.addAnnotations(statues)

        mapView?.addGestureRecognizer(tap)
        
        setupContainerView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //CHECK IF USER ALLOWS THEIR LOCATION SHOWN AND SHOW IT
        checkLocationAuthorizationStatus()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        mapView?.removeGestureRecognizer(tap)
    }
    
    fileprivate func setupMapUI(){
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "bars").withRenderingMode(.alwaysOriginal), style: UIBarButtonItemStyle.plain, target: self, action: #selector(handleSelectStatue))
        
        mapView?.addSubview(userLocationButton)
        userLocationButton.anchor(top: nil, left: nil, bottom: mapView?.bottomAnchor, right: mapView?.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 12, paddingRight: 12, width: 40, height: 40)
        userLocationButton.layer.cornerRadius = 40/2
    }
    
    fileprivate func setupContainerView(){
        containerView.alpha = 0
        view.addSubview(containerView)
        containerView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingTop: 50, paddingLeft: 25, paddingBottom: 50, paddingRight: 25, width: 0, height: 0)
    }

    func checkLocationAuthorizationStatus() {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            mapView?.showsUserLocation = true
            centerMapOnLocation(location: locationManager.location!)
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
