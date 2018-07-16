//
//  SendPost.swift
//  M.I.L.k
//
//  Created by noah davidson on 12/27/17.
//  Copyright © 2017 noah davidson. All rights reserved.
//

import Foundation

func FetchPosts(dict: [String: String]?, completion: ((Result<[Post]>) -> Void)? ){
    
    var body : [String: Any] = ["path": "/posts", "http": "GET"]
    
    if let dict = dict {
        var queries = [String:String]()
        for (key,value) in dict {
            queries[key] = value
        }
        
        body["queries"] = queries
    }
    
    let request = try! createRequest(body: body)
    
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
                let responseObject = try? createDecoder().decode([Post].self, from: jsonData!)

                //if user.id == nil then no user id
                if let responseObject = responseObject {
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
