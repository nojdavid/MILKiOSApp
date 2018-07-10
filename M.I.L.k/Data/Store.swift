//
//  Store.swift
//  M.I.L.k
//
//  Created by Noah Davidson on 7/10/18.
//  Copyright © 2018 noah davidson. All rights reserved.
//

import Foundation

class Store {
    // MARK: - Properties
    
    private static var store: Store = {
        let appStore = Store()
        
        // Configuration
        // ...
        
        return appStore
    }()
    
    // MARK: -
    
    var user: User?
    
    // Initialization
    
    private init() {
        
    }
    
    // MARK: - Accessors
    
    class func shared() -> Store {
        return store
    }
}
