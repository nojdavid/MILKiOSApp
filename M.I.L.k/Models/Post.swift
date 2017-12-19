//
//  Post.swift
//  M.I.L.k
//
//  Created by noah davidson on 12/16/17.
//  Copyright © 2017 noah davidson. All rights reserved.
//

import Foundation

struct Post : Codable{
    
    var id: String?
    
    let user: User
    let imageUrl: String
    let caption:String
    let creationDate: Date
    
    var hasLiked = false
    
    init(user: User, dictionary: [String: Any]) {
        self.user = user
        self.imageUrl = dictionary["imageUrl"] as? String ?? ""
        self.caption = dictionary["caption"] as? String ?? ""
        
        let secondsFrom1970 = dictionary["creationDate"] as? Double ?? 0
        self.creationDate = Date(timeIntervalSince1970: secondsFrom1970)
    }
}

