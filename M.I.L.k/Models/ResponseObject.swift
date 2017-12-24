//
//  ResponseObject.swift
//  M.I.L.k
//
//  Created by noah davidson on 12/23/17.
//  Copyright © 2017 noah davidson. All rights reserved.
//

import Foundation

struct UserResponseObject: Decodable {
    let message: String
    let data: User
}

struct ErrorObject: Decodable {
    let message: String
}
