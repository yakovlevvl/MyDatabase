//
//  File.swift
//  MyDatabase
//
//  Created by Vladyslav Yakovlev on 27.11.2017.
//  Copyright © 2017 Vladyslav Yakovlev. All rights reserved.
//

import UIKit

class Table: Codable {
    
    let id: String
    var name: String
    var rows = [Row]()
    let columns: [Column]
    
    init(name: String, columns: [Column]) {
        self.name = name
        self.columns = columns
        self.id = UUID.generateId()
    }
    
    var itemsCount: Int {
        return rows.count*columns.count
    }
    
    var columnsCount: Int {
        return columns.count
    }
    
    var rowsCount: Int {
        return rows.count
    }
    
    func itemFor(row: Int, column: Int) -> Item {
        let item = rows[row].items[column]
        return item
    }
}

enum ColumnType: String, Codable {
    
    case int = "Integer"
    case real = "Real"
    case string = "String"
}
