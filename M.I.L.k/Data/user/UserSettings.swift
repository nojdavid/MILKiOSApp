//
//  Settings.swift
//  M.I.L.k
//
//  Created by Noah Davidson on 7/19/18.
//  Copyright © 2018 noah davidson. All rights reserved.
//

import Foundation

func UpdateUserSettings(settings: Settings, completion:((Result<User>) -> Void)?){
    let body = ["path": "/users/settings", "http": "PUT"]

    // Now let's encode out Post struct into JSON data...
    var request : URLRequest
    let encoder = JSONEncoder()
    do {
        request = try! createRequest(body: body)
        let jsonData = try encoder.encode(settings)
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
                
                //decode response object
                let responseObject = try? createDecoder().decode(User.self, from: jsonData!)
                
                //TODO not sure if this works
                if let responseObject = responseObject {
                    return completion!(Result.success(responseObject))
                } else {
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
