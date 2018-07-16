//
//  Comment.swift
//  M.I.L.k
//
//  Created by noah davidson on 12/18/17.
//  Copyright © 2017 noah davidson. All rights reserved.
//

import Foundation

struct Comment : Codable {
    
    var text: String
    var user_id: Int?
    var id: Int?
    
    init(dictionary: [String:String]) {
        self.text = dictionary["text"] ?? ""
    }
    
//    enum CodingKeys: String, CodingKey
//    {
//        case text
//        case user_id
//        case id
//    }
}

//extension Comment: Encodable
//{
//    func encode(to encoder: Encoder) throws
//    {
//        var container = encoder.container(keyedBy: CodingKeys.self)
//        try container.encode(text, forKey: .text)
//    }
//}
//
//extension Comment: Decodable
//{
//    init(from decoder: Decoder) throws
//    {
//        let values = try decoder.container(keyedBy: CodingKeys.self)
//        text = try values.decode(String.self, forKey: .text)
//        user_id = try values.decode(Int.self, forKey: .user_id)
//        id = try values.decode(Int.self, forKey: .id)
//    }
//}
