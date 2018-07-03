//
//  Image.swift
//  M.I.L.k
//
//  Created by Noah Davidson on 7/3/18.
//  Copyright © 2018 noah davidson. All rights reserved.
//

import Foundation

struct Image : Codable {
    
    let url: String
    
    init(url: String) {
        self.url = url
    }
}
