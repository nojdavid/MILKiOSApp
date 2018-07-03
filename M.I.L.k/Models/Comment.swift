//
//  Comment.swift
//  M.I.L.k
//
//  Created by noah davidson on 12/18/17.
//  Copyright © 2017 noah davidson. All rights reserved.
//

import Foundation

struct Comment : Codable {
    
    let text: String
    
    init(text: String) {
        self.text = text
    }
}
