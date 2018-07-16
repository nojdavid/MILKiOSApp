//
//  LogInUser.swift
//  M.I.L.k
//
//  Created by noah davidson on 12/23/17.
//  Copyright © 2017 noah davidson. All rights reserved.
//

import Foundation

func loginUserToDB(user: LoginUser, completion:((Result<User>) -> Void)?){

    let body = ["path": "/users/signin", "http": "POST"]
    print("LOGIN USER",user)
    // Now let's encode out Post struct into JSON data...
    var request : URLRequest
    let encoder = JSONEncoder()
    do {
        request = try! createRequest(body: body)
        let jsonData = try encoder.encode(user)
        // ... and set our request's HTTP body
        request.httpBody = jsonData
//        print("jsonData: ", String(data: request.httpBody!, encoding: .utf8) ?? "no body data")
    } catch {
        completion?(.failure(error))
    }
    
    // Create and run a URLSession data task with our JSON encoded POST request
    let config = URLSessionConfiguration.default
    let session = URLSession(configuration: config)
    let task = session.dataTask(with: request) { (responseData, response, responseError) in
        DispatchQueue.main.async {
            
            let jsonData : Data?
            do {
                //get response data from session or catch reponse
                jsonData = try checkResponse(responseData: responseData, responseError: responseError)
                 print("--jsonData",jsonData)
                //decode response object
                let responseObject = try createDecoder().decode(User.self, from: jsonData!)
                print("--responseObject",responseObject)
                //if user.id == nil then no user id
                if responseObject != nil {
                    return completion!(Result.success(responseObject))
                } else {
                    //throw error from response insteda
                    let errorResponse = try createDecoder().decode(ErrorResponse.self, from: jsonData!)
                    throw NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey : errorResponse.error ?? "Error"])
                }
            } catch {
                completion?(.failure(error))
            }
        }
    }
    task.resume()
}
