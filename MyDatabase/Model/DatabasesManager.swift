//
//  File.swift
//  MyDatabase
//
//  Created by Vladyslav Yakovlev on 28.11.2017.
//  Copyright © 2017 Vladyslav Yakovlev. All rights reserved.
//

import UIKit

class DatabasesManager {
    
    var databases = [Database]()
    
    var databasesCount: Int {
        return databases.count
    }
    
    init() {
        getDatabasesFromJson()
    }
    
    func createDatabase(name: String) {
        let database = Database(name: name)
        databases.append(database)
    }
    
    func deleteDatabase(_ database: Database) {
        let removeIndex = databases.index { $0.id == database.id }
        databases.remove(at: removeIndex!)
    }
    
    func saveDatabasesToJson() {
        let data = try! JSONEncoder().encode(databases)
        let string = String(data: data, encoding: .utf8)!
        UserDefaults.standard.set(string, forKey: "Databases")
    }
    
    func getDatabasesFromJson() {
        if let data = (UserDefaults.standard.value(forKey: "Databases") as? String)?.data(using: .utf8) {
            databases = try! JSONDecoder().decode([Database].self, from: data)
        }
    }
    
}
