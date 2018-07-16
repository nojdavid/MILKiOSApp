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
    
    init(email: String, password: String) {
        self.password = password
        self.email = email
    }
}

struct User : Codable{
    let id: Int
    let username: String
    let email: String
    let image_id: Int?
    let created_at: Date
    let updated_at: Date
    
    init(dictionary: [String: Any]){
        self.id = dictionary["id"] as? Int ?? -1
        self.username = dictionary["username"] as? String ?? ""
        self.image_id = dictionary["image_id"] as? Int ?? -1
        self.email = dictionary["email"] as? String ?? ""
        self.created_at = dictionary["created_at"] as? Date ?? Date()
        self.updated_at = dictionary["updated_at"] as? Date ?? Date()
    }
    
}
