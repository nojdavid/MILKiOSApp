//
//  DecodeUtilities.swift
//  M.I.L.k
//
//  Created by noah davidson on 12/23/17.
//  Copyright © 2017 noah davidson. All rights reserved.
//

import Foundation


func createDecoder() -> JSONDecoder{
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSX"
    formatter.locale = Locale(identifier: "en_US_POSIX")
    
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .formatted(formatter)
    return decoder
}
