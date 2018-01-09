//
//  Row.swift
//  MyDatabase
//
//  Created by Vladyslav Yakovlev on 08.12.2017.
//  Copyright © 2017 Vladyslav Yakovlev. All rights reserved.
//

import UIKit

class Row: Codable {
    
    let id: String
    let items: [Item]
    
    init(items: [Item]) {
        self.items = items
        self.id = UUID.generateId()
    }
}

class Item: Codable {
    
    var value: String
    let type: ColumnType
    
    init(value: String, type: ColumnType) {
        self.value = value
        self.type = type
    }
}

class Column: Codable {
    
    var name: String
    let type: ColumnType
    
    init(name: String, type: ColumnType) {
        self.name = name
        self.type = type
    }
}

