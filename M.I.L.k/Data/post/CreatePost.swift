//
//  SendComment.swift
//  M.I.L.k
//
//  Created by noah davidson on 12/27/17.
//  Copyright © 2017 noah davidson. All rights reserved.
//

import Foundation
import UIKit

func createPost(image: UIImage, caption: String, location: String?, statue_id: Int?, completion: ((Result<Any>) -> Void)? ) {
    //Todo add in statue_id as NON OPTIONAL VALUE
    
    let postLocation = location != nil ? location! : ""
    let postStatueId = statue_id != nil ? statue_id! : -1
    
    let parameters = ["location": postLocation, "caption": caption] //, "statue_id": "\(postStatueID)"
    
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
