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
    
    if let queries = body["queries"] as? [String:String] {
        var queryItems = [URLQueryItem]()
        queries.forEach({ (name, value) in
            let query = URLQueryItem(name: name, value: value)
            queryItems.append(query)
        })
        urlComponents.queryItems = queryItems
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
    print("URL", url)
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
    
//    if let utf8Representation = String(data: jsonData, encoding: .utf8) {
//        print("response: ", utf8Representation)
//    } else {
//        print("no readable data received in response")
//    }
    
    return jsonData
}

//create data body for multipart POST request
typealias Parameters = [String:String]
func createDataBody(withParameters params: Parameters?, media: [Media]?, boundary: String) -> Data {
    
    let linebreak = "\r\n"
    var body = Data()
    
    if let parameters = params {
        for (key,value) in parameters {
            body.append("--\(boundary + linebreak)")
            //name = api required fields, key is its value
            body.append("Content-Disposition: form-data; name=\"\(key)\"\(linebreak + linebreak)")
            body.append("\(value + linebreak)")
        }
    }
    
    if let media = media {
        for photo in media {
            body.append("--\(boundary + linebreak)")
            body.append("Content-Disposition: form-data; name\"\(photo.key)\"; filename=\"\(photo.filename)\"\(linebreak)")
            body.append("Content-type: \(photo.mimetype + linebreak + linebreak)")
            body.append(photo.data)
            body.append(linebreak)
        }
    }
    
    body.append("--\(boundary)--\(linebreak)")
    
    return body
}

//generate multipart POST form boundarys
func generateBoundary() -> String {
    return "Bounday-\(NSUUID().uuidString)"
}
