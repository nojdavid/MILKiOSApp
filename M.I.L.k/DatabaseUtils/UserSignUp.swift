//
//  UserSignUp.swift
//  M.I.L.k
//
//  Created by noah davidson on 12/17/17.
//  Copyright © 2017 noah davidson. All rights reserved.
//

import Foundation

func signUpUser(user: User, completion:((Error?) -> Void)?){
    
    var urlComponents = URLComponents()
    urlComponents.scheme = "https"
    urlComponents.host = "milk-backend.herokuapp.com"
    urlComponents.path = "/new_user"
    guard let url = urlComponents.url else {fatalError("Could not create URL from components")}
    
    //specify as POST method
    var request = URLRequest(url:url)
    request.httpMethod = "POST"
    
    //include header specifying request's HTTP body will be JSON encoded
    var headers = request.allHTTPHeaderFields ?? [:]
    headers["Content-Type"] = "application/json"
    request.allHTTPHeaderFields = headers
    
    let encoder = JSONEncoder()
    do {
        let jsonData = try encoder.encode(user)
        //set request HTTP body
        request.httpBody = jsonData
        print("jsonData: ", String(data: request.httpBody!, encoding: .utf8) ?? "no body data")
    }catch{
        completion?(error)
    }
    
    //Create and run a URLSesion data task with our JSON encoded POST request
    
    let config = URLSessionConfiguration.default
    let session = URLSession(configuration: config)
    let task = session.dataTask(with: request) { (responseData, response, responseError) in
        guard responseError == nil else {
            completion?(responseError)
            return
        }
        
        //APIs usually respond with data you just sent in your POST request
        if let data = responseData, let utf8Representation = String(data: data, encoding: .utf8){
            print("response", utf8Representation)
        }else{
            print("no readable data received in response")
        }
    }
    task.resume()
}
