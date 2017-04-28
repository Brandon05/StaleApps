//
//  App.swift
//  StaleApps
//
//  Created by Brandon Sanchez on 4/25/17.
//  Copyright © 2017 Brandon Sanchez. All rights reserved.
//

import Foundation

class App: NSObject {
    
    var name: String?
    var updateDates: [String:String]?
    
    init(name: String, updateDates: [String:String]) {
        
        self.name = name
        self.updateDates = updateDates
    }
}
