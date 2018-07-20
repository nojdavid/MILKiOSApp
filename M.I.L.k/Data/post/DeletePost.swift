//
//  DeletePost.swift
//  M.I.L.k
//
//  Created by Noah Davidson on 7/20/18.
//  Copyright © 2018 noah davidson. All rights reserved.
//

import Foundation

func DeletePost(post_id: Int, completion: ((Result<Any>) -> Void)? ){
    
    var body : [String: Any] = ["path": "/posts/\(post_id)", "http": "DELETE"]
    
    let request = try! createRequest(body: body)
    
    // Create and run a URLSession data task with our JSON encoded POST request
    let config = URLSessionConfiguration.default
    let session = URLSession(configuration: config)
    let task = session.dataTask(with: request) { (responseData, response, responseError) in
        if let response = response {
            print("POST POST", response)
        }
        
        if let data = responseData {
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                return completion!(Result.success(json))
            } catch {
                print("FAIL POST",error)
                return completion!(Result.failure(error))
            }
        }
    }
    task.resume()
}

