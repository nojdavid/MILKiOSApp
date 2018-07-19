//
//  constants.swift
//  M.I.L.k
//
//  Created by Noah Davidson on 7/7/18.
//  Copyright © 2018 noah davidson. All rights reserved.
//

import Foundation
import UIKit

let scheme : String = "https"
let host : String = "milk-backend.herokuapp.com"

struct Media {
    let key: String
    let filename: String
    let data: Data
    let mimetype: String
    
    init?(withImage: UIImage, forKey key: String) {
        self.key = key
        self.mimetype = "image/jpeg"
        self.filename = "\(arc4random()).jpeg"
        
        guard let data = UIImageJPEGRepresentation(withImage, 0.7) else {
            return nil
        }
        
        self.data = data
    }
}


//let routes : [String:String] = ["post": "post", ]
