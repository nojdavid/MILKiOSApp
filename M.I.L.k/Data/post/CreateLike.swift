//
//  SendComment.swift
//  M.I.L.k
//
//  Created by noah davidson on 12/27/17.
//  Copyright © 2017 noah davidson. All rights reserved.
//

import Foundation
func createLikePost(post_id: Int, like: LikeConfig, completion:((Result<Like>) -> Void)?){
    
    let body = ["path": "/posts/\(post_id)/like", "http": "POST"]
    
    // Now let's encode out Post struct into JSON data...
    var request : URLRequest
    let encoder = JSONEncoder()
    do {
        request = try! createRequest(body: body)
        let jsonData = try encoder.encode(like)
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
                let responseObject = try? createDecoder().decode(Like.self, from: jsonData!)
                
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
