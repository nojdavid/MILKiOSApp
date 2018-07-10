//
//  SendPost.swift
//  M.I.L.k
//
//  Created by noah davidson on 12/27/17.
//  Copyright © 2017 noah davidson. All rights reserved.
//

import Foundation

//TODO but do Statues last

//func FetchStatues(dict: [String: Any]?, completion: ((Result<[Statue]>) -> Void)? ){
//
//    let body = ["path": "/statues", "http": "GET"]
//
//    var request : URLRequest
//    let encoder = JSONEncoder()
//    do {
//        request = try! createRequest(body: body)
//    } catch {
//        completion?(.failure(error))
//    }
//
//    // Create and run a URLSession data task with our JSON encoded POST request
//    let config = URLSessionConfiguration.default
//    let session = URLSession(configuration: config)
//
//    let task = session.dataTask(with: request) { (responseData, response, responseError) in
//        DispatchQueue.main.async {
//
//            let jsonData : Data?
//            do {
//                //get response data from session or catch reponse
//                jsonData = try checkResponse(responseData: responseData, responseError: responseError)
//                //decode response object
//                let responseObject = try createDecoder().decode([Statue].self, from: jsonData!)
//
//                //                let results = try jsonDecoder.decode(Drinks.self, from:drinks.data(using: .utf8)!)
//                //                for result in results.drinks {
//                //                    print(result.description)
//                //                    if let beer = result as? Beer {
//                //                        print(beer.alcohol_content)
//                //                    }
//                //                }
//
//                //if user.id == nil then no user id
//                if responseObject != nil {
//                    return completion!(Result.success(responseObject))
//                }
//
//                //throw error from response insteda
//                let errorResponse = try createDecoder().decode(ErrorResponse.self, from: jsonData!)
//                throw NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey : errorResponse.error ?? "Error"])
//            } catch {
//                completion?(.failure(error))
//            }
//        }
//    }
//    print("resuming task")
//    task.resume()
//}
