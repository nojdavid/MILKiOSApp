//
//  SendComment.swift
//  M.I.L.k
//
//  Created by noah davidson on 12/27/17.
//  Copyright © 2017 noah davidson. All rights reserved.
//

import Foundation
func sendCommentToDB(post_id: Int, comment: Comment, completion:((Result<Comment>) -> Void)?){
    print("sendCommentToDB", "path: ", "/posts/\(post_id)/comment", "comment:", comment)
    let body = ["path": "/posts/\(post_id)/comment", "http": "POST"]
    
    // Now let's encode out Post struct into JSON data...
    var request : URLRequest
    let encoder = JSONEncoder()
    do {
        request = try! createRequest(body: body)
        let jsonData = try encoder.encode(comment)
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
            
            let jsonData : Data?
            do {
                //get response data from session or catch reponse
                jsonData = try checkResponse(responseData: responseData, responseError: responseError)
                print("JSON COMMENT DATA:", jsonData!)
                //decode response object
                let responseObject = try createDecoder().decode(Comment.self, from: jsonData!)
                
                return completion!(Result.success(responseObject))
                //if user.id == nil then no user id
//                if responseObject.id   {
//
//                } else {
//                    //throw error from response insteda
//                    let errorResponse = try createDecoder().decode(ErrorResponse.self, from: jsonData!)
//                    throw NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey : errorResponse.error ?? "Error"])
//                }
            } catch {
                completion?(.failure(error))
            }
        }
    }
    print("resuming task")
    task.resume()
}
