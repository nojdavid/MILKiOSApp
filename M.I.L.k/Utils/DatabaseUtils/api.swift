//
//  api.swift
//  M.I.L.k
//
//  Created by Noah Davidson on 7/7/18.
//  Copyright © 2018 noah davidson. All rights reserved.
//

import Foundation

func createRequest (body : [String: Any]) throws -> URLRequest {
    var urlComponents = URLComponents()
    urlComponents.scheme = scheme
    urlComponents.host = host
    urlComponents.path = body["path"] as! String
    
    if ((body["queries"]) != nil) {
        let queries = body["queries"] as! [String: String]
        queries.forEach({ (name, value) in
            let query = URLQueryItem(name: name, value: value)
            urlComponents.queryItems?.append(query)
        })
    }
    
    guard let url = urlComponents.url else {
        throw NSError(
            domain: "",
            code: 0,
            userInfo: [
                NSLocalizedDescriptionKey: "Could not create URL from components"
            ]
        )
    }
    
    // Specify this request as being a POST method
    var request = URLRequest(url: url)
    request.httpMethod = body["http"] as? String
    // Make sure that we include headers specifying that our request's HTTP body
    // will be JSON encoded
    var headers = request.allHTTPHeaderFields ?? [:]
    headers["Content-Type"] = "application/json"
    request.allHTTPHeaderFields = headers
    
    return request;
}

func checkResponse(responseData : Data?, responseError: Error?) throws -> Data {
    guard responseError == nil else {
        print("ResponseError")
        throw responseError!
    }
    
    guard let jsonData = responseData else {
        throw NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey : "Data was not retrieved from request"]) as Error
    }
    
    if let utf8Representation = String(data: jsonData, encoding: .utf8) {
        print("response: ", utf8Representation)
    } else {
        print("no readable data received in response")
    }
    
    return jsonData
}
