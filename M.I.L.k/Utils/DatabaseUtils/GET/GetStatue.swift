//
//  GetPost.swift
//  M.I.L.k
//
//  Created by noah davidson on 12/21/17.
//  Copyright © 2017 noah davidson. All rights reserved.
//

import Foundation

func getStatueFromDB(config: [String: Any], completion: ((Result<User>) -> Void)? ){
    var urlComponents = URLComponents()
    urlComponents.scheme = scheme
    urlComponents.host = host
    
    if (config["id"] != nil) {
        urlComponents.path = "/statues/\(config["id"])"
    } else {
        urlComponents.path = "/statues"
    }
    
    print("url:", urlComponents.url)
    guard let url = urlComponents.url else {fatalError("Could not create URL from components")}
    
    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    
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
                //print("GET USER DATA: ",responseObject.data)
                
                if responseObject.data != nil {
                    completion!(Result.success(responseObject.data!))
                }
            } catch let error as NSError {
                print("failure to decode user from JSON")
                completion!(.failure(error))
            }
        }
    }
    print("resuming task")
    task.resume()
}

