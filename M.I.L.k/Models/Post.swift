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
    
    let id: Int?
    let user_id: Int?
    let location: String?
    let caption: String?
    let comments: [Comment]
    let images: [Image]
    let likes: [Like]
    let created_at: Date
    let updated_at: Date
    
//    init(user: User, dictionary: [String: Any]) {
//        self.imageUrl = dictionary["imageUrl"] as? String ?? ""
//        self.caption = dictionary["caption"] as? String ?? ""
//
//        let secondsFrom1970 = dictionary["creationDate"] as? Double ?? 0
//        self.creationDate = Date(timeIntervalSince1970: secondsFrom1970)
//    }
}

struct PostTest: Codable {
    let userId: Int
    let id: Int
    let title: String
    let body: String
}

