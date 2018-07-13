//
//  Statue.swift
//  M.I.L.k
//
//  Created by Noah Davidson on 7/10/18.
//  Copyright © 2018 noah davidson. All rights reserved.
//

import Foundation

//file name has ...Model otherwise compiler error with other file in Map/

struct StatueModel : Codable{
    var id: Int?
    var title: String
    var artist_desc: String
    var artist_name: String
    var artist_url: String
    var statue_desc: String
    var location: String
    var comments: [Comment]
    var images: [Image]
    var likes: [Like]
    var created_at: Date?
    var updated_at: Date?
}
