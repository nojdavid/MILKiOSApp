//
//  Comment.swift
//  M.I.L.k
//
//  Created by noah davidson on 12/18/17.
//  Copyright © 2017 noah davidson. All rights reserved.
//

import Foundation

struct Comment : Codable {
    
    var text: String?
    var user: User?
    var id: Int?
    
    init(dictionary: [String:Any]) {
        self.text = dictionary["text"] as? String ?? ""
        self.user = dictionary["user"] as? User ?? nil
    }
}
