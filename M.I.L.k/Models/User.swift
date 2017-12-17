//
//  User.swift
//  M.I.L.k
//
//  Created by noah davidson on 12/17/17.
//  Copyright © 2017 noah davidson. All rights reserved.
//

import Foundation

struct User{
    let uid: String
    let username: String
    let profileImageUrl: String
    
    init(uid: String, dictionary: [String: Any]){
        self.uid = uid
        self.username = dictionary["username"] as? String ?? ""
        self.profileImageUrl = dictionary["profileImageUrl"] as? String ?? ""
    }
}
