//
//  SendComment.swift
//  M.I.L.k
//
//  Created by noah davidson on 12/27/17.
//  Copyright © 2017 noah davidson. All rights reserved.
//

import Foundation
import UIKit

func createPost(image: UIImage, caption: String, completion: ((Result<Any>) -> Void)? ) {
    
    let parameters = ["location": "MY LOCATION", "caption": caption]
    
    guard let mediaImage = Media(withImage: image, forKey: "file") else {return}
    
    guard let url = URL(string: "https://milk-backend.herokuapp.com/posts") else {return}
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    
    let boundary = generateBoundary()
    
    request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
    
    let dataBody = createDataBody(withParameters: parameters, media: [mediaImage], boundary: boundary)
    request.httpBody = dataBody
    
    let session = URLSession.shared
    session.dataTask(with: request) { (data, response, error) in
        if let response = response {
            print("POST POST", response)
        }
        
        if let data = data {
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                return completion!(Result.success(json))
            } catch {
                print("FAIL POST",error)
                return completion!(Result.failure(error))
            }
        }
    }.resume()
}
