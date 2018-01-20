//
//  FactsModel.swift
//  M.I.L.k
//
//  Created by noah davidson on 1/19/18.
//  Copyright © 2018 noah davidson. All rights reserved.
//

import Foundation

let FactSection1 = ["A", "B", "C"]
let FactSection2 = ["D", "E", "F"]
let FactSection3 = ["G", "H", "I"]
let FactSection4 = ["J", "K", "L"]

class FactsModel {
    var section1 = [String]()
    var section2 = [String]()
    var section3 = [String]()
    var section4 = [String]()
    
    init() {
        self.section1 = FactSection1
        self.section2 = FactSection2
        self.section3 = FactSection3
        self.section4 = FactSection4
    }
}
