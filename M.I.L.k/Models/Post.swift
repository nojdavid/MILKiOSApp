//
//  Post.swift
//  M.I.L.k
//
//  Created by noah davidson on 12/16/17.
//  Copyright © 2017 noah davidson. All rights reserved.
//

import Foundation

struct Post : Codable{
    
    var id: Int
    let user_id: Int
    let location: String
    let images: [Image]
    let comments: [Comment]
    let likes: [Like]
    let creationDate: Date
    
    init(dictionary: [String: Any]) {
        self.id = dictionary["id"] as! Int
        self.user_id = dictionary["user_id"] as! Int
        self.location = dictionary["location"] as! String
        self.images = dictionary["images"] as! [Image]
        self.comments = dictionary["comments"] as! [Comment]
        self.likes = dictionary["likes"] as! [Like]
        let secondsFrom1970 = dictionary["created_at"] as? Double ?? 0
        self.creationDate = Date(timeIntervalSince1970: secondsFrom1970)
    }
}

struct PostTest: Codable {
    let userId: Int
    let id: Int
    let title: String
    let body: String
}

