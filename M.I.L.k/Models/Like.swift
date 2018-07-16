//
//  Like.swift
//  M.I.L.k
//
//  Created by Noah Davidson on 7/8/18.
//  Copyright © 2018 noah davidson. All rights reserved.
//

import Foundation

struct LikeConfig : Codable {
    var is_liked: Bool?
}

struct Like : Codable{
    let user_id: Int
}
