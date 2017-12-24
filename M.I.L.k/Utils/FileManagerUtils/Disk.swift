//
//  Disk.swift
//  M.I.L.k
//
//  Created by noah davidson on 12/21/17.
//  Copyright © 2017 noah davidson. All rights reserved.
//

import Foundation

let fileManager = FileManager()
let userPath = "user.json"

func getDocumentsURL() -> URL {
    
    if let url = FileManager.default.urls(for: (.documentDirectory), in: .userDomainMask).first {
        return url
    }else {
        fatalError("Could not retrieve documents directory")
    }
}

func saveUserToDisk(user: User){
    
    // 1. Create a url for documents-directory/posts.json
    let url = getDocumentsURL().appendingPathComponent(userPath)
    // 2. Endcode our [Post] data to JSON Data
    let encoder = JSONEncoder()
    do {
        let data = try encoder.encode(user)
        // 3. Check if posts.json already exists...
        if fileManager.fileExists(atPath: url.path) {
            // ... and if it does, remove it
            try fileManager.removeItem(at: url)
        }
        // 4. Now create posts.json with the data encoded from our array of Posts
        fileManager.createFile(atPath: url.path, contents: data, attributes: nil)
        print("SAVED USER TO DISK")
    } catch {
        print("FAILED TO SAVE USER TO DISK", error.localizedDescription)
    }
}

func getUserFromDisk() -> User? {
    
    // 1. Create a url for documents-directory/posts.json
    let url = getDocumentsURL().appendingPathComponent(userPath)
    
    // 2. Make sure posts.json exists
    if !fileManager.fileExists(atPath: url.path) {
        //fatalError("No user to get, user.json does not exist")
        return nil
    }
    
    // 3. Now that we know data exists in posts.json, retrieve that data
    if let data = fileManager.contents(atPath: url.path) {
        let decoder = JSONDecoder()
        do {
            // 4. Decode an array of Posts from this Data
            let user = try decoder.decode(User.self, from: data)
            print("RETURNING USER FROM DISK")
            return user
        } catch {
            print("FAILED TO GET USER FROM DISK", error.localizedDescription)
            return nil
        }
    } else {
        print("No data retrieved from user.json")
        return nil
    }
}

func deleteUsrFromDisk() {
    
    let url = getDocumentsURL().appendingPathComponent(userPath)
    do {
        if fileManager.fileExists(atPath: url.path) {
            try fileManager.removeItem(at: url)
            print("SUCCESSFULLY REMOVED USER FROM DISK")
        }
    }catch {
        print("FAILED TO DELETE USER TO DISK", error.localizedDescription)
    }
}
