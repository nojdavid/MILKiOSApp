//
//  User.swift
//  M.I.L.k
//
//  Created by noah davidson on 12/17/17.
//  Copyright © 2017 noah davidson. All rights reserved.
//

import Foundation

struct User : Codable{
    let uid: String
    let email: String
    let username: String
    let password: String
    let profileImageUrl: String
    
    init(username: String, password: String, email: String) {
        self.username = username
        self.password = password
        self.email = email
        self.uid = ""
        self.profileImageUrl = ""
    }
    
    init(uid: String, username: String, password: String, profileImageUrl: String) {
        self.uid = uid
        self.username = username
        self.password = password
        self.profileImageUrl = profileImageUrl
        self.email = ""
    }
    
    init(uid: String, dictionary: [String: Any]){
        self.uid = uid
        self.username = dictionary["username"] as? String ?? ""
        self.profileImageUrl = dictionary["profileImageUrl"] as? String ?? ""
        self.password = dictionary["password"] as? String ?? ""
        self.email = dictionary["email"] as? String ?? ""
    }
}
