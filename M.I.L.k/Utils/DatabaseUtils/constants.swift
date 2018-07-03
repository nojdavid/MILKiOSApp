//
//  constants.swift
//  M.I.L.k
//
//  Created by Noah Davidson on 7/3/18.
//  Copyright © 2018 noah davidson. All rights reserved.
//

import Foundation

enum Result<Value> {
    case success(Value)
    case failure(Error)
}

let scheme : String = "http"
let host : String = "milk-backend.herokuapp.com"
