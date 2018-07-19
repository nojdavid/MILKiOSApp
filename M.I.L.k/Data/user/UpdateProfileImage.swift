//
//  SendComment.swift
//  M.I.L.k
//
//  Created by noah davidson on 12/27/17.
//  Copyright © 2017 noah davidson. All rights reserved.
//

import Foundation
import UIKit

func UpdateProfileImage(image: UIImage, completion: ((Result<Any>) -> Void)? ) {
    guard let mediaImage = Media(withImage: image, forKey: "file") else {return}
    
    guard let url = URL(string: "https://milk-backend.herokuapp.com/users/image") else {return}
    var request = URLRequest(url: url)
    request.httpMethod = "PUT"
    
    let boundary = generateBoundary()
    
    request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
    
    let dataBody = createDataBody(withParameters: nil, media: [mediaImage], boundary: boundary)
    request.httpBody = dataBody
    
    let session = URLSession.shared
    session.dataTask(with: request) { (data, response, error) in
        if let response = response {
            print("PUT USER IMAGE", response)
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
