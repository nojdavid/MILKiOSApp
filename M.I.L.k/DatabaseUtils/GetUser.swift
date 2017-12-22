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
    urlComponents.path = "/get-user-by-username/:username"
    let userNameItem = URLQueryItem(name: "username", value: "\(userName)")
    urlComponents.queryItems = [userNameItem]
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
            
            let decoder = JSONDecoder()
            
            do{
                let user = try decoder.decode(User.self, from: jsonData)
                print("successfully decoded user from JSON")
                completion?(.success(user))
            }catch{
                print("failure to decode user from JSON")
                completion?(.failure(error))
            }
        }
    }
    
    task.resume()
    
}
