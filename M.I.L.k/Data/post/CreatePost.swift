//
//  SendComment.swift
//  M.I.L.k
//
//  Created by noah davidson on 12/27/17.
//  Copyright © 2017 noah davidson. All rights reserved.
//

import Foundation
import UIKit

typealias Parameters = [String:String]

func createPost(image: UIImage, completion: ((Result<Any>) -> Void)? ) {
    
    let parameters = ["location": "MY LOCATION"]
    
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

struct Media {
    let key: String
    let filename: String
    let data: Data
    let mimetype: String
    
    init?(withImage: UIImage, forKey key: String) {
        self.key = key
        self.mimetype = "image/jpeg"
        self.filename = "\(arc4random()).jpeg"
        
        guard let data = UIImageJPEGRepresentation(withImage, 0.7) else {
            return nil
        }
        
        self.data = data
    }
}

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

func generateBoundary() -> String {
    return "Bounday-\(NSUUID().uuidString)"
}
