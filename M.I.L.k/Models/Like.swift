//
//  Like.swift
//  M.I.L.k
//
//  Created by Noah Davidson on 7/3/18.
//  Copyright © 2018 noah davidson. All rights reserved.
//

import Foundation

struct Like : Codable {
    
    let is_liked: Bool
    
    init(is_liked: Bool) {
        self.is_liked = is_liked
    }
}
