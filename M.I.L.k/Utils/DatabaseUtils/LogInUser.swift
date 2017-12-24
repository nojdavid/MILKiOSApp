//
//  LogInUser.swift
//  M.I.L.k
//
//  Created by noah davidson on 12/23/17.
//  Copyright © 2017 noah davidson. All rights reserved.
//

import Foundation

func loginUserToDB(user: LoginUser, completion:((Result<User>) -> Void)?){
    
    var urlComponents = URLComponents()
    urlComponents.scheme = "https"
    urlComponents.host = "milk-backend.herokuapp.com"
    urlComponents.path = "/users/login"
    guard let url = urlComponents.url else { fatalError("Could not create URL from components") }
    
    // Specify this request as being a POST method
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    // Make sure that we include headers specifying that our request's HTTP body
    // will be JSON encoded
    var headers = request.allHTTPHeaderFields ?? [:]
    headers["Content-Type"] = "application/json"
    request.allHTTPHeaderFields = headers
    
    // Now let's encode out Post struct into JSON data...
    let encoder = JSONEncoder()
    do {
        let jsonData = try encoder.encode(user)
        // ... and set our request's HTTP body
        request.httpBody = jsonData
        print("jsonData: ", String(data: request.httpBody!, encoding: .utf8) ?? "no body data")
    } catch {
        completion?(.failure(error))
    }
    
    // Create and run a URLSession data task with our JSON encoded POST request
    let config = URLSessionConfiguration.default
    let session = URLSession(configuration: config)
    let task = session.dataTask(with: request) { (responseData, response, responseError) in
        DispatchQueue.main.async {
            guard responseError == nil else {
                print("ResponseError")
                completion?(.failure(responseError!))
                return
            }
            
            guard let jsonData = responseData else {
                let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey : "Data was not retrieved from request"]) as Error
                completion?(.failure(error))
                print("No Data retrieved from request")
                return
            }
            
            if let utf8Representation = String(data: jsonData, encoding: .utf8) {
                print("response: ", utf8Representation)
            } else {
                print("no readable data received in response")
            }
            
            do {
                let responseObject = try createDecoder().decode(UserResponseObject.self, from: jsonData)
                //print("RESPONSE MESSAGE: ", responseObject.message)
                //print("LOGIN USER DATA: ",responseObject.data)
                completion!(.success(responseObject.data))
            } catch let error as NSError {
                print("failure to decode user from JSON")
                //error.set
                completion!(.failure(error))
            }
        }
    }
    print("resuming task")
    task.resume()
}
