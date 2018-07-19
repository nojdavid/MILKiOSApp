//
//  CustomImageView.swift
//  M.I.L.k
//
//  Created by noah davidson on 12/16/17.
//  Copyright © 2017 noah davidson. All rights reserved.
//

import UIKit

var imageCache = [String: UIImage]()

class CustomImageView: UIImageView {
    
    var lastURLUsedToLoadImage: String?
    
    fileprivate var activityIndicator: UIActivityIndicatorView {
        get {
            let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .white)
            activityIndicator.hidesWhenStopped = true
            activityIndicator.center = CGPoint(x:self.frame.width/2,
                                               y: self.frame.height/2)
            activityIndicator.stopAnimating()
            self.addSubview(activityIndicator)
            activityIndicator.anchor(top: nil, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
            activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
            activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            return activityIndicator
        }
    }
    
    func loadImage(urlString: String){
        lastURLUsedToLoadImage = urlString
        let activityIndicator = self.activityIndicator
        self.image = nil
        
        if let cachedImage = imageCache[urlString]{
            self.image = cachedImage
            return
        }
        
        activityIndicator.startAnimating()
        
        guard let url = URL(string: urlString) else {return}

        URLSession.shared.dataTask(with: url) { (data, response, err) in
            if let err = err {
                print("Failed to fetch post image:", err)
                DispatchQueue.main.async {
                    activityIndicator.stopAnimating()
                }
                return
            }
            
            if url.absoluteString != self.lastURLUsedToLoadImage{
                return
            }
            
            guard let imageData = data else {return}
            
            let photoImage = UIImage(data: imageData)
            
            imageCache[url.absoluteString] = photoImage
            
            DispatchQueue.main.async {
                activityIndicator.stopAnimating()
                self.image = photoImage
            }
        }.resume()
    }
}
