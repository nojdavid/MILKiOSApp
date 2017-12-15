//
//  Message.swift
//  M.I.L.k
//
//  Created by noah davidson on 12/14/17.
//  Copyright © 2017 noah davidson. All rights reserved.
//

import Foundation
import UIKit

public class Message{
    
    var userProfileImage: UIImage?
    var userName: String?
    var message: String?
    var date: NSDate?
    
    public init(name: String, text: String){
        self.userName = name
        self.message = text
    }
    
    public init(userImage: UIImage, name: String, text: String, date: NSDate) {        
        self.userProfileImage = userImage
        self.userName = name
        self.message = text
        self.date = date
    }
}
