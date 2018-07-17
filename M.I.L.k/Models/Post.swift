//
//  Post.swift
//  M.I.L.k
//
//  Created by noah davidson on 12/16/17.
//  Copyright © 2017 noah davidson. All rights reserved.
//

import Foundation

struct Post : Codable{

//    let imageUrl: String
//    let creationDate: Date
//    var hasLiked = false
    
    var id: Int?
    var user_id: Int?
    var location: String?
    var caption: String?
    var comments: [Comment]
    var images: [Image]
    var likes: [Like]
    var created_at: Date?
    var updated_at: Date?
    
//    init(user: User, dictionary: [String: Any]) {
//        self.imageUrl = dictionary["imageUrl"] as? String ?? ""
//        self.caption = dictionary["caption"] as? String ?? ""
//
//        let secondsFrom1970 = dictionary["creationDate"] as? Double ?? 0
//        self.creationDate = Date(timeIntervalSince1970: secondsFrom1970)
//    }
}

struct PostPag : Codable {
    var count: Int?
    var rows: [Post]?
}
