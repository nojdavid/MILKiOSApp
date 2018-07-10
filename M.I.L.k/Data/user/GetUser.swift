//
//  GetUser.swift
//  M.I.L.k
//
//  Created by noah davidson on 12/21/17.
//  Copyright © 2017 noah davidson. All rights reserved.
//

import Foundation

enum Result<Value> {
    case success(Value)
    case failure(Error)
}


func getUserFromDB(for userName: String, completion: ((Result<User>) -> Void)? ){
    var urlComponents = URLComponents()
    urlComponents.scheme = "https"
    urlComponents.host = "milk-backend.herokuapp.com"
    urlComponents.path = "/users/get-user-by-username/"+userName
    let userNameItem = URLQueryItem(name: "username", value: "\(userName)")
    urlComponents.queryItems = [userNameItem]
    guard let url = urlComponents.url else {fatalError("Could not create URL from components")}
    
    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    
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

