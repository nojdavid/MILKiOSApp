//
//  StatueDetailSheetController.swift
//  M.I.L.k
//
//  Created by noah davidson on 1/16/18.
//  Copyright © 2018 noah davidson. All rights reserved.
//

import UIKit
import MapKit

protocol HandleCloseSheetDelegate {
    func handleClose(statue: Statue)
}

class StatueDetailSheetController : UIViewController {
    
    var delegate: HandleCloseSheetDelegate?
    
    var statue: Statue?{
        didSet{
            guard let statue = statue else {return}
            
            let attributedText = NSMutableAttributedString(string: (statue.title)!, attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 20)])
            
            attributedText.append(NSAttributedString(string: "\n\n",attributes:[NSAttributedStringKey.font: UIFont.systemFont(ofSize: 4)]))
            
            attributedText.append(NSAttributedString(string: "statue made by: ", attributes:[NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 14)]))
            
            attributedText.append(NSAttributedString(string: statue.artist_name!, attributes:[NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14)]))
            
            titleLabel.attributedText = attributedText
        }
    }
    
    let holdView : UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()
    
    let containerView : UIView = {
        let view = UIView()
        return view
    }()
    
    let titleLabel : UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    let closeButton : UIButton = {
        let button = UIButton(type: UIButtonType.system)
        button.setImage(#imageLiteral(resourceName: "ic_close").withRenderingMode(.alwaysOriginal), for: UIControlState.normal)
        button.addTarget(self, action: #selector(handleClose), for: .touchUpInside)
        button.backgroundColor = .lightGray
        return button
    }()
    
    @objc func handleClose(){
        delegate?.handleClose(statue: statue!)
    }
    
    let directionsButton : UIButton = {
        let button = UIButton(type: UIButtonType.system)
        //button.setTitle("Directions", for: .normal)
        let attributedText = NSMutableAttributedString(string: "Directions", attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 14), NSAttributedStringKey.foregroundColor: UIColor.white])
        button.setAttributedTitle(attributedText, for: .normal)
        button.addTarget(self, action: #selector(handleDirections), for: .touchUpInside)
        button.backgroundColor = UIColor.mainBlue()
        return button
    }()
    
    @objc func handleDirections(){
        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
        statue?.mapItem().openInMaps(launchOptions: launchOptions)
    }
    
    let fullView: CGFloat = 100
    var partialView: CGFloat {
        return UIScreen.main.bounds.height - (/*directionsButton.frame.maxY*/105 + UIApplication.shared.statusBarFrame.height + (tabBarController?.tabBar.bounds.height)!)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //view.backgroundColor = UIColor.white
        
        view.addSubview(holdView)
        holdView.anchor(top: view.topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 5, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 30, height: 5)
        holdView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        initializeContainerView()
        
        let gesture = UIPanGestureRecognizer.init(target: self, action: #selector(StatueDetailSheetController.panGesture))
        view.addGestureRecognizer(gesture)
        
        roundViews()
    }
    
    func initializeContainerView(){
        
        view.addSubview(containerView)
        containerView.anchor(top: holdView.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 5, paddingLeft: 20, paddingBottom: 5, paddingRight: 20, width: 0, height: 0)
        
        containerView.addSubview(closeButton)
        closeButton.anchor(top: containerView.topAnchor, left: nil, bottom: nil, right: containerView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 20, height: 20)
        
        containerView.addSubview(titleLabel)
        titleLabel.anchor(top: containerView.topAnchor, left: containerView.leftAnchor, bottom: nil, right: closeButton.leftAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 50)
        
        containerView.addSubview(directionsButton)
        directionsButton.anchor(top: titleLabel.bottomAnchor, left: containerView.leftAnchor, bottom: nil, right: containerView.rightAnchor, paddingTop: 5, paddingLeft: 5, paddingBottom: 0, paddingRight: 5, width: 0, height: 50)
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        prepareBackgroundView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animate(withDuration: 0.6, animations: { [weak self] in
            let frame = self?.view.frame
            let yComponent = self?.partialView
            self?.view.frame = CGRect(x: 0, y: yComponent!, width: frame!.width, height: frame!.height)
        })
    }

    @objc func panGesture(_ recognizer: UIPanGestureRecognizer) {
        
        let translation = recognizer.translation(in: self.view)
        let velocity = recognizer.velocity(in: self.view)
        let y = self.view.frame.minY
        if ( y + translation.y >= fullView) && (y + translation.y <= partialView ) {
            self.view.frame = CGRect(x: 0, y: y + translation.y, width: view.frame.width, height: view.frame.height)
            recognizer.setTranslation(CGPoint.zero, in: self.view)
        }
        
        if recognizer.state == .ended {
            var duration =  velocity.y < 0 ? Double((y - fullView) / -velocity.y) : Double((partialView - y) / velocity.y )
            
            duration = duration > 1.3 ? 1 : duration
            
            UIView.animate(withDuration: duration, delay: 0.0, options: [.allowUserInteraction], animations: {
                if  velocity.y >= 0 {
                    self.view.frame = CGRect(x: 0, y: self.partialView, width: self.view.frame.width, height: self.view.frame.height)
                } else {
                    self.view.frame = CGRect(x: 0, y: self.fullView, width: self.view.frame.width, height: self.view.frame.height)
                }
                
            }, completion: nil)
        }
    }
    
    func roundViews() {
        view.layer.cornerRadius = 20
        holdView.layer.cornerRadius = 3
        closeButton.layer.cornerRadius = 20/2
        directionsButton.layer.cornerRadius = 10
        view.clipsToBounds = true
    }
    
    func prepareBackgroundView(){
        let blurEffect = UIBlurEffect.init(style: .extraLight)
        let visualEffect = UIVisualEffectView.init(effect: blurEffect)
        let bluredView = UIVisualEffectView.init(effect: blurEffect)
        bluredView.contentView.addSubview(visualEffect)
        
        visualEffect.frame = UIScreen.main.bounds
        bluredView.frame = UIScreen.main.bounds
        
        view.insertSubview(bluredView, at: 0)
    }

}
