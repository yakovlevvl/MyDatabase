//
//  Helper.swift
//  MyDatabase
//
//  Created by Vladyslav Yakovlev on 16.12.2017.
//  Copyright © 2017 Vladyslav Yakovlev. All rights reserved.
//

import UIKit

extension UUID {
    
    static func generateId() -> String {
        return UUID().uuidString.replacingOccurrences(of: "-", with: "").lowercased()
    }
}

enum Fonts {
    
    static let general = UIFont(name: "Circe-Bold", size: 19)!
    static let tableFont = UIFont(name: "Circe-Bold", size: 19)!
    static let actionSheet = UIFont(name: "Circe-Bold", size: 20)!
}

enum Colors {
    
    static let general = UIColor(red: 252/255, green: 252/255, blue: 252/255, alpha: 1)
    
}



