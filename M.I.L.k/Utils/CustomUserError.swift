//
//  CustomUserError.swift
//  M.I.L.k
//
//  Created by noah davidson on 12/24/17.
//  Copyright © 2017 noah davidson. All rights reserved.
//

import Foundation
import UIKit

func customUserError (title: String, message: String) -> UIAlertController{
    
    let alertController = UIAlertController(title: title, message:
        message, preferredStyle: UIAlertControllerStyle.alert)
    alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
    return alertController
}
