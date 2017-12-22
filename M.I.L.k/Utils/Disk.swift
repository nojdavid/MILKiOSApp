//
//  Disk.swift
//  M.I.L.k
//
//  Created by noah davidson on 12/21/17.
//  Copyright © 2017 noah davidson. All rights reserved.
//

import Foundation

func getDocumentsURL() -> URL {
    
    if let url = FileManager.default.urls(for: (.documentDirectory), in: .userDomainMask).first {
        return url
    }else {
        fatalError("Could not retrieve documents directory")
    }
}

func saveUserToDisk(user: User){
    let url = getDocumentsURL().appendingPathComponent("user.json")
    let encoder = JSONEncoder()
    
    do {
        let data = try encoder.encode(user)
        try data.write(to: url, options: [])
        print("successfully wrote user to disk", data)
    }catch{
        fatalError(error.localizedDescription)
    }
}

func getUserFromDisk() -> User {
    let url = getDocumentsURL().appendingPathComponent("user.json")
    let decoder = JSONDecoder()
    
    do {
        let data = try Data(contentsOf: url, options:[])
        let user = try decoder.decode(User.self, from: data)
        print("Successfully retreived user from disk", user)
        return user
    }catch{
        fatalError(error.localizedDescription)
    }
}
