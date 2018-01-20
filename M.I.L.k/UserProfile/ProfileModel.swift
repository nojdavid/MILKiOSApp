//
//  ProfileModel.swift
//  M.I.L.k
//
//  Created by noah davidson on 1/19/18.
//  Copyright © 2018 noah davidson. All rights reserved.
//

import Foundation

class ProfileModel {
    var posts = [Post]()
    var user: User?
    
    init(user: User) {
        self.user = user
    }
}
