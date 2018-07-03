//
//  User.swift
//  M.I.L.k
//
//  Created by noah davidson on 12/17/17.
//  Copyright © 2017 noah davidson. All rights reserved.
//

import Foundation

struct CreateUser : Codable{
    let email: String
    let username: String
    let password: String
    
    init( email: String, username: String, password: String) {
        self.password = password
        self.username = username
        self.email = email
    }
}

struct LoginUser : Codable{
    let email: String
    let password: String
    
    init( email: String, password: String) {
        self.password = password
        self.email = email
    }
}

struct User : Codable{
    var id: Int
    var username: String
    var password: String
    var email: String
    var image_id: String?
    var created_at: Date
    var updated_at: Date
    
    init(dictionary: [String: Any]){
        self.id = dictionary["id"] as? Int ?? -1
        self.username = dictionary["username"] as? String ?? ""
        //self.profileImageUrl = dictionary["profileImageUrl"] as? String ?? ""
        self.password = dictionary["password"] as? String ?? ""
        self.email = dictionary["email"] as? String ?? ""
        self.created_at = dictionary["createdAt"] as? Date ?? Date()
        self.updated_at = dictionary["updatedAt"] as? Date ?? Date()
    }
 
}
