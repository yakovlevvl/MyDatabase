//
//  Database.swift
//  MyDatabase
//
//  Created by Vladyslav Yakovlev on 27.11.2017.
//  Copyright © 2017 Vladyslav Yakovlev. All rights reserved.
//

import UIKit

class Database: Codable {
    
    let id: String
    var name: String
    var tables = [Table]()
    
    init(name: String) {
        self.name = name
        self.id = UUID.generateId()
    }
    
}


