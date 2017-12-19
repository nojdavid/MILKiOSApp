//
//  Comment.swift
//  M.I.L.k
//
//  Created by noah davidson on 12/18/17.
//  Copyright © 2017 noah davidson. All rights reserved.
//

import Foundation

struct Comment{
    
    let user: User
    let text: String
    let uid: String
    
    init(user: User, dictionary: [String:Any]) {
        self.user = user
        self.text = dictionary["text"] as? String ?? ""
        self.uid = dictionary["uid"] as? String ?? ""
    }
}
