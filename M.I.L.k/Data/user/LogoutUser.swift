//
//  LogoutUser.swift
//  M.I.L.k
//
//  Created by noah davidson on 12/27/17.
//  Copyright © 2017 noah davidson. All rights reserved.
//

import Foundation

func logoutUserFromDB(user: User, completion:((Error?) -> Void)?) {
    
    let body = ["path": "/users/signout", "http": "POST"]
    
    // Now let's encode out Post struct into JSON data...
    var request : URLRequest
    let encoder = JSONEncoder()
    do {
        request = try! createRequest(body: body)
        let jsonData = try encoder.encode(user)
        // ... and set our request's HTTP body
        request.httpBody = jsonData
    } catch {
        completion?(error)
    }
    
    // Create and run a URLSession data task with our JSON encoded POST request
    let config = URLSessionConfiguration.default
    let session = URLSession(configuration: config)
    let task = session.dataTask(with: request) { (responseData, response, responseError) in
        guard responseError == nil else {
            completion?(responseError!)
            return
        }
        
        // APIs usually respond with the data you just sent in your POST request
//        if let data = responseData, let utf8Representation = String(data: data, encoding: .utf8) {
//            print("response: ", utf8Representation)
//        } else {
//            print("no readable data received in response")
//        }
    }

    task.resume()
}
